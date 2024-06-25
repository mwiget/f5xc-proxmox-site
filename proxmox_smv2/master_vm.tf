resource "proxmox_vm_qemu" "master-vm" {
  count             = var.master_node_count
  depends_on        = [ proxmox_cloud_init_disk.master-ci ]
  name              = format("%s-m%s", var.f5xc_cluster_name, count.index)
  target_node       = var.pm_target_nodes[count.index % length(var.pm_target_nodes)]
  clone             = var.pm_clone
  pool              = var.pm_pool
  sockets           = 1
  cores             = var.master_cpus
  memory            = var.master_memory
  os_type           = "cloud-init"
  scsihw            = "virtio-scsi-pci"
  agent             = strcontains(var.pm_clone, "centos") ? 0 : 1
  onboot            = true
  skip_ipv6         = true    # required until https://github.com/Telmate/terraform-provider-proxmox/issues/1015 is fixed

  network {
    bridge            = var.outside_network
    model             = "virtio"
    macaddr           = var.outside_macaddr == "" ? "" : format("%s:%02x", substr(var.outside_macaddr,0,15), count.index)
    tag               = var.outside_network_vlan
  }

  dynamic "network" {
    for_each =  var.inside_network == "" ? [] : [ var.inside_network ]
    content {
      bridge          = var.inside_network
      model           = "virtio"
      tag             = var.inside_network_vlan
    }
  }

  vga {
    type = "std"
  }

  dynamic "hostpci" {
    for_each = var.master_hostpci
    content {
      #mapping    = hostpci.value
      host    = hostpci.value
      rombar  = 1
    }
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.pm_storage_pool
          size    = var.master_vm_size
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = proxmox_cloud_init_disk.master-ci[count.index].id
        }
      }
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
