resource "azapi_resource" "model" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2024-10-01"
  name      = var.deployment_name
  parent_id = var.foundry_account_id

  body = {
    sku = {
      name     = var.sku_name
      capacity = var.capacity
    }

    properties = {
      model = {
        format  = "OpenAI"
        name    = var.model_name
        version = var.model_version
      }

      versionUpgradeOption = "NoAutoUpgrade"
    }
  }

  response_export_values = [
    "id",
    "properties.provisioningState"
  ]
}