# resource "azurerm_service_plan" "my_app_01" {
#   name = var.app_01
#   location = var.app_location_01
#   resource_group_name = var.rg_name
#   os_type = var.app_01_os_type
#   sku_name = var.app_01_sku_name
# }

# resource "azurerm_windows_web_app" "my_web_app_01" {
#   name = var.web_app_01
#   location = var.app_location_01
#   resource_group_name = var.rg_name
#   service_plan_id = azurerm_service_plan.my_app_01.id

#   site_config {
#     minimum_tls_version = "1.2"
#   }

#   # application_stack {
#   #   dotnet_version = var.app_01_dotnet_ver
#   # }
# }