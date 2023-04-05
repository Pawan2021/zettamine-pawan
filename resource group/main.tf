# Create the resource group
resource "azurerm_resource_group" "myrg" {
  name = "rg-zet-dev-kfc"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "myvnet" {
  name                = "vnet-zet-dev-kfc"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  address_space       = ["10.10.0.0/16"]
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "mysubnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.10.1.0/24"]
}  