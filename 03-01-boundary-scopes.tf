## // https://developer.hashicorp.com/boundary/tutorials/hcp-administration/hcp-manage-scopes

# // Create an org under the `global` scope.
resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "boundary_demo_org"
  description              = "Boundary Demo Org"
  auto_create_default_role = true
  auto_create_admin_role   = true
  depends_on = [ hcp_boundary_cluster.example ]
}

# // Create a project under the `global` scope in the org `boundary_demo_org`
resource "boundary_scope" "project" {
  name        = "boundary_demo_project"
  description = "Boundary Demo Project"

  # scope_id is taken from the org resource defined for 'boundary_demo_org'
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

