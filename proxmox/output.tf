output "proxmox" {
  value = {
    appstack                = volterra_voltstack_site.appstack
    secure_mesh_single_nic  = volterra_securemesh_site.securemesh_single_nic
    secure_mesh_dual_nic    = volterra_securemesh_site.securemesh_dual_nic
    master_vm               = proxmox_vm_qemu.master-vm    
    worker_vm               = proxmox_vm_qemu.worker-vm    
    kubeconfig              = local_file.kubeconfig
  }
  sensitive = true
}
