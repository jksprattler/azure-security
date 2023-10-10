terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.33.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }

  required_version = "~> 1.3.9"
}

provider "azurerm" {
  features {}
}
