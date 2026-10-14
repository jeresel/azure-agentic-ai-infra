resource "azurerm_monitor_diagnostic_setting" "activity_logs" {
  name               = var.name
  target_resource_id = "/subscriptions/${var.subscription_id}"

  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "ServiceHealth"
  }
}