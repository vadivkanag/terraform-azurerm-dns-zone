provider "azurerm" {
  alias           = "parent"
  subscription_id = var.metadata.subscription_id
  features {}
}

provider "azurerm" {
  alias           = "child"
  subscription_id = var.metadata.subscription_id
  features {}
}

module "dns_a" {
  source = "../"

  child_domain_resource_group_name  = module.resource_group_a.name
  child_domain_prefix               = "sandbox1"
  parent_domain_resource_group_name = "parent-dns-prod-eastus2"
  parent_domain                     = "<a>.azure.contosso.io"
  tags                              = module.metadata.tags
  providers = {
    azurerm.parent = azurerm.parent
    azurerm.child  = azurerm.child
  }
}

module "dns_b" {
  source = "../"

  child_domain_resource_group_name  = module.resource_group_b.name
  child_domain_prefix               = "sandbox2"
  parent_domain_resource_group_name = "parent-dns-prod-eastus2"
  parent_domain                     = "<b>.azure.contosso.io"
  tags                              = module.metadata.tags

  providers = {
    azurerm.parent = azurerm.parent
    azurerm.child  = azurerm.child
  }
}
