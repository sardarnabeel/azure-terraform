
module "resource_group" {
  source = "./modules/resource_group"
  rg-var = var.rg-var
}
resource "time_sleep" "wait" {
  depends_on      = [module.resource_group]
  create_duration = "120s"
}

module "vnet" {
  source              = "./modules/vnet"
  depends_on          = [time_sleep.wait]
  vnet-var            = var.vnet-var
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
}

module "public_subnet" {
  source               = "./modules/subnet"
  subnet-var           = var.subnet-var-pub
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name
  Outbound             = var.Outbound-pub
}

module "private_subnet" {
  source               = "./modules/subnet"
  subnet-var           = var.subnet-var-pvt
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.vnet.vnet_name
  Outbound             = var.Outbound-pvt
}

# resource "azurerm_public_ip" "nat_ip" {
#   name                = "natPublicIp"
#   location            = module.resource_group.resource_group_location
#   resource_group_name = module.resource_group.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

module "nat_gateway" {
  source              = "./modules/nat-gateway"
  nat-var             = var.nat-var
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  # public_ip_id        = azurerm_public_ip.nat_ip.id
  subnet_id = module.private_subnet.subnet_id
}
module "mysql_vm" {
  source                    = "./modules/vm"
  vm-var                    = var.mysqlvm-var
  location                  = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  subnet_id                 = module.private_subnet.subnet_id
  network_security_group_id = module.mysql_nsg.network_security_group_id # Associate MySQL NSG
  vm_size                   = "Standard_B1ms"
  admin_username            = "mysqladmin"
  ssh_public_key            = file(var.ssh_public_key_path)
  user_data                 = file("${path.module}/modules/vm/mysql-userdata.sh")
  tags                      = { "Environment" = "Development" }
}

module "wordpress_vm" {
  source                    = "./modules/vm"
  vm-var                    = var.wordpressvm-var
  location                  = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  subnet_id                 = module.public_subnet.subnet_id
  network_security_group_id = module.wordpress_nsg.network_security_group_id # Associate WordPress NSG
  vm_size                   = "Standard_B1ms"
  admin_username            = "wordpressadmin"
  ssh_public_key            = file(var.ssh_public_key_path)
  # user_data               = file("${path.module}/wordpress-userdata.sh") 
  user_data = templatefile("${path.module}/modules/vm/wordpress-userdata.sh", {
    db_ip = module.mysql_vm.vm_private_ip
  })
  tags = { "Environment" = "Development" }
}

module "wordpress_nsg" {
  source                = "./modules/wordpress_nsg"
  wordpress-nsg-var     = var.wordpress-nsg-var
  location              = module.resource_group.resource_group_location
  resource_group_name   = module.resource_group.resource_group_name
  source_address_prefix = "0.0.0.0/0" # public access for HTTP
}

module "mysql_nsg" {
  source              = "./modules/mysql-nsg"
  mysql-var           = var.mysqlnsg_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
}

module "load_balancer" {
  source              = "./modules/load_balancer"
  lb                  = var.lb_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  nic-id              = module.wordpress_vm.nicid
}

