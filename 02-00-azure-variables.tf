variable "resource_group_location" {
  type        = string
  default     = "westus3"
  description = "Location of the resource group."
}

variable "location" {
  type        = string
  default     = "westus3"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_name_suffix" {
  type        = string
  default     = "rg"
  description = "Suffix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the new VM."
  default     = "azureadmin"
}

variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix for unique Azure resource naming across deployments."
}

variable "resource_group_name" {
  type        = string
  description = "Name of Resource Group to create."
  default     = "boundary-learn"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for taggable Azure resources."
  default     = {}
}

variable "boundary_cluster_id" {
  type        = string
  description = ""
  default     = "boundary_cluster_id_default"
}
