resource "proxmox_cloud_init_disk" "master-ci" {
  depends_on = [ restapi_object.token ]
  count     = var.master_node_count
  name      = format("%s-m%s", var.f5xc_cluster_name, count.index)
  pve_node  = var.pm_target_nodes[count.index % length(var.pm_target_nodes)]
  storage   = var.iso_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(format("%s-m%s", var.f5xc_cluster_name, count.index))
    local-hostname = format("%s-m%s", var.f5xc_cluster_name, count.index)
  })

  user_data = <<EOT
#cloud-config
users:
  - default
ssh_authorized_keys:
  - ${var.ssh_public_key}
coreos:
  update:
    reboot-strategy: "off"
network:
  version: 2
write_files:
- path: /etc/vpm/config.yaml
  permissions: 0644
  owner: root
  content: |
    Kubernetes:
      EtcdUseTLS: true
      Server: vip
    Vpm:
      ClusterName: ${var.f5xc_cluster_name}
      ClusterType: ce
      Config: /etc/vpm/config.yaml
      Hostname: ${var.f5xc_cluster_name}-m${count.index}
      Latitude: 0
      Longitude: 0
      MauriceEndpoint: ${local.maurice_endpoint}
      MauricePrivateEndpoint: ${local.maurice_private_endpoint}
      EnableIpv6: true
      Token: 
- path: /etc/vpm/user_data
  permissions: 0644
  owner: root
  content: |
    token: ${regex("content:(\\S+)", restapi_object.token.api_data.spec)[0]}
- path: /etc/vpm/certified-hardware.yaml
  permissions: 0644
  owner: root
  content: |
    active: site-v2-generic-chw
    certifiedHardware:
      site-v2-generic-chw: {}
    primaryOutsideNic: ${var.slo_interface}
runcmd:
  - [ sh, -c, test -e /usr/bin/fsextend  && /usr/bin/fsextend || true ]
hostname: ${var.f5xc_cluster_name}-m${count.index}
EOT
}

