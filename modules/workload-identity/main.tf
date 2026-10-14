resource "azurerm_user_assigned_identity" "this" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "aks" {
  name      = "fic-cloudops-ai-agent"
  parent_id = azurerm_user_assigned_identity.this.id

  issuer   = var.oidc_issuer_url
  subject  = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
  audience = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "foundry_inference" {
  scope                = var.foundry_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  principal_type       = "ServicePrincipal"
}