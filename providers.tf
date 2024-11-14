terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Specify the version compatible with your setup
    }
  }

  required_version = ">= 1.0"  # Specify the Terraform version compatible with your setup
}

provider "azurerm" {
  features {}
}
