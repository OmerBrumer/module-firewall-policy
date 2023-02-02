variable "resource_group_name" {
  description = "(Required)A container that holds related resources for an Azure solution."
  type        = string
}

variable "location" {
  description = "(Required)The location to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'."
  type        = string
}

variable "firewall_policy" {
  description = "(Required)Manages a Firewall Policy resource that contains NAT, network, and application rule collections, and Threat Intelligence settings."
  type = object({
    name                     = optional(string)
    sku                      = optional(string)
    base_policy_id           = optional(string)
    threat_intelligence_mode = optional(string)
    dns = optional(object({
      servers       = list(string)
      proxy_enabled = bool
    }))
    threat_intelligence_allowlist = optional(object({
      ip_addresses = list(string)
      fqdns        = list(string)
    }))
  })
  default = null
}

variable "network_rules" {
  description = "(Optional)List of network rules to apply to firewall."
  type = map(object({
    name     = string
    priority = number
    network_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      network_rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        source_ip_groups      = list(string)
        destination_ports     = list(string)
        destination_addresses = list(string)
        destination_ip_groups = list(string)
        destination_fqdns     = list(string)
      }))
    }))
  }))
  default = {}
}

variable "application_rules" {
  description = "(Optional)List of application rules."
  type = map(object({
    name     = string
    priority = number
    application_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      application_rules = list(object({
        name                  = string
        destination_fqdns     = list(string)
        destination_fqdn_tags = list(string)
        source_addresses      = list(string)
        terminate_tls         = bool
        web_categories        = list(string)
        source_ip_groups      = list(string)
        destination_addresses = list(string)
        description           = optional(string)
        protocols = list(object({
          type = string
          port = number
        }))
      }))
    }))
  }))
  default = {}
}

variable "nat_rules" {
  description = "(Optional)List of nat rules to apply to firewall."
  type = map(object({
    name                  = string
    description           = optional(string)
    action                = string
    source_addresses      = optional(list(string))
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = {}
}