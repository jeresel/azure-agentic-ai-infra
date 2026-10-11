variable "foundry_account_id" {
  description = "Resource ID of the existing Microsoft Foundry account"
  type        = string
}

variable "deployment_name" {
  description = "Name of the model deployment"
  type        = string
}

variable "model_name" {
  description = "Model to deploy"
  type        = string
}

variable "model_version" {
  description = "Model version"
  type        = string
}

variable "sku_name" {
  description = "Model deployment SKU"
  type        = string
}

variable "capacity" {
  description = "Deployment capacity in SKU-specific units"
  type        = number
}