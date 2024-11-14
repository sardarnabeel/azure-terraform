#below is the provider configurations
# provider "azurerm" {
#   features {}
# }

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}
resource "time_sleep" "wait" {
  depends_on = [module.resource_group]
  create_duration = "120s"  # Adjust the time as needed (e.g., 60 seconds)
}

# module "next_resource" {
#   source = "./modules/next_module"
#   depends_on = [time_sleep.wait]
#   # other configurations...
# }
module "vnet" {
  source              = "./modules/vnet"
  depends_on          = [time_sleep.wait]
  vnet_name           = var.vnet_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  address_space       = var.address_space
}

module "public_subnet" {
  source               = "./modules/subnet"
  subnet_name          = var.public_subnet_name
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = var.public_subnet_prefix
}

module "private_subnet" {
  source               = "./modules/subnet"
  subnet_name          = var.private_subnet_name
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = var.private_subnet_prefix
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "natPublicIp"
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

module "nat_gateway" {
  source              = "./modules/nat_gateway"
  nat_gateway_name    = var.nat_gateway_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  public_ip_id        = azurerm_public_ip.nat_ip.id
  subnet_id           = module.private_subnet.subnet_id
}
module "mysql_vm" {
  source                  = "./modules/vm"
  vm_name                 = "mysql-vm"
  location                = module.resource_group.resource_group_location
  resource_group_name     = module.resource_group.resource_group_name
  subnet_id               = module.private_subnet.subnet_id
  network_security_group_id = module.mysql_nsg.network_security_group_id  # Associate MySQL NSG
  vm_size                 = "Standard_B1ms"
  admin_username          = "mysqladmin"
  ssh_public_key          = file(var.ssh_public_key_path)
  tags                    = { "Environment" = "Development" }
}

module "wordpress_vm" {
  source                  = "./modules/vm"
  vm_name                 = "wordpress-vm"
  location                = module.resource_group.resource_group_location
  resource_group_name     = module.resource_group.resource_group_name
  subnet_id               = module.public_subnet.subnet_id
  # public_ip_id            = azurerm_public_ip.wordpress_public_ip.id
  network_security_group_id = module.wordpress_nsg.network_security_group_id  # Associate WordPress NSG
  vm_size                 = "Standard_B1ms"
  admin_username          = "wordpressadmin"
  ssh_public_key          = file(var.ssh_public_key_path)
  tags                    = { "Environment" = "Development" }
}

module "wordpress_nsg" {
  source                = "./modules/wordpress_nsg"
  nsg_name              = var.wordpressnsg_name
  location              = module.resource_group.resource_group_location
  resource_group_name   = module.resource_group.resource_group_name
  source_address_prefix = "0.0.0.0/0"  # Assuming public access for HTTP
}

module "mysql_nsg" {
  source                = "./modules/mysql-nsg"
  nsg_name              = var.mysqlnsg_name
  location              = module.resource_group.resource_group_location
  resource_group_name   = module.resource_group.resource_group_name
  source_address_prefix = "10.0.1.0/24"  # Assuming this is a private IP range
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  lb_name             = var.lb_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  # subnet_id           = module.subnet.subnet_id
}

