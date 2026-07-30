output "resource_group_name" {
  description = "The name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "vm_name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}
