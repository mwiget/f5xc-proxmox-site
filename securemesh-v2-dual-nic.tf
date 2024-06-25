module "securemesh-v2-dual-nic" {
  count                   = 1
  source                  = "./proxmox_smv2"
  f5xc_cluster_name       = format("%s-sm-dual-nic-%d", var.project_prefix, count.index)
  pm_clone                = "f5xc-smv2-template"
  pm_storage_pool         = var.pm_storage_pool
  iso_storage_pool        = var.iso_storage_pool

  master_node_count       = 3
  worker_node_count       = 0

  master_cpus             = 4
  master_memory           = 16384

  worker_cpus             = 4
  worker_memory           = 16384

  ssh_public_key          = var.ssh_public_key
  pm_target_nodes         = var.pm_target_nodes
  outside_network         = "vmbr0"
  slo_interface           = "ens18"

  # set  to generate fixed  macaddr per node (last octet set to node index)
  # outside_macaddr       = "02:02:02:00:00:00"   

  inside_network          = "vmbr0"
  inside_network_vlan     = "100"
  inside_vip              = "192.168.100.5"
  inside_ipv4_prefix      = "192.168.100.0/24"
  inside_dhcp_pool_start  = "192.168.100.10"
  inside_dhcp_pool_end    = "192.168.100.200"

  f5xc_tenant             = var.f5xc_tenant
  f5xc_api_url            = var.f5xc_api_url
  f5xc_api_token          = var.f5xc_api_token
}