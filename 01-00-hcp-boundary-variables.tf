variable "auth_method_login_name" {
  type = string
  description = "HCP Boundary Cluster User."
  default     = "boundary-user"
}

variable "auth_method_password" {
  type = string
  description = "HCP Boundary Cluster Password."
  default     = "boundary-pass"
}

variable "hcp_boundary_cluster_tier" {
  type = string
  description = "HCP Boundary Cluster Tier"
#  default = "Plus"
  default = "Standard"
}