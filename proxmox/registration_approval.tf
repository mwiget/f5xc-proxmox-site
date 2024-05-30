resource "volterra_registration_approval" "master" {
  depends_on      = [
    volterra_voltstack_site.appstack, 
    volterra_securemesh_site.securemesh_single_nic, 
    volterra_securemesh_site.securemesh_dual_nic, 
    proxmox_vm_qemu.master-vm
  ]
  count           = var.master_node_count
  cluster_name    = var.f5xc_cluster_name
  cluster_size    = var.master_node_count
  hostname        = format("%s-m%s", var.f5xc_cluster_name, count.index)
  wait_time       = var.f5xc_registration_wait_time
  retry           = var.f5xc_registration_retry
  tunnel_type     = var.f5xc_tunnel_type
}

module "site_wait_for_online" {
  depends_on      = [
    volterra_voltstack_site.appstack, 
    volterra_securemesh_site.securemesh_single_nic, 
    volterra_securemesh_site.securemesh_dual_nic, 
    proxmox_vm_qemu.master-vm
  ]
  source          = "../f5xc_status_site"
  f5xc_api_token  = var.f5xc_api_token
  f5xc_api_url    = var.f5xc_api_url
  f5xc_namespace  = "system"
  f5xc_site_name  = var.f5xc_cluster_name
  f5xc_tenant     = var.f5xc_tenant
}

resource "volterra_registration_approval" "worker" {
  depends_on      = [module.site_wait_for_online, proxmox_vm_qemu.worker-vm]
  count           = var.worker_node_count
  cluster_name    = var.f5xc_cluster_name
  cluster_size    = var.master_node_count
  hostname        = format("%s-w%s", var.f5xc_cluster_name, count.index)
  wait_time       = var.f5xc_registration_wait_time
  retry           = var.f5xc_registration_retry
  tunnel_type     = var.f5xc_tunnel_type
}

resource "time_offset" "exp_time" {
  offset_days     = 30
}
