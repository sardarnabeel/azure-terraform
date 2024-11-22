
ssh_public_key_path = "use ssh key path here"
Outbound-pub        = true
Outbound-pvt        = false

lb_name = {
  lb_name = "example-nat-gateway"

}

mysqlnsg_name = {
  nsg_name              = "mysql-nsg"
  source_address_prefix = "10.0.1.0/24"

}

nat-var = {
  nat_gateway_name = "example-nat-gateway"
}

rg-var = {
  resource_group_name = "test-rg"
  location            = "East US"
}
subnet-var-pub = {
  subnet_name      = "public-subnet"
  address_prefixes = ["10.0.1.0/24"]

}
subnet-var-pvt = {
  subnet_name      = "private-subnet"
  address_prefixes = ["10.0.2.0/24"]

}
mysqlvm-var = {
  vm_name = "mysql-vm"
}
wordpressvm-var = {
  vm_name = "wordpress-vm"
}

vnet-var = {
  vnet_name     = "example-vnet"
  address_space = ["10.0.0.0/16"]
}
wordpress-nsg-var = {
  nsg_name = "wordpress-nsg"
}