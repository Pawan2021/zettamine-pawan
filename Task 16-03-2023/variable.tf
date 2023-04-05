variable "rg_name" {
  description = "Resource Group Name"
  default = "rg-cb-dev-eus"
  type = string
}

variable "rg_location" {
  description = "Resource Group Location"
  default = "East US"
  type = string
}

variable "vnet_name" {
    description = "Virtual Network Name"
    default = "vnet-cb-dev-eus"
    type = string
}

variable "vnet_address_space" {
  description = "Virtual Network Address"
  default = ["10.10.0.0/16"]
  type = list(string)
}

variable "subnet_name" {
  description = "Subnet Name"
  default = "web-subnet"
  type = string
}

variable "subnet_address" {
  description = "Subnet Address"
  default = ["10.10.1.0/24"]
  type = list(string)
}

variable "nsg_name" {
  description = "NSG Name"
  default = "nsg01"
  type = string
}

variable "lb_pip_name" {
  description = "Load Balancer Public IP Name"
  default = "PublicIPForLB"
  type = string
}

variable "lb_pip_allocation" {
  description = "Load Balancer Public IP allocation method"
  default = "Static"
  type = string
}