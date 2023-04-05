resource "azurerm_resource_group" "my_rg" {
  name = var.rg_name
  location = var.rg_location
  tags = var.rg_tag
}

resource "azurerm_virtual_network" "my_vnet" {
  name = var.vnet_name
  location = var.rg_location
  resource_group_name = var.rg_name
  address_space = var.vnet_address
}

resource "azurerm_subnet" "subnet_01" {
  name = var.subnet01_name
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = var.subnet01_address
}

resource "azurerm_subnet" "subnet_02" {
  name = var.subnet02_name
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = var.subnet02_address
}

