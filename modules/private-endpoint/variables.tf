
variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}


variable "network_interface_name" {
  type = string
}

variable "private_link_service_alias" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "private_endpoint_subnet_name" {
  description = "Name of the Private Endpoint subnet"
  type        = string
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR range for the Private Endpoint subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "Existing Azure VNet name"
  type        = string
}