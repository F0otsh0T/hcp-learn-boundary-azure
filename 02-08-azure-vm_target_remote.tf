## // Boundary Self Hosted Worker - Egress / Downstream

# Create Boundary Worker Entity in Boundary Controller
# // `boundary_worker.*.controller_generated_activation_token` generated
# // generated only one time at the initial creation of the `boundary_worker.*` resource
# // To recreate Worker Registration and Token, taint / `-replace` both the 
# // `boundary_worker.*` and VM Instance utilizing that activation
# // token

resource "boundary_worker" "vm_boundary_target_remote" {
  scope_id = "global"
  name = "${random_pet.example.id}-target-remote"
  worker_generated_auth_token = ""
}

# Create network interface
resource "azurerm_network_interface" "nic_boundary_target_remote" {
  name                = "nic-${random_pet.example.id}-target-remote"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-configuration-${random_pet.example.id}-target-remote"
    subnet_id                     = azurerm_subnet.boundary_private_subnet.id
    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.public_ip_target_remote.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "vm_boundary_target_remote_assoc" {
  network_interface_id      = azurerm_network_interface.nic_boundary_target_remote.id
  network_security_group_id = azurerm_network_security_group.nsg_boundary_private.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_boundary_target_remote" {
  name                  = "${random_pet.example.id}-target-remote"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_boundary_target_remote.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "osdisk-${random_pet.example.id}-target-remote"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "${random_pet.example.id}-target-remote"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  user_data = base64encode(templatefile("${path.module}/templates/02-08-azure-vm_target_remote-user_data.sh", {
    boundary_arch                         = "amd64",
    boundary_auth_path_root               = "/var/tmp/boundary-auth/"
    boundary_capture_path_root            = "/var/tmp/boundary-session-recording/capture/"
    boundary_cluster_id                   = "${split(".", split("//", hcp_boundary_cluster.example.cluster_url)[1])[0]}"
    boundary_worker_address               = "0.0.0.0"
#    boundary_worker_initial_upstream      = "localhost"
#    boundary_worker_initial_upstream      = "${azurerm_linux_virtual_machine.vm_boundary_worker_ingress.public_ip_address}"
    boundary_worker_initial_upstream      = "${random_pet.example.id}-target-remote.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
    boundary_worker_initial_upstream_port = "9202"
    boundary_worker_port                  = "9202"
    boundary_worker_proxy                 = "proxy"
    boundary_worker_tag                   = "dev"
    boundary_worker_version               = "0.13.2+ent"
    boundary_worker_public_hostname       = "${random_pet.example.id}-target-remote.${azurerm_resource_group.rg.location}.cloudapp.azure.com"
    boundary_worker_activation_token      = "${boundary_worker.vm_boundary_target_remote.controller_generated_activation_token}"
    log_path                              = "/var/log"
    #    ssh_public_key                        = file("~/.ssh/id_rsa.pub")
    ssh_public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }))

  depends_on = [
    hcp_boundary_cluster.example,
    boundary_worker.vm_boundary_target_remote
  ]
}
