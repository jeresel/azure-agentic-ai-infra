
resource "azapi_resource" "foundry" {
  type      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name      = var.account_name
  parent_id = var.resource_group_id
  location  = var.location

  schema_validation_enabled = false

  body = {
    kind = "AIServices"

    sku = {
      name = "S0"
    }

    identity = {
      type = "SystemAssigned"
    }

    properties = {
      allowProjectManagement = true
      customSubDomainName    = var.account_name
      publicNetworkAccess    = "Enabled"
      disableLocalAuth       = true
    }
  }

  response_export_values = [
    "id",
    "properties.endpoint",
    "identity.principalId"
  ]
}

resource "azapi_resource" "project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = "cloudops-ai-${var.environment}"
  parent_id = azapi_resource.foundry.id
  location  = var.location

  body = {
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      description = "Agentic AI CloudOps Assistant for AKS diagnostics"
    }
  }

  response_export_values = [
    "id",
    "identity.principalId"
  ]
}


