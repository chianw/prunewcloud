data "terraform_remote_state" "stage0a_output" {
  backend = "azurerm"

  config = {
    resource_group_name  = "prutfinitrg"
    storage_account_name = "prutfinitsa"
    container_name       = "tfstate"
    key                  = "stage0a.tfstate"
  }
}


resource "azurerm_resource_group" "example" {
  provider = azurerm.mgt
  name     = "prutfrg"
  location = "australiaeast"
}

resource "azurerm_storage_account" "example" {
  provider                 = azurerm.mgt
  name                     = "prutfsa123"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_container" "example" {
  provider           = azurerm.mgt
  name               = "tfstate"
  storage_account_id = azurerm_storage_account.example.id
}