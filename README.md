<!-- BEGIN_TF_DOCS -->

# Azure Firewall Policy module

## Examples
```hcl
module "firewall_policy" {
  source = "../firewall_policy"

  resource_group_name = "brumer-final-terraform-hub-rg"
  location            = "West Europe"
  firewall_policy = {
    name = "brumer-final-terraform-hub-firewall-policy"
    sku  = "Standard"
  }

  network_rules = jsondecode(templatefile("./firewall_policies/network_rules.json", {
    vpn_gateway_subnet_adress_prefix     = "10.11.0.0/24",
    endpoint_subnet_address_prefix       = "10.0.4.0/26",
    workspoke_main_subnet_address_prefix = "10.1.0.0/24",
    monitorspoke_subnet_address_prefix   = "10.2.0.0/24",
    monitorspoke_virtual_machine         = "10.2.0.4"
    }
  ))
}
```

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of Firewall policy. |
| <a name="output_name"></a> [name](#output\_name) | Name of Firewall policy. |
| <a name="output_object"></a> [object](#output\_object) | Object of Firewall policy. |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required)A container that holds related resources for an Azure solution. | `string` | n/a | yes |
| <a name="input_application_rules"></a> [application\_rules](#input\_application\_rules) | (Optional)List of application rules. | <pre>map(object({<br>    name     = string<br>    priority = number<br>    application_rule_collections = list(object({<br>      name     = string<br>      priority = number<br>      action   = string<br>      application_rules = list(object({<br>        name                  = string<br>        destination_fqdns     = list(string)<br>        destination_fqdn_tags = list(string)<br>        source_addresses      = list(string)<br>        terminate_tls         = bool<br>        web_categories        = list(string)<br>        source_ip_groups      = list(string)<br>        destination_addresses = list(string)<br>        description           = optional(string)<br>        protocols = list(object({<br>          type = string<br>          port = number<br>        }))<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_firewall_policy"></a> [firewall\_policy](#input\_firewall\_policy) | (Required)Manages a Firewall Policy resource that contains NAT, network, and application rule collections, and Threat Intelligence settings. | <pre>object({<br>    name                     = optional(string)<br>    sku                      = optional(string)<br>    base_policy_id           = optional(string)<br>    threat_intelligence_mode = optional(string)<br>    dns = optional(object({<br>      servers       = list(string)<br>      proxy_enabled = bool<br>    }))<br>    threat_intelligence_allowlist = optional(object({<br>      ip_addresses = list(string)<br>      fqdns        = list(string)<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_nat_rules"></a> [nat\_rules](#input\_nat\_rules) | (Optional)List of nat rules to apply to firewall. | <pre>map(object({<br>    name                  = string<br>    description           = optional(string)<br>    action                = string<br>    source_addresses      = optional(list(string))<br>    destination_ports     = list(string)<br>    destination_addresses = list(string)<br>    protocols             = list(string)<br>    translated_address    = string<br>    translated_port       = string<br>  }))</pre> | `{}` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | (Optional)List of network rules to apply to firewall. | <pre>map(object({<br>    name     = string<br>    priority = number<br>    network_rule_collections = list(object({<br>      name     = string<br>      priority = number<br>      action   = string<br>      network_rules = list(object({<br>        name                  = string<br>        protocols             = list(string)<br>        source_addresses      = list(string)<br>        source_ip_groups      = list(string)<br>        destination_ports     = list(string)<br>        destination_addresses = list(string)<br>        destination_ip_groups = list(string)<br>        destination_fqdns     = list(string)<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |



# Authors
Originally created by Omer Brumer
<!-- END_TF_DOCS -->