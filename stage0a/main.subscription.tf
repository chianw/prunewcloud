# below code is for subscription creation for MCA

data "azurerm_billing_mca_account_scope" "example" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}


# create management subscription
resource "azurerm_subscription" "example" {
  subscription_name = var.subscription_name
  billing_scope_id  = data.azurerm_billing_mca_account_scope.example.id
  tags              = var.tags
}

# create connectivity subscription
resource "azurerm_subscription" "conn_subscription" {
  subscription_name = "pruconn"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.example.id
  tags              = var.tags
}


# create subscription vending app registration
resource "azuread_application" "subvending" {
  display_name = "pruncsubvending"
}

# create subscription vending service principal
resource "azuread_service_principal" "subvending" {
  client_id = azuread_application.subvending.client_id
}

# assign Contributor role for subscription vending service principal to billing account
resource "azurerm_role_assignment" "subvending" {
  scope                            = data.azurerm_billing_mca_account_scope.example.billing_account_name.id
  principal_id                     = azuread_service_principal.subvending.object_id
  principal_type                   = "ServicePrincipal"
  role_definition_name             = "Contributor"
  skip_service_principal_aad_check = true
}
