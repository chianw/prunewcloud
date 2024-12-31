terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.14.0, < 5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.0.2"
    }
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
  ## below block defines the backend that contains tfstate for this deployment
  backend "azurerm" {
    resource_group_name  = "prutfinitrg"
    storage_account_name = "prutfinitsa"
    container_name       = "tfstate"
    key                  = "stage0c.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  #   subscription_id = var.subscription_id
  use_oidc = true
}

provider "azurerm" {
  alias           = "mgt"
  subscription_id = data.terraform_remote_state.stage0a_output.outputs.subscription_id
  features {}
  use_oidc = true
}

provider "github" {
  owner = var.organization_name
}