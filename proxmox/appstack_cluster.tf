resource "volterra_k8s_cluster" "appstack" {
  count                             = true == strcontains(var.volterra_certified_hw, "stack") ? 1 : 0
  name                              = var.f5xc_cluster_name
  namespace                         = "system"
  no_cluster_wide_apps              = true
  use_default_cluster_role_bindings = true
  use_default_cluster_roles         = true
  cluster_scoped_access_permit      = true
  global_access_enable              = true
  no_insecure_registries            = true
  use_default_psp                   = true
  local_access_config {
    local_domain = format("%s.local", var.f5xc_cluster_name)
    default_port = true
  }
}

resource "volterra_voltstack_site" "appstack" {
  count                   = true == strcontains(var.volterra_certified_hw, "stack") ? 1 : 0
  depends_on              = [ proxmox_vm_qemu.master-vm, proxmox_vm_qemu.worker-vm ]
  name                    = var.f5xc_cluster_name
  namespace               = "system"

  sw {
    volterra_software_version = var.volterra_software_version
  }
  os {
    operating_system_version  = var.operating_system_version
  }

  k8s_cluster {
    namespace = "system"
    name      = volterra_k8s_cluster.appstack[count.index].name
  }
  dynamic "master_node_configuration" {
    for_each = proxmox_vm_qemu.master-vm
    content {
      name = master_node_configuration.value.name
    }
  }
  worker_nodes = [ for k,v in proxmox_vm_qemu.worker-vm : format("%s-w%s", volterra_k8s_cluster.appstack[count.index].name, k) ]
  no_bond_devices         = true
  disable_gpu             = true
  disable_vm              = var.kubevirt ? false : true
  logs_streaming_disabled = true
  default_network_config  = true
  default_storage_config  = true
  deny_all_usb            = false
  volterra_certified_hw   = var.volterra_certified_hw
}
