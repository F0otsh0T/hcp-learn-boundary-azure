# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_target.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "${random_pet.example.id}-target"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "${random_pet.example.id}-target"

  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }

  user_data = base64encode(templatefile("${path.module}/templates/02-05-azure-vm_target-user_data.sh", {
    boundary_arch                         = "amd64",
    controller_generated_activation_token = "foo"
    boundary_auth_path_root               = "/var/tmp/boundary-auth/"
    boundary_capture_path_root            = "/var/tmp/boundary-session-recording/capture/"
    boundary_cluster_id                   = "${split(".", split("//", hcp_boundary_cluster.example.cluster_url)[1])[0]}"
    boundary_worker_address               = "0.0.0.0"
    boundary_worker_initial_upstream      = "localhost"
    boundary_worker_initial_upstream_port = "9202"
    boundary_worker_port                  = "9202"
    boundary_worker_proxy                 = "proxy"
    boundary_worker_tag                   = "dev"
    boundary_worker_version               = "0.13.2+ent"
    log_path                              = "/var/log"
    #    ssh_public_key                        = file("~/.ssh/id_rsa.pub")
    ssh_public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }))

  depends_on = [
    hcp_boundary_cluster.example
  ]
}

locals {
  boundary_addr = local.hcp_boundary_cluster_addr
}