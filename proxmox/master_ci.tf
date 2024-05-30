resource "proxmox_cloud_init_disk" "master-ci" {
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
      Labels:
        testbed: make-me-a-var
      Hostname: ${var.f5xc_cluster_name}-m${count.index}
      Latitude: ${var.latitude}
      Longitude: ${var.longitude}
      MauriceEndpoint: ${local.maurice_endpoint}
      MauricePrivateEndpoint: ${local.maurice_private_endpoint}
      Proxy: 
        http_proxy: ${var.http_proxy}
        https_proxy: ${var.http_proxy}
      EnableIpv6: true
      Token: ${var.site_registration_token}
- path: /etc/vpm/certified-hardware.yaml
  permissions: 0644
  owner: root
  content: |
    active: ${var.volterra_certified_hw}
    certifiedHardware:
      kvm-voltstack-combo:
        Vpm:
          PrivateNIC: eth0
        outsideNic:
        - eth0
      kvm-multi-nic-voltmesh:
        Vpm:
           InsideNIC: eth1
           PrivateNIC: eth0
        outsideNic:
        - eth0
      kvm-regular-nic-voltmesh:
        Vpm:
          PrivateNIC: eth0
        outsideNic:
        - eth0
      kvm-voltmesh:
        Vpm:
          PrivateNIC: eth0
        outsideNic:
        - eth0
    primaryOutsideNic: eth0
runcmd:
  - [ sh, -c, test -e /usr/bin/fsextend  && /usr/bin/fsextend || true ]
hostname: ${var.f5xc_cluster_name}-m${count.index}
EOT
}

