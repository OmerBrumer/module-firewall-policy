/**
* # Azure Firewall Policy module
*/
resource "azurerm_firewall_policy" "fw-policy" {
  name                     = var.firewall_policy.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.firewall_policy.sku
  base_policy_id           = var.firewall_policy.base_policy_id
  threat_intelligence_mode = lookup(var.firewall_policy, "threat_intelligence_mode", "Alert")

  dynamic "dns" {
    for_each = var.firewall_policy.dns == null ? [] : [var.firewall_policy.dns]

    content {
      servers       = dns.value.servers
      proxy_enabled = dns.value.proxy_enabled
    }
  }

  dynamic "threat_intelligence_allowlist" {
    for_each = var.firewall_policy.threat_intelligence_allowlist == null ? [] : [var.firewall_policy.threat_intelligence_allowlist]

    content {
      ip_addresses = threat_intelligence_allowlist.value.ip_addresses
      fqdns        = threat_intelligence_allowlist.value.fqdns
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

#---------------------------------------------------------------
# Azure Firewall Policy network rules collection group
#---------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "fw-policy-network-collection" {
  for_each = var.network_rules == {} ? {} : var.network_rules

  name               = each.value["name"]
  firewall_policy_id = azurerm_firewall_policy.fw-policy.id
  priority           = each.value["priority"]
  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections

    content {
      name     = network_rule_collection.value["name"]
      priority = network_rule_collection.value["priority"]
      action   = network_rule_collection.value["action"]
      dynamic "rule" {
        for_each = network_rule_collection.value.network_rules

        content {
          name                  = rule.value["name"]
          protocols             = rule.value["protocols"]
          source_addresses      = rule.value["source_addresses"]
          source_ip_groups      = rule.value["source_ip_groups"]
          destination_ports     = rule.value["destination_ports"]
          destination_addresses = rule.value["destination_addresses"]
          destination_ip_groups = rule.value["destination_ip_groups"]
          destination_fqdns     = rule.value["destination_fqdns"]
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Azure Firewall Policy application rules collection group
#---------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "fw-policy-application-collection" {
  for_each = var.application_rules == {} ? {} : var.application_rules

  name               = each.value["name"]
  firewall_policy_id = azurerm_firewall_policy.fw-policy.id
  priority           = each.value["priority"]
  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collections

    content {
      name     = application_rule_collection.value["name"]
      priority = application_rule_collection.value["priority"]
      action   = application_rule_collection.value["action"]
      dynamic "rule" {
        for_each = application_rule_collection.value.application_rules

        content {
          name                  = rule.value["name"]
          source_addresses      = rule.value["source_addresses"]
          source_ip_groups      = rule.value["source_ip_groups"]
          terminate_tls         = rule.value["terminate_tls"]
          web_categories        = rule.value["web_categories"]
          destination_fqdns     = rule.value["destination_fqdns"]
          destination_fqdn_tags = rule.value["destination_fqdn_tags"]
          destination_addresses = rule.value["destination_addresses"]
          description           = rule.value["description"]
          dynamic "protocols" {
            for_each = rule.value["protocols"]

            content {
              type = protocols.value["type"]
              port = protocols.value["port"]
            }
          }
        }
      }
    }
  }
}

#---------------------------------------------------------------
# Azure Firewall Policy NAT rules collection group
#---------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "fw-policy-nat-collection" {
  for_each = var.nat_rules == {} ? {} : var.nat_rules

  name               = each.value["name"]
  firewall_policy_id = azurerm_firewall_policy.fw-policy.id
  priority           = each.value["priority"]
  dynamic "nat_rule_collection" {
    for_each = each.value.nat_rule_collections

    content {
      name     = nat_rule_collection.value["name"]
      priority = nat_rule_collection.value["priority"]
      action   = nat_rule_collection.value["action"]
      dynamic "rule" {
        for_each = nat_rule_collection.value.nat_rules

        content {
          name                = rule.value["name"]
          protocols           = rule.value["protocols"]
          destination_address = rule.value["destination_address"]
          destination_ports   = rule.value["destination_ports"]
          translated_address  = rule.value["translated_address"]
          translated_port     = rule.value["translated_port"]
          source_addresses    = rule.value["source_addresses"]
        }
      }
    }
  }
}