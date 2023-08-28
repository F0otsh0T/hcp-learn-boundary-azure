output "group_id-id" {
  value = boundary_group.group01.id
}

output "group_id-scope_id" {
  value = boundary_group.group01.scope_id
}

output "scope_project-id" {
  value = boundary_scope.project.id
}

output "host_catalog_id" {
  value = boundary_host_catalog_static.boundary_demo.id
}

output "host_static_net10_target_connected_id" {
  value = boundary_host_static.net10_target_connected.id
}

output "host_static_net10_target_connected_name" {
  value = boundary_host_static.net10_target_connected.name
}

output "host_static_net10_worker_ingress_id" {
  value = boundary_host_static.net10_worker_ingress.id
}

output "host_static_net10_worker_ingress_name" {
  value = boundary_host_static.net10_worker_ingress.name
}

output "host_static_net172_worker_egress_id" {
  value = boundary_host_static.net172_worker_egress.id
}

output "host_static_net172_worker_egress_name" {
  value = boundary_host_static.net172_worker_egress.name
}

output "host_static_net172_target_remote_id" {
  value = boundary_host_static.net172_target_remote.id
}

output "host_static_net172_target_remote_name" {
  value = boundary_host_static.net172_target_remote.name
}

output "target_net10_target_connected_ssh_id" {
  value = boundary_target.net10_target_connected_ssh.id
}

output "target_net10_target_connected_ssh_name" {
  value = boundary_target.net10_target_connected_ssh.name
}

output "target_net10_worker_ingress_direct_ssh_id" {
  value = boundary_target.net10_worker_ingress_direct_ssh.id
}

output "target_net10_worker_ingress_direct_ssh_name" {
  value = boundary_target.net10_worker_ingress_direct_ssh.name
}

output "target_net172_worker_egress_connected_ssh_id" {
  value = boundary_target.net172_worker_egress_connected_ssh.id
}

output "target_net172_worker_egress_connected_ssh_name" {
  value = boundary_target.net172_worker_egress_connected_ssh.name
}

output "target_net172_target_remote_connected_ssh_id" {
  value = boundary_target.net172_target_remote_connected_ssh.id
}

output "target_net172_target_remote_connected_ssh_name" {
  value = boundary_target.net172_target_remote_connected_ssh.name
}
