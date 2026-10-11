output "deployment_name" {
  description = "Model deployment name"
  value       = azapi_resource.model.name
}

output "deployment_id" {
  description = "Model deployment resource ID"
  value       = azapi_resource.model.id
}