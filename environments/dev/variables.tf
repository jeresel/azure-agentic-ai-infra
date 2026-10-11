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