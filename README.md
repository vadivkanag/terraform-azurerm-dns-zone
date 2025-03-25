# Azure - Delegated DNS Zone

## Introduction

This module will create a Delegated DNS Zone in an existing DNS zone in Azure. 
* The Terraform credentials being used must have access to both the child and parent subsciptions (they may be the same).
* child_domain_prefix may include multiple subdomains
  - child.domain.prefix.parent.domain

## Input

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| azurerm.child | >= 2.0.0 |
| azurerm.parent | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| child\_domain\_prefix | child domain prefix (<child\_domain\_prefix>.<parent\_domain>) | `string` | n/a | yes |
| child\_domain\_resource\_group\_name | name of the target resource group | `string` | n/a | yes |
| child\_domain\_subscription\_id | ID of the target subscription | `string` | n/a | yes |
| parent\_domain | pre-existing parent domain in which to create the NS record for the child domain | `string` | n/a | yes |
| parent\_domain\_resource\_group\_name | name of the pre-existing parent resource\_group - This is the owner of the root domain | `string` | n/a | yes |
| parent\_domain\_subscription\_id | ID of the parent subscription - This is the owner of the parent domain | `string` | n/a | yes |
| tags | Tags to be applied to resources (inclusive) | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | id of dns child zone |
| name | The DNS zone that has been delegated to you |
| resource\_group\_name | The resource group which contains the child zone |
| subscription\_id | The subscription\_id which contains the child zone |
<!--- END_TF_DOCS --->

## Example

~~~~
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

~~~~
