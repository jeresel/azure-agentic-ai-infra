output "foundry_id" {
  description = "Microsoft Foundry account resource ID"
  value       = azapi_resource.foundry.id
}

output "project_id" {
  description = "Microsoft Foundry project resource ID"
  value       = azapi_resource.project.id
}