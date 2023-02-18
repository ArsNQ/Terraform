terraform {
  required_providers {
    azurerm = {
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features { }
}
