# below code is for subscription creation for MCA

data "azurerm_billing_mca_account_scope" "example" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}


# create management subscription
resource "azurerm_subscription" "example" {
  subscription_name = "prumgt"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.example.id
  tags              = var.tags
}