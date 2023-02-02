output "id" {
  description = "Id of Firewall policy."
  value       = azurerm_firewall_policy.fw-policy.id
}

output "name" {
  description = "Name of Firewall policy."
  value       = azurerm_firewall_policy.fw-policy.name
}

output "object" {
  description = "Object of Firewall policy."
  value       = azurerm_firewall_policy.fw-policy
}