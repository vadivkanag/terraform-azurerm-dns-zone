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
