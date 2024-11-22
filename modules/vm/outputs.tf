output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "vm_ip_address" {
  value = azurerm_network_interface.vm_nic.private_ip_address
}
output "nicid" {
  value = azurerm_network_interface.vm_nic.id
}

output "vm_private_ip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
  description = "Private IP address of the VM"
}
