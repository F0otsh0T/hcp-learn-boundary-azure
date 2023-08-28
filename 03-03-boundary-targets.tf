## // https://developer.hashicorp.com/boundary/tutorials/hcp-administration/hcp-manage-targets
# // Add hosts to project.

# // Create Host Catalog
resource "boundary_host_catalog_static" "boundary_demo" {
  name        = "host_catalog-${random_pet.example.id}"
  description = "Host Catalog - Demo"
  scope_id    = boundary_scope.project.id
}

# // Create Hosts (Static)
resource "boundary_host_static" "net10_target_direct" {
  name            = "net10_target_direct"
  description     = "Boundary Host Static - Linux / 10 Network / Azure Target VM Direct via Public IP"
  address         = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
}

resource "boundary_host_static" "net10_target_connected" {
  name            = "net10_target_connected"
  description     = "Boundary Host Static - Linux / 10 Network / Azure Target VM Connected via Ingress Worker"
  address         = azurerm_linux_virtual_machine.my_terraform_vm.private_ip_address
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
}

resource "boundary_host_static" "net10_worker_ingress" {
  name            = "net10_worker_ingress"
  description     = "Boundary Host Static - Linux / Azure Ingress Worker VM"
  address         = azurerm_linux_virtual_machine.vm_boundary_worker_ingress.public_ip_address
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
}

resource "boundary_host_static" "net172_worker_egress" {
  name            = "net172_worker_egress"
  description     = "Boundary Host Static - Linux / Azure Egress Worker VM"
  address         = azurerm_linux_virtual_machine.vm_boundary_worker_egress.private_ip_address
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
}

resource "boundary_host_static" "net172_target_remote" {
  name            = "net172_target_remote"
  description     = "Boundary Host Static - Linux / Azure Target Remote VM"
  address         = azurerm_linux_virtual_machine.vm_boundary_target_remote.private_ip_address
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
}

# // Create Host Sets (Static)

resource "boundary_host_set_static" "host_set_net10_direct" {
  name            = "host_set_net10_direct"
  description     = "Host Set - Network 10 Azure Nodes - Direct"
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
  host_ids = [
    boundary_host_static.net10_target_direct.id,
    boundary_host_static.net10_worker_ingress.id
  ]
}
resource "boundary_host_set_static" "host_set_net10_connected" {
  name            = "host_set_net10_connected"
  description     = "Host Set - Network 10 Azure Nodes - Connected"
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
  host_ids = [
    boundary_host_static.net10_target_connected.id
  ]
}

resource "boundary_host_set_static" "host_set_net172_connected" {
  name            = "host_set_net172_connected"
  description     = "Host Set - Network 172 Azure Nodes - Connected"
  host_catalog_id = boundary_host_catalog_static.boundary_demo.id
  host_ids = [
    boundary_host_static.net172_worker_egress.id,
    boundary_host_static.net172_target_remote.id
  ]
}

# // Create Boundary Targets

resource "boundary_target" "net10_target_direct_tcp_22" {
  type                     = "tcp"
  name                     = "net10_target_direct_tcp_22"
  description              = "Boundary Target - Linux / Azure Target VM - Direct Public Connection - TCP 22"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.host_set_net10_direct.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
  /* injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
}

resource "boundary_target" "net10_target_direct_ssh" {
  type                     = "ssh"
  name                     = "net10_target_direct_ssh"
  description              = "Boundary Target - Linux / Azure Target VM - Direct Public Connection - SSH"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.host_set_net10_direct.id
  ]
  /* brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
}

resource "boundary_target" "net10_target_connected_ssh" {
  type                     = "ssh"
  name                     = "net10_target_connected_ssh"
  description              = "Boundary Target - Linux / Azure Target VM - Ingress Worker Connected - SSH"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  /* worker_filter     = " \"ingress\" in \"/tags/type\" " */
  ingress_worker_filter     = " \"ingress\" in \"/tags/type\" "
  /* egress_worker_filter     = " \"ingress\" in \"/tags/type\" " */
  host_source_ids = [
    boundary_host_set_static.host_set_net10_connected.id
  ]
  /* brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
}

resource "boundary_target" "net10_worker_ingress_direct_tcp_22" {
  type                     = "tcp"
  name                     = "net10_worker_ingress_direct_tcp_22"
  description              = "Boundary Target - Linux / Azure Worker Ignress VM - Direct Connection - TCP 22"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.host_set_net10_direct.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
  /* injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
}

resource "boundary_target" "net10_worker_ingress_direct_ssh" {
  type                     = "ssh"
  name                     = "net10_worker_ingress_direct_ssh"
  description              = "Boundary Target - Linux / Azure Worker VM - Direet Connection - SSH"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.host_set_net10_direct.id
  ]
  /* brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
}

resource "boundary_target" "net172_worker_egress_connected_ssh" {
  type                     = "ssh"
  name                     = "net172_worker_egress_connected_ssh"
  description              = "Boundary Target - Linux / Azure Worker Egress VM - Ingress Worker Connected - SSH"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  /* worker_filter     = " \"ingress\" in \"/tags/type\" " */
  ingress_worker_filter     = " \"ingress\" in \"/tags/type\" "
  egress_worker_filter     = " \"egress\" in \"/tags/type\" "
  host_source_ids = [
    boundary_host_set_static.host_set_net172_connected.id
  ]
  /* brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
}

resource "boundary_target" "net172_target_remote_connected_ssh" {
  type                     = "ssh"
  name                     = "net172_target_remote_connected_ssh"
  description              = "Boundary Target - Linux / Azure Target Remote VM - Ingress and Egress Worker Connected - SSH"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  /* worker_filter     = " \"ingress\" in \"/tags/type\" " */
  ingress_worker_filter     = " \"ingress\" in \"/tags/type\" "
  egress_worker_filter     = " \"egress\" in \"/tags/type\" "
  host_source_ids = [
    boundary_host_set_static.host_set_net172_connected.id
  ]
  /* brokered_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ] */
  injected_application_credential_source_ids = [
    boundary_credential_ssh_private_key.az_vm_01.id
  ]
}
