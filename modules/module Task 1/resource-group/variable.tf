variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Name of the resource group location"
  type        = string
}

variable "resource_group_tags" {
  description = "Name of the resource group tags"
  type        = map(string)
}
