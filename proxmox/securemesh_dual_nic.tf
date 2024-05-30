resource "volterra_securemesh_site" "securemesh_dual_nic" {
  count                     = var.inside_network == "" ? 0 : 1
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

  custom_network_config {
    sli_config {
      vip = var.inside_vip
    }
    interface_list {
      interfaces {
        ethernet_interface {
          device = "eth1"
          site_local_inside_network = true
          dhcp_server {
            dhcp_networks {
              network_prefix = var.inside_ipv4_prefix
              pool_settings = "INCLUDE_IP_ADDRESSES_FROM_DHCP_POOLS"
              pools {
                start_ip = var.inside_dhcp_pool_start
                end_ip   = var.inside_dhcp_pool_end
              }
            }
          }
        }
      }
    }
    vip_vrrp_mode = "VIP_VRRP_ENABLE"
  }

  volterra_certified_hw     = var.volterra_certified_hw
}
