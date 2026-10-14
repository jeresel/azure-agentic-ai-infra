variable "zone_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_link_name" {
  type = string
}

variable "virtual_network_id" {
  type = string
}

variable "private_endpoint_ip" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}