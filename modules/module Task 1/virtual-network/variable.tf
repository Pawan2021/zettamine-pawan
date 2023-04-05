variable "virtual_network_name" {
  description = "Virtual network name"
  type        = string
}

variable "virtual_network_address" {
  description = "Virtual network address"
  type        = list(string)
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "resource_group_location" {
  description = "Resource group location"
  type        = string
}
