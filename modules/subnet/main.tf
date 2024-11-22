resource "azurerm_subnet" "subnet" {
  name                 = var.subnet-var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.subnet-var.address_prefixes
  default_outbound_access_enabled = var.Outbound
  private_link_service_network_policies_enabled = false
  private_endpoint_network_policies = "Disabled"

}
