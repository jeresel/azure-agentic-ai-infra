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