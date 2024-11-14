resource "azurerm_network_security_group" "mysql-nsg" {
  name                = var.mysql-var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "allow_mysql" {
  resource_group_name = var.resource_group_name
  name                        = "AllowMySQL"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = var.mysql-var.source_address_prefix
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.mysql-nsg.name
}

