variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure deployment region"
  type        = string
  default     = "southeastasia"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "agentic-ai"
}

variable "foundry_user_principal_id" {
  description = "Microsoft Entra object ID of the user running the Foundry test"
  type        = string
}

# variable "private_endpoint_location" {
#   description = "Azure region for the Private Endpoint"
#   type        = string
# }

# # variable "private_endpoint_subnet_id" {
# #   description = "Subnet ID where the Private Endpoint will be deployed"
# #   type        = string
# # }

variable "elastic_private_link_service_alias" {
  description = "Elastic Cloud Azure Private Link service alias"
  type        = string
}

variable "elastic_private_dns_vnet_id" {
  description = "Existing AKS VNet ID for Elastic Private DNS"
  type        = string
}