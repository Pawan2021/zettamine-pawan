output "rg_name_output" {
  value = azurerm_resource_group.resource_group.name
}

output "rg_location_output" {
  value = azurerm_resource_group.resource_group.location
}

output "rg_tags_output" {
  value = azurerm_resource_group.resource_group.tags
}
