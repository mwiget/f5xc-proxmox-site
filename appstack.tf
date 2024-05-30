module "appstack" {
  count                   = 1
  source                  = "./proxmox"
  f5xc_cluster_name       = format("%s-appstack-%s", var.project_prefix, count.index)
  pm_clone                = var.pm_clone
  pm_storage_pool         = var.pm_storage_pool
  iso_storage_pool        = var.iso_storage_pool

  master_node_count       = 3
  worker_node_count       = 2

  master_cpus             = 4
  master_memory           = 16384

  worker_cpus             = 4
  worker_memory           = 16384


  latitude                = 47
  longitude               = 8.5
  volterra_certified_hw   = "kvm-voltstack-combo"  
  site_registration_token = volterra_token.site.id
  ssh_public_key          = var.ssh_public_key
  pm_target_nodes         = var.pm_target_nodes
  outside_network         = "vmbr0"
  # set  to generate fixed  macaddr per node (last octet set to node index)
  # outside_macaddr       = "02:02:02:00:00:00"   

  f5xc_tenant             = var.f5xc_tenant
  f5xc_api_url            = var.f5xc_api_url
  f5xc_api_token          = var.f5xc_api_token
}
