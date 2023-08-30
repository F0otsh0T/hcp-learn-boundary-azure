terraform {
  required_version = ">=0.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.9"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.69.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  hcp_boundary_cluster_addr = hcp_boundary_cluster.example.cluster_url
}

provider "boundary" {
#  addr                   = var.boundary_addr
  addr                   = local.hcp_boundary_cluster_addr
#  auth_method_id         = var.auth_method_id
  auth_method_login_name = var.auth_method_login_name
  auth_method_password   = var.auth_method_password
}

provider "hcp" {
  # Configuration options
}

/* module "virtual-machine_example_basic" {
  source  = "Azure/virtual-machine/azurerm//examples/basic"
  version = "1.0.0"
} */

resource "random_pet" "example" {
}
