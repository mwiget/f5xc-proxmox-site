output "proxmox" {
  value = {
    appstack    = module.appstack
    securemesh  = module.securemesh-single-nic
    securemesh  = module.securemesh-dual-nic
  }
  sensitive = true
}
