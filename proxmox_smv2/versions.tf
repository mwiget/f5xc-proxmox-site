terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.34"
    }
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
    restapi = {
      source = "Mastercard/restapi"
      version = "1.19.1"
    }
  }
}
