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
