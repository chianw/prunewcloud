data "terraform_remote_state" "stage0a_output" {
  backend = "azurerm"

  config = {
    resource_group_name  = "prutfinitrg"
    storage_account_name = "prutfinitsa"
    container_name       = "tfstate"
    key                  = "stage0a.tfstate"
  }
}


data "terraform_remote_state" "stage0b_output" {
  backend = "azurerm"

  config = {
    resource_group_name  = "prutfinitrg"
    storage_account_name = "prutfinitsa"
    container_name       = "tfstate"
    key                  = "stage0b.tfstate"
  }
}

data "azurerm_client_config" "current" {
}

# ID of tenant root group
data "azurerm_management_group" "root" {
  name = "45794f26-9e1d-4849-aa49-601317b98dc1"
}

# create ESLZ app registration
resource "azuread_application" "this" {
  display_name = "prunceslz"
}

# create ESLZ service principal
resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}


# assign Management Group Contributor, Management Group Reader, Hierarchy Settings Administrator, Resource Policy Contributor to ESLZ service principal at tenant root group
resource "azurerm_role_assignment" "mgt_group_role_assignments" {
  for_each                         = toset(var.mgt_group_roles)
  scope                            = data.azurerm_management_group.root.id
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  role_definition_name             = each.value
  skip_service_principal_aad_check = true
}


# assign Contributor role to ESLZ service principal for connectivity subscription
resource "azurerm_role_assignment" "this" {
  for_each                         = toset(var.azure_roles)
  scope                            = "/subscriptions/${data.terraform_remote_state.stage0a_output.outputs.conn_subscription_id}"
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  role_definition_name             = each.value
  skip_service_principal_aad_check = true
}

# assign Reader and Data Access role to ESLZ service principal for storage account in management subscription required to listKeys
resource "azurerm_role_assignment" "storage_data_reader" {
  scope                            = data.terraform_remote_state.stage0b_output.outputs.storage_account_id
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  role_definition_name             = "Reader and Data Access"
  skip_service_principal_aad_check = true
}


# assign Storage Blob Data Contributor role to ESLZ service principal for storage account in management subscription
resource "azurerm_role_assignment" "blob_data_contributor" {
  scope                            = data.terraform_remote_state.stage0b_output.outputs.storage_account_id
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  role_definition_name             = "Storage Blob Data Contributor"
  skip_service_principal_aad_check = true
}


data "github_repository" "this" {
  name = var.repository_name
}


resource "github_actions_environment_secret" "azure_client_id" {
  repository      = var.repository_name
  environment     = var.environments[0]
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.this.client_id
}

resource "github_actions_environment_secret" "azure_tenant_id" {
  repository      = var.repository_name
  environment     = var.environments[0]
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_environment_secret" "azure_subscription_id" {
  repository      = var.repository_name
  environment     = var.environments[0]
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.terraform_remote_state.stage0a_output.outputs.conn_subscription_id
}




resource "azuread_application_federated_identity_credential" "environments" {
  for_each       = toset(var.environments)
  application_id = "/applications/${azuread_application.this.object_id}"
  display_name   = "prunc${each.value}"
  description    = "GitHub federated identity credentials"
  subject        = "repo:${var.organization_name}/${var.repository_name}:environment:${each.value}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
}