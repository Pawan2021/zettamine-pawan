resource "azurerm_resource_group" "my_rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.subnet_address
}

resource "azurerm_network_security_group" "my_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "allow-default-security"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

# -----------------------------Load Balancer-----------------------------------------------


resource "azurerm_public_ip" "lb_pip" {
  name                = var.lb_pip_name
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  allocation_method   = var.lb_pip_allocation
}

resource "azurerm_lb" "my_lb" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_be_pool" {
  loadbalancer_id = azurerm_lb.my_lb.id
  name            = "BackEndAddressPool"
}


resource "azurerm_lb_probe" "lb_hprobe" {
  loadbalancer_id = azurerm_lb.my_lb.id
  name            = "http-running-probe"
  port            = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.my_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.lb_be_pool.id ]
  probe_id = azurerm_lb_probe.lb_hprobe.id
}



# ------------------------------------------Linux VMSS----------------------------------------


resource "azurerm_linux_virtual_machine_scale_set" "my_vmss" {
  name                = "vmss-cb-dev-eus"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
  sku                 = "Standard_F2"
  instances           = 2
  admin_username      = "adminuser"
  custom_data         = filebase64("userdata.tftpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.my_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_be_pool.id]
    }

    network_security_group_id = azurerm_network_security_group.my_nsg.id
  }
}