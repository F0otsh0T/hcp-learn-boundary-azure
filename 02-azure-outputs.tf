output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "target_private_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.private_ip_address
}

output "target_public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

#output "ssh_private_key" {
#  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
#}

output "ssh_public_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}

output "boundary_worker_ingress_activation_key" {
  value = boundary_worker.vm_boundary_worker_ingress.controller_generated_activation_token
}

output "boundary_worker_egress_activation_key" {
  value = boundary_worker.vm_boundary_worker_egress.controller_generated_activation_token
}

output "boundary_target_public_url" {
  value = "${random_pet.example.id}-target.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
}

output "boundary_worker_inress_public_url" {
  value = "${random_pet.example.id}-worker-inress.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
}

output "boundary_worker_egress_public_url" {
  value = "${random_pet.example.id}-worker-egress.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
}

output "boundary_target_remote_public_url" {
  value = "${random_pet.example.id}-target-remote.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
}
