# ------------------------------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

# -----------------------------Resource Group-------------------------------------------------------------------

resource "azurerm_resource_group" "my_rg" {
  name     = "rg-02"
  location = "East US"
}

# ------------------------------Virtual Network------------------------------------------------------------------

resource "azurerm_virtual_network" "my_vnet" {
  name                = "vnet-01"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

# --------------------------------Create Network Security Group and Rule----------------------------------------------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "my_nsg" {
  name                = "nsg-01"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "Allow-SSH"
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

# -----------------------------Subnet 01-------------------------------------------------------------------

resource "azurerm_subnet" "my_subnet" {
  name                 = "subnet-01"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.10.1.0/24"]

  depends_on = [
    azurerm_virtual_network.my_vnet
  ]
}

# -----------------------------Bastion Host Subnet-------------------------------------------------------------------

resource "azurerm_subnet" "my_subnet_2" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.10.2.0/24"]
}

# --------------------------------Network Security Group Association with Subnet 01-----------------------------------------------------------------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.my_subnet.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

# ---------------------------Public IP---------------------------------------------------------------------

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm_public_ip"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [
    azurerm_resource_group.my_rg
  ]
}

# ---------------------------Bastion Host---------------------------------------------------------------------

resource "azurerm_bastion_host" "my_bastion_host" {
  name                = "bastion_host-01"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.my_subnet_2.id
    public_ip_address_id = azurerm_public_ip.vm_public_ip.id
  }
}

# ---------------------------Network Interface---------------------------------------------------------------------

resource "azurerm_network_interface" "my_nic" {
  name                = "nic-01"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# --------------------------Key Vault----------------------------------------------------------------------

resource "azurerm_key_vault" "vm_key_vault" {
  name                       = "ubuntvm01"
  location                   = azurerm_resource_group.my_rg.location
  resource_group_name        = azurerm_resource_group.my_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  depends_on = [
    azurerm_resource_group.my_rg
  ]
}

# ----------------------------Key Vault Key--------------------------------------------------------------------

resource "azurerm_key_vault_secret" "ubun_vm_pub_key" {
  name         = "ubunt-vm-pub-key"
  value        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+SRaXjsLEAXb2JdLWcrPmVCUwtKnYWQXr3Sv9fvaHqZ7OlVudnt4Q48BOpyF2r5O52S+sfqsBGegnLyVwJA4cfi4HQD7PWyPorOSdyTPYeRznAU0CEkqR2YDkONwZtSnmoaTeZriFPAm1GFWonD84oYYlPdEL2tP9Ys0k6D10y+Vff/1YEVidgkRZ2Sue4Gtx175bFgdkEiBCbwXA0vj/9eW7UXZOOgndK9onm7AeW57QdvlzpoqG4j2EYkGwsSGuTX3Pd5ZCwlZlgJVpgROh24e0uwz5IaWfa1t5Q0i0ReC506AR5YHxnqJ05DEW0aGGw9QctMBgRFBQWDYe0UT5EG6EyfolW2ZbsZgfvC/F5soXC56OLxB3PRKKcYN+VYei0kNXHD5VnFKxOEn/zkPP7vd8DVUaAiyDc4fXy1zIiT2oOwh9Vf9FLPK4F6uA7V11OwD+y0PT/BsriYOfc8vCV5e2D/ty7eDpNuLVwY6gicy6+WsD8BdIXr2fp7ozht8="
  key_vault_id = azurerm_key_vault.vm_key_vault.id

  depends_on = [
    azurerm_key_vault.vm_key_vault
  ]
}

resource "azurerm_key_vault_secret" "ubun_vm_priv_key" {
  name         = "ubunt-vm-priv-key"
  value        = "${var.pri}${var.va}${var.te}"
  key_vault_id = azurerm_key_vault.vm_key_vault.id

  depends_on = [
    azurerm_key_vault.vm_key_vault
  ]
}

# -----------------------------Linux Virtual Machine-------------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "ubuntu-vm-01"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.my_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = azurerm_key_vault_secret.ubun_vm_pub_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.my_nic,
    azurerm_key_vault_secret.ubun_vm_pub_key
  ]
}