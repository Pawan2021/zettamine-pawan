module "resource_group" {
  source      = "./resource-group"
  rg_name     = var.rgname
  rg_location = var.rglocation
  rg_tags     = var.rgtags
}

module "virtual_network" {
  source       = "./virtual-network"
  vnet_name    = var.rgname
  vnet_address = var.vnetadd
  res_name     = module.resource_group.rg_name_out
  res_location = module.resource_group.rg_location_out
}
