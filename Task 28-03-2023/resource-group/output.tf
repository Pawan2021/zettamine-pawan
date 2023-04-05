output "rg_name_out" {
  value = azurerm_resource_group.my_resource_group.name
}

output "rg_location_out" {
  value = azurerm_resource_group.my_resource_group.location
}

output "rg_tags_out" {
  value = azurerm_resource_group.my_resource_group.tags
}
