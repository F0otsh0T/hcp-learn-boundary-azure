provider "boundary" {
  /* addr                            = "http://127.0.0.1:9200"
  auth_method_id                  = "ampw_sOXVI7JS2l"
  password_auth_method_login_name = "tester01"
  password_auth_method_password   = "supersecure" */
  addr                   = var.boundary_addr
  auth_method_id         = var.auth_method_id
  auth_method_login_name = var.auth_method_login_name
  auth_method_password   = var.auth_method_password
}

variable "boundary_addr" {
  type = string
}

variable "auth_method_id" {
  type = string
}

variable "auth_method_login_name" {
  type = string
}

variable "auth_method_password" {
  type = string
}
