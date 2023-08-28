## // https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/credential_ssh_private_key
## // 

# // Create Boundary Credential Store - Static
resource "boundary_credential_store_static" "boundary_demo_credential_store" {
  name        = "boundary_demo_credential_store"
  description = "Boundary Demo Credential Store"
  scope_id    = boundary_scope.project.id
}

# // Create Boundary Credential SSH Private Key
resource "boundary_credential_ssh_private_key" "az_vm_01" {
  name                = "az_vm_01_private_key"
  description         = "Boundary Credential - SSH Private Key - az_vm_01"
  credential_store_id = boundary_credential_store_static.boundary_demo_credential_store.id
  username            = var.username
  private_key         = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
  #  private_key            = file("~/.ssh/id_rsa") # change to valid SSH Private Key
  #  private_key_passphrase = "optional-passphrase" # change to the passphrase of the Private Key if required
}