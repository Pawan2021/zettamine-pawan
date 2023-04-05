resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.rg_name}-rg"
  location = var.rg_location
  tags     = var.rg_tags
}
