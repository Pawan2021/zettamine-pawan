variable "rgname" {
  default = "rg-01"
}

variable "rglocation" {
  default = "East US"
}

variable "rgtags" {
  default = {
    "environment" = "development"
  }
}

variable "vnetname" {
  default = "test"
}

variable "vnetadd" {
  default = ["10.10.0.0/16"]
}
