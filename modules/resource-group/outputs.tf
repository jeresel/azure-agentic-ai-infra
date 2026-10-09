output "name" {
  description = "Azure Resource Group name"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Azure Resource Group location"
  value       = azurerm_resource_group.main.location
}