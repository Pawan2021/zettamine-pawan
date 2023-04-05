variable "rg_name" {
  default = "zettamine"
}

variable "rg_location" {
  default = "East US"
}

variable "rg_tags" {
  default = {
    "environment" = "development"
  }
}

variable "vnet_name" {
  default = "head-office"
}

variable "vnet_address" {
  default = ["10.10.0.0/16"]
}

variable "sub_name" {
  default = "azure-devops"
}

variable "sub_address" {
  default = ["10.10.1.0/24"]
}
