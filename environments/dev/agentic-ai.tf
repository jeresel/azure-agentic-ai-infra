module "resource_group" {
  source = "../../modules/resource-group"

  resource_group_name = "rg-${var.project_name}-${var.environment}"
  location            = var.location
  environment         = var.environment
}

# Existing Southeast Asia network - preserve
module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = var.location

  vnet_name     = "vnet-${var.project_name}-${var.environment}"
  address_space = ["10.20.0.0/16"]

  aks_subnet_name     = "snet-aks-${var.environment}"
  aks_subnet_prefixes = ["10.20.1.0/24"]

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# New East Asia network for AKS
module "aks_network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = "eastasia"

  vnet_name     = "vnet-agentic-ai-aks-dev"
  address_space = ["10.40.0.0/16"]

  aks_subnet_name     = "snet-aks-eastasia-dev"
  aks_subnet_prefixes = ["10.40.1.0/24"]

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Existing ACR - preserve Southeast Asia location
module "acr" {
  source = "../../modules/acr"

  acr_name            = "acragenticai${var.environment}094b"
  resource_group_name = module.resource_group.name
  location            = var.location

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# New AKS cluster in East Asia
module "aks" {
  source = "../../modules/aks"

  cluster_name        = "aks-${var.project_name}-${var.environment}"
  resource_group_name = module.resource_group.name

  location  = "eastasia"
  subnet_id = module.aks_network.aks_subnet_id

  vm_size = "Standard_D2as_v5"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Allow AKS kubelet identity to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id

  skip_service_principal_aad_check = true
}

module "foundry_llm" {
  source = "../../modules/foundry"

  resource_group_id = module.resource_group.id
  location          = "eastus2"
  project_name      = var.project_name
  environment       = var.environment
  account_name      = "foundry-agentic-ai-us2094b-dev"
}

module "foundry_deployment" {
  source = "../../modules/foundry-deployment"

  foundry_account_id = module.foundry_llm.foundry_id

  deployment_name = "gpt-4.1-mini"
  model_name      = "gpt-4.1-mini"
  model_version   = "2025-04-14"
  sku_name        = "GlobalStandard"
  capacity        = 1
}

resource "azurerm_role_assignment" "foundry_openai_user" {
  scope                = module.foundry_llm.foundry_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = var.foundry_user_principal_id
}

resource "azurerm_role_assignment" "foundry_project_user" {
  scope                = module.foundry_llm.project_id
  role_definition_name = "Foundry User"
  principal_id         = var.foundry_user_principal_id
}


module "cloudops_workload_identity" {
  source = "../../modules/workload-identity"

  resource_group_name = "rg-agentic-ai-dev"
  location            = "southeastasia"

  identity_name        = "id-cloudops-ai-agent-dev"
  oidc_issuer_url      = module.aks.oidc_issuer_url
  namespace            = "cloudops-ai"
  service_account_name = "cloudops-ai-agent"

  foundry_account_id = module.foundry_llm.foundry_id
}

module "elastic_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                   = "pe-elastic-cloudops-dev"
  network_interface_name = "pe-elastic-cloudops-dev-nic"

  location            = "eastasia"
  resource_group_name = "rg-agentic-ai-dev"

  virtual_network_name         = "vnet-agentic-ai-aks-dev"
  private_endpoint_subnet_name = "snet-elastic-pe-eastasia-dev"
  private_endpoint_subnet_cidr = "10.40.10.0/27" # Example only

  private_link_service_alias = var.elastic_private_link_service_alias

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "elastic_private_dns" {
  source = "../../modules/private-dns"

  zone_name           = "privatelink.southeastasia.azure.elastic-cloud.com"
  resource_group_name = "rg-agentic-ai-dev"
  vnet_link_name      = "link-elastic-aks-dev"

  virtual_network_id  = var.elastic_private_dns_vnet_id
  private_endpoint_ip = module.elastic_private_endpoint.private_ip_address

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

data "azurerm_client_config" "current" {}

module "elastic_key_vault" {
  source = "../../modules/key-vault"

  name                = "azure-elastic-vault"
  location            = "southeastasia"
  resource_group_name = "rg-agentic-ai-dev"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "azure_activity_eventhub" {
  source = "../../modules/event-hub"

  namespace_name      = "evhns-agentic-ai-dev"
  eventhub_name       = "azure-activity-logs"
  location            = "southeastasia"
  resource_group_name = "rg-agentic-ai-dev"
}

module "elastic_checkpoint_storage" {
  source = "../../modules/elastic-checkpoint-storage"

  storage_account_name = "stelasticagenticdev094b"
  resource_group_name  = "rg-agentic-ai-dev"
  location             = "southeastasia"
}

module "azure_activity_diagnostics" {
  source = "../../modules/azure-monitor-diagnostics"

  name            = "Ingest-diagnostic-logs"
  subscription_id = "24b9de15-144b-4166-aa90-50be978dea9b"

  eventhub_name = module.azure_activity_eventhub.eventhub_name

  eventhub_authorization_rule_id = (
    module.azure_activity_eventhub.diagnostics_rule_id
  )
}