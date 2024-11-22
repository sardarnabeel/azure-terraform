resource "azurerm_network_security_group" "wordpress-nsg" {
  name                = var.wordpress-nsg-var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}
resource "azurerm_network_security_rule" "allow_http" {
  resource_group_name = var.resource_group_name
  name                        = "AllowHTTP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.wordpress-nsg.name
}
