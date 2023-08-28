## // https://developer.hashicorp.com/boundary/tutorials/hcp-administration/hcp-manage-users-groups
## // https://developer.hashicorp.com/boundary/docs/common-workflows/manage-users-groups

# // Enable password-type auth method in Org.
resource "boundary_auth_method" "password" {
  name        = "org_auth_method_pass"
  description = "Password auth method for org"
  type        = "password"
  scope_id    = boundary_scope.org.id
}

# // Create an account for the org-scoped auth method.
resource "boundary_account_password" "test_account" {
  name        = "test_account"
  description = "Test password account"
  #  type           = "password"
  login_name     = "tester01"
  password       = "supersecure"
  auth_method_id = boundary_auth_method.password.id
}

# // Create a user at the org scope.
resource "boundary_user" "tester01" {
  name        = "tester01"
  description = "Test user"
  account_ids = [
    boundary_account_password.test_account.id
  ]
  scope_id = boundary_scope.org.id
}

# // Create a group at the org scope.
resource "boundary_group" "group01" {
  name        = "group01"
  description = "Test group"
  member_ids  = [boundary_user.tester01.id]
  scope_id    = boundary_scope.org.id
}


