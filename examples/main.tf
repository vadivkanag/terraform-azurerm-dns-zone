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

module "resource_group_a" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v2.1.0"

  location = module.metadata.location
  names = {
    environment         = "sandbox"
    location            = "uksouth"
    market              = "uk"
    product_name        = "poc2"
    resource_group_type = "shared"
  }
  tags = module.metadata.tags
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

module "resource_group_b" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v2.1.0"

  location = module.metadata.location
  names = {
    environment         = "sandbox"
    location            = "uksouth"
    market              = "uk"
    product_name        = "poc1"
    resource_group_type = "shared"
  }
  tags = module.metadata.tags
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = module.naming.yaml

  market              = "us"
  project             = "https://github.com/Azure-Terraform/terraform-azurerm-storage-account/tree/main/example"
  location            = "eastus2"
  environment         = "sandbox"
  product_name        = "contossoweb"
  business_unit       = "infra"
  product_group       = "contoso"
  subscription_id     = ""
  subscription_type   = "dev"
  resource_group_type = "shared"
}

module "naming" {
  source = "git@github.com:Azure-Terraform/example-naming-template.git?ref=v1.0.0"
}
