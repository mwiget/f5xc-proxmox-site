locals {
  f5xc_environment = split(".", var.f5xc_api_url)[1]
  maurice_private_endpoint = local.f5xc_environment == "console" ? "https://register-tls.ves.volterra.io" : "https://register-tls.${local.f5xc_environment}.volterra.us"
  maurice_endpoint = local.f5xc_environment == "console" ? "https://register.ves.volterra.io" :"https://register.${local.f5xc_environment}.volterra.us"
}
