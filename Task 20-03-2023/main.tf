# --------------------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "my_rg_01" {
  name = var.rg_name
  location = var.rg_location

  tags = var.rg_tags
}

# ------------------------------------------App Service 1-------------------------------------------------------------------------

resource "azurerm_service_plan" "my_app_01" {
  name = var.app_01
  resource_group_name = var.rg_name
  location = var.app_location_01
  os_type = var.app_01_os_type
  sku_name = var.app_01_sku_name
}

resource "azurerm_windows_web_app" "my_web_app_01" {
  name = var.web_app_01
  resource_group_name = var.rg_name
  location = var.app_location_01
  service_plan_id = azurerm_service_plan.my_app_01.id

  site_config {
    minimum_tls_version = "1.2"
  }
}

# -------------------------------------------------App Service 2-------------------------------------------------------------------

resource "azurerm_service_plan" "my_app_02" {
  name = var.app_02
  resource_group_name = var.rg_name
  location = var.app_location_02
  os_type = var.app_02_os_type
  sku_name = var.app_02_sku_name
}

resource "azurerm_windows_web_app" "my_web_app_02" {
  name = var.web_app_02
  resource_group_name = var.rg_name
  location = var.app_location_02
  service_plan_id = azurerm_service_plan.my_app_02.id

  site_config {
    minimum_tls_version = "1.2"
  }
}

# -----------------------------------------------Traffic Manager Profile---------------------------------------------------------------------

resource "azurerm_traffic_manager_profile" "my_traffic_manager_profile" {
  name = var.traffic_manager_profile_name
  resource_group_name = var.rg_name
  traffic_routing_method = var.atmp_traffic_routing_method

  dns_config {
    relative_name = var.traffic_manager_profile_name
    ttl = 100
  }

  monitor_config {
    protocol = var.atmp_protocol
    port = var.atmp_port
    path = var.atmp_path
    interval_in_seconds = 30
    timeout_in_seconds = 10
    tolerated_number_of_failures = 2
  }

  tags = var.traffic_manager_profile_tags
}

resource "azurerm_traffic_manager_azure_endpoint" "my_primary_web_app" {
  name = var.primary_endpoint_name
  profile_id = azurerm_traffic_manager_profile.my_traffic_manager_profile.id
  weight = var.primary_endpoint_weight
  target_resource_id = azurerm_windows_web_app.my_web_app_01.id 
  priority = var.primary_endpoint_priority
}

resource "azurerm_traffic_manager_azure_endpoint" "my_secondary_web_app" {
  name = var.secondary_endpoint_name
  profile_id = azurerm_traffic_manager_profile.my_traffic_manager_profile.id
  weight = var.secondary_endpoint_weight
  target_resource_id = azurerm_windows_web_app.my_web_app_02.id 
  priority = var.secondary_endpoint_priority
}