## // https://developer.hashicorp.com/boundary/tutorials/hcp-administration/hcp-manage-roles
## // https://registry.terraform.io/providers/hashicorp/boundary/latest/docs/resources/role

# // Create read-only role
resource "boundary_role" "read_only" {
  name          = "read_only"
  description   = "Role with read-only permission"
  scope_id      = boundary_scope.org.id
  principal_ids = [boundary_user.tester01.id]
  grant_strings = ["id=*;type=*;actions=read,list"]
}
