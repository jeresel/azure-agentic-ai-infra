variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
