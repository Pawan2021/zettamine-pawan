# -----------------------------Resource Group-------------------------------------------------------------------

resource "azurerm_resource_group" "my_rg" {
  name     = "rg-03"
  location = "East US"
}

# ------------------------------Virtual Network------------------------------------------------------------------

resource "azurerm_virtual_network" "my_vnet" {
  name                = "vnet-01"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "subnet-01"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.10.1.0/24"]

  enforce_private_link_service_network_policies = true

  depends_on = [
    azurerm_virtual_network.my_vnet
  ]
}

resource "azurerm_subnet" "endpoint" {
  name                 = "endpoint"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_storage_account" "my_storage" {
  name                     = ""
  resource_group_name      = azurerm_resource_group.my_rg.name
  location                 = azurerm_resource_group.my_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.my_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "my-super-car-01"
  storage_account_name   = azurerm_storage_account.my_storage.name
  storage_container_name = azurerm_storage_container.my_storage.name
  type                   = "Block"
  source                 = file("./abc.jpg")
}