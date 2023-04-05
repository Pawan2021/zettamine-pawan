module "my_rg" {
  source                  = "./resource-group"
  resource_group_name     = "${var.rg_name}-rg"
  resource_group_location = var.rg_location
  resource_group_tags     = var.rg_tags
}

module "my_vnet" {
  source                  = "./virtual-network"
  virtual_network_name    = "${var.vnet_name}-vnet"
  virtual_network_address = var.vnet_address
  resource_group_name     = module.my_rg.rg_name_output
  resource_group_location = module.my_rg.rg_location_output
}

module "my_subnet" {
  source               = "./subnet"
  subnet_name          = "${var.sub_name}-subnet"
  resource_group_name  = module.my_rg.rg_name_output
  virtual_network_name = module.my_vnet.vnet_name_output
  subnet_address       = var.sub_address
}
