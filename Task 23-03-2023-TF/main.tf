# resource "azurerm_resource_group" "my_rg" {
#   count = 3
#   name = "${var.org}-${var.client}-${var.env}-${var.regi}-rg-${count.index}"
#   location = var.rg_location

#   tags = var.rg_tags
# }

# resource "azurerm_virtual_network" "my_vnet" {
#   name = "vnet"
#   resource_group_name = azurerm_resource_group.my_rg[1].name
#   location = azurerm_resource_group.my_rg[1].location
#   address_space = [ "10.10.0.0/16" ]
# }

# ----------------------------------Create Resource Group----------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "my_rg" {
  for_each = {
    "kfc"   = "East US"
    "mcd"   = "North Europe"
    "icici" = "South Central US"
  }
  name     = "${each.key}-rg"
  location = each.value
}

# ---------------------------------Create Virtual Network-----------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "my_vnet" {
  for_each = azurerm_resource_group.my_rg
  name     = "${each.key}-vnet"

  resource_group_name = azurerm_resource_group.my_rg[each.key].name
  location            = azurerm_resource_group.my_rg[each.key].location
  address_space       = ["10.10.0.0/16"]
}

# --------------------------------Create Network Security Group and Rule----------------------------------------------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "my_nsg" {
  for_each = azurerm_resource_group.my_rg

  name                = "${each.key}-nsg"
  location            = azurerm_resource_group.my_rg[each.key].location
  resource_group_name = azurerm_resource_group.my_rg[each.key].name

  security_rule {
    name                       = "${each.key}-ssh-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ---------------------------------Create Subnet-----------------------------------------------------------------------------------------------

resource "azurerm_subnet" "my_subnet" {
  for_each = azurerm_virtual_network.my_vnet
  name     = "${each.key}-subnet"

  resource_group_name  = azurerm_resource_group.my_rg[each.key].name
  virtual_network_name = azurerm_virtual_network.my_vnet[each.key].name
  address_prefixes     = ["10.10.1.0/24"]
}

# --------------------------------Network Security Group Association with Subnet-----------------------------------------------------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  for_each = azurerm_subnet.my_subnet

  subnet_id                 = azurerm_subnet.my_subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.my_nsg[each.key].id
}

# ---------------------------------Create Network Interface-----------------------------------------------------------------------------------------------

resource "azurerm_network_interface" "my_nic_interface" {
  for_each = azurerm_subnet.my_subnet
  name     = "${each.key}-nic"

  location            = azurerm_resource_group.my_rg[each.key].location
  resource_group_name = azurerm_resource_group.my_rg[each.key].name

  ip_configuration {
    name                          = "${each.key}-ip"
    subnet_id                     = azurerm_subnet.my_subnet[each.key].id
    private_ip_address_allocation = var.nic_pip_allocation
  }
}

# --------------------------------Create Linux Virtual Machine------------------------------------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "my_linux_virtual_machine" {
  for_each = azurerm_network_interface.my_nic_interface

  name                  = "${each.key}-vm"
  resource_group_name   = azurerm_resource_group.my_rg[each.key].name
  location              = azurerm_resource_group.my_rg[each.key].location
  size                  = var.vm_size
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.my_nic_interface[each.key].id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file("./.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_type
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}
