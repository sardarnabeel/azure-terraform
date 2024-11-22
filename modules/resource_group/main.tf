resource "azurerm_resource_group" "rg" {
  name     = var.rg-var.resource_group_name
  location = var.rg-var.location
}
