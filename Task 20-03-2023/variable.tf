variable "rg_name" {
  default = "rg-zet-web"
  type = string
}

variable "rg_location" {
  default = "North Europe"
  type = string
}

variable "rg_tags" {
  default = {
    "environment" = "app-01-rg"
  }
  type = map(string)
}

# ----------------------------------------------------------

variable "app_location_01" {
  default = "North Europe"
  type = string
}

variable "app_location_02" {
  default = "UK South"
  type = string
}

# ----------------------------------------------------------

variable "app_01" {
  default = "primary-app"
  type = string
}

variable "app_01_os_type" {
  default = "Windows"
  type = string
}

variable "app_01_sku_name" {
  default = "S1"
  type = string
}

# ---------------------------------------------------------

variable "web_app_01" {
  default = "prim-norh-eu"
  type = string
}

variable "app_01_dotnet_ver" {
  default = "v7.0"
  type = string
}

# ----------------------------------------------------------

variable "app_02" {
  default = "secondary-app"
  type = string
}

variable "app_02_os_type" {
  default = "Windows"
  type = string
}

variable "app_02_sku_name" {
  default = "S1"
  type = string
}

# ---------------------------------------------------------

variable "web_app_02" {
  default = "seco-uk-soth"
  type = string
}

variable "app_02_dotnet_ver" {
  default = "v7.0"
  type = string
}

# --------------------------------------------------------

variable "traffic_manager_profile_name" {
  default = "traff-man-pro-00111"
  type = string
}

variable "atmp_traffic_routing_method" {
  default = "Priority"
  type = string
}

variable "atmp_protocol" {
  default = "HTTPS"
  type = string
}

variable "atmp_port" {
  default = 443
  type = number
}

variable "atmp_path" {
  default = "/"
  type = string
}

variable "traffic_manager_profile_tags" {
  default = {
    "environment" = "production"
  }
  type = map(string)
}


# --------------------------------------------------------

variable "primary_endpoint_name" {
  default = "primary-endpoint"
  type = string
}

variable "primary_endpoint_weight" {
  default = 100
  type = number
}

variable "primary_endpoint_priority" {
  default = 1
  type = number
}

variable "secondary_endpoint_name" {
  default = "secondary-endpoint"
  type = string
}

variable "secondary_endpoint_weight" {
  default = 100
  type = number
}

variable "secondary_endpoint_priority" {
  default = 2
  type = number
}