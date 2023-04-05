variable "vnet_name" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
  type = string
}

variable "vnet_address" {
  description = "(Required) The address prefixes to use for the subnet."
  type = list(string)
}

variable "res_name" {
  description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
  type = string
}

variable "res_location" {
  description = "(Required) The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
  type = string
}