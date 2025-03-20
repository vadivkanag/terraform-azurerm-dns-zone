terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 4.0"
      configuration_aliases = [azurerm.parent, azurerm.child]
    }
  }
}
