resource "volterra_securemesh_site" "securemesh_single_nic" {
  count                     = var.inside_network == "" && strcontains(var.volterra_certified_hw,"voltmesh") ? 1 : 0
  depends_on                = [ proxmox_vm_qemu.master-vm, proxmox_vm_qemu.worker-vm ]
  name                      = var.f5xc_cluster_name
  namespace                 = "system"

  default_blocked_services  = true
  no_bond_devices           = true
  logs_streaming_disabled   = true

  dynamic "master_node_configuration" {
    for_each = proxmox_vm_qemu.master-vm
    content {
      name = master_node_configuration.value.name
    }
  }
  worker_nodes = [ for k,v in proxmox_vm_qemu.worker-vm : format("%s-w%s", k, v) ]

  default_network_config    = true
  volterra_certified_hw     = var.volterra_certified_hw
}
