output "namespace_id" {
  value = azurerm_eventhub_namespace.this.id
}

output "eventhub_name" {
  value = azurerm_eventhub.this.name
}

output "consumer_group" {
  value = azurerm_eventhub_consumer_group.elastic.name
}

output "diagnostics_rule_id" {
  value = azurerm_eventhub_namespace_authorization_rule.diagnostics.id
}

output "elastic_connection_string" {
  value     = azurerm_eventhub_authorization_rule.elastic.primary_connection_string
  sensitive = true
}