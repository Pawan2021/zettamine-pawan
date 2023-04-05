# variable "org" {
#   default = "cb"
#   type = string
# }

# variable "client" {
#   default = "kfc"
#   type = string
# }

# variable "env" {
#   default = "dev"
#   type = string
# }

# variable "regi" {
#   default = "eus"
#   type = string
# }

# variable "rg_location" {
#   default = "East US"
#   type = string
# }

# ----------------------------------------------------------------

variable "nic_pip_allocation" {
  default = "Dynamic"
  type = string
}

variable "vm_size" {
  default = "Standard_F2"
  type = string
}

variable "vm_admin_username" {
  default = "adminuser"
  type = string
}

variable "vm_os_disk_caching" {
  default = "ReadWrite"
  type = string
}

variable "vm_os_disk_storage_type" {
  default = "Standard_LRS"
  type = string
}

variable "vm_image_publisher" {
  default = "Canonical"
  type = string
}

variable "vm_image_offer" {
  default = "UbuntuServer"
  type = string
}

variable "vm_image_sku" {
  default = "16.04-LTS"
  type = string
}

variable "vm_image_version" {
  default = "latest"
  type = string
}