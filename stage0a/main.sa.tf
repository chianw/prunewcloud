resource "azurerm_resource_group" "example" {
  name     = "prutfrg"
  location = "australiaeast"
}

resource "azurerm_storage_account" "example" {
  name                     = "prutfsa123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}