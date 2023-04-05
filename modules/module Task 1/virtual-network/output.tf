output "vnet_name_output" {
  value = azurerm_virtual_network.virtual_network.name
}

output "vnet_address_output" {
  value = azurerm_virtual_network.virtual_network.address_space
}
