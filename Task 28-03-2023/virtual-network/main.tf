resource "azurerm_virtual_network" "my_virtual_network" {
  name                = "${var.vnet_name}-vnet"
  address_space       = var.vnet_address
  location            = var.res_location
  resource_group_name = var.res_name
}