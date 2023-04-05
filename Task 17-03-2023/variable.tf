variable "rg_name" {
  default = "rg-zet-dev-eus-01"
  type = string
}

variable "rg_location" {
  default = "East US"
  type = string
}

variable "rg_tag" {
  default = {
    environment = "development"
  }
  type = map(string)
}

variable "vnet_name" {
  default = "vnet-zet-dev-eus-01"
  type = string
}

variable "vnet_address" {
  default = ["10.10.0.0/16"]
  type = list(string)
}

variable "subnet01_name" {
  default = "jumbox"
  type = string
}

variable "subnet01_address" {
  default = ["10.10.1.0/24"]
}

variable "subnet02_name" {
  default = "web"
  type = string
}

variable "subnet02_address" {
  default = ["10.10.2.0/24"]
}