terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.32"
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc2"
    }
  }
}
