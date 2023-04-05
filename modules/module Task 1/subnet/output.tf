output "subnet_name_output" {
  value = azurerm_subnet.subnet.name
}

output "subnet_address_output" {
  value = azurerm_subnet.subnet.address_prefixes
}
