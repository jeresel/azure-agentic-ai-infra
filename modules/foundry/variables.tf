
variable "resource_group_id" {
  description = "Resource group ARM resource ID"
  type        = string
}

variable "location" {
  description = "Azure region for Microsoft Foundry"
  type        = string
  default     = "eastasia"
}

variable "project_name" {
  description = "Project naming prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "account_name" {
  description = "unique Microsoft Foundry account name"
  type        = string
}