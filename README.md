<!-- BEGIN_TF_DOCS -->
# Azure - Delegated DNS Zone

## Description

This module is used to create Azure Delegated/Child DNS Zones

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.child"></a> [azurerm.child](#provider\_azurerm.child) | >= 4.0 |
| <a name="provider_azurerm.parent"></a> [azurerm.parent](#provider\_azurerm.parent) | >= 4.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_child_domain_prefix"></a> [child\_domain\_prefix](#input\_child\_domain\_prefix) | child domain prefix (<child\_domain\_prefix>.<parent\_domain>) | `string` | n/a | yes |
| <a name="input_child_domain_resource_group_name"></a> [child\_domain\_resource\_group\_name](#input\_child\_domain\_resource\_group\_name) | name of the target resource group | `string` | n/a | yes |
| <a name="input_parent_domain"></a> [parent\_domain](#input\_parent\_domain) | pre-existing parent domain in which to create the NS record for the child domain | `string` | n/a | yes |
| <a name="input_parent_domain_resource_group_name"></a> [parent\_domain\_resource\_group\_name](#input\_parent\_domain\_resource\_group\_name) | name of the pre-existing parent resource\_group - This is the owner of the root domain | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources (inclusive) | `map(string)` | n/a | yes |
| <a name="input_ns_record_ttl"></a> [ns\_record\_ttl](#input\_ns\_record\_ttl) | TTL for the NS record | `number` | `300` | no |

## Example:

```
provider "azurerm" {
  alias           = "parent"
  subscription_id = "parent_zone_subscription_id"
  features {}
}

provider "azurerm" {
  alias           = "child"
  subscription_id = module.metadata.subscription_id
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
```

<!-- END_TF_DOCS -->