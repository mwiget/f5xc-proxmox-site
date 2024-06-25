variable "project_prefix" {
  type        = string
  default     = "f5xc"
}

# F5XC 

variable "f5xc_api_p12_file"   {}
variable "f5xc_api_url"        {}
variable "f5xc_api_token"      {}
variable "f5xc_tenant"         {}

# Proxmox

variable "pm_api_url"          {}
variable "pm_api_token_id"     {
  type    = string
  default = ""
}
variable "pm_api_token_secret" {
  type    = string
  default = ""
}
variable "pm_user"             {
  type    = string
  default = ""
}
variable "pm_password"         {
  type    = string
  default = ""
}
variable "pm_target_nodes"     {}
variable "pm_clone"            {}
variable "pm_pool" {
  type = string
  default = ""
}
variable "iso_storage_pool" {
  type = string
  default = "local"
}
variable "pm_storage_pool" {
  type = string
  default = "local-lvm"
}
variable "ssh_public_key"      {}
