# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "public_ip_target" {
  name                = "publicip-${random_pet.example.id}-target"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_pet.example.id}-target"
}

resource "azurerm_public_ip" "public_ip_worker_ingress" {
  name                = "publicip-${random_pet.example.id}-worker-ingress"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_pet.example.id}-worker-ingress"
}

resource "azurerm_public_ip" "public_ip_worker_egress" {
  name                = "publicip-${random_pet.example.id}-worker-egress"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_pet.example.id}-worker-egress"
}

resource "azurerm_public_ip" "public_ip_target_remote" {
  name                = "publicip-${random_pet.example.id}-target-remote"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${random_pet.example.id}-target-remote"
}

# Create Network Security Group and Rules - Boundary Public
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "BOUNDARY_WORKER"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9202"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Create Boundary Private Network
resource "azurerm_virtual_network" "boundary_private_network" {
  name                = "boundary_private_network_172"
  address_space       = ["172.16.0.0/12"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create Boundary Private Subnet
resource "azurerm_subnet" "boundary_private_subnet" {
  name                 = "boundary_private_subnet_172_0_1_0"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.boundary_private_network.name
  address_prefixes     = ["172.16.1.0/24"]
}


# Create Network Security Group and Rules - Boundary Private
resource "azurerm_network_security_group" "nsg_boundary_private" {
  name                = "nsg-${random_pet.example.id}-boundary-private"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "BOUNDARY_WORKER"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9202"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

## // VNET Peering

/* resource "azurerm_virtual_network_peering" "pub2priv" {
  name                      = "vnet-peering-${random_pet.example.id}-pub2priv"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.my_terraform_network.name
  remote_virtual_network_id = azurerm_virtual_network.boundary_private_network.id
}

resource "azurerm_virtual_network_peering" "priv2pub" {
  name                      = "vnet-peering-${random_pet.example.id}-pub2priv"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.boundary_private_network.name
  remote_virtual_network_id = azurerm_virtual_network.my_terraform_network.id
} */

