resource "hcp_boundary_cluster" "example" {
  cluster_id = random_pet.example.id
  username   = var.auth_method_login_name
  password   = var.auth_method_password
  tier       = var.hcp_boundary_cluster_tier
  #   maintenance_window_config {
  #     day          = "TUESDAY"
  #     start        = 2
  #     end          = 12
  #     upgrade_type = "SCHEDULED"
  #   }
}