terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.14.0, < 5.0"
    }
  }
  ## below block defines the backend that contains tfstate for this deployment
  backend "azurerm" {
    resource_group_name  = "prutfinitrg"
    storage_account_name = "prutfinitsa"
    container_name       = "tfstate"
    key                  = "stage0a.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  #   subscription_id = var.subscription_id
  use_oidc = true
}