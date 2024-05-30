locals {
  kubeconfig      = format("./%s.kubeconfig", var.f5xc_cluster_name)
}

data "http" "kubeconfig" {
  depends_on      = [ module.site_wait_for_online, volterra_voltstack_site.appstack ]
  url             =  format("%s/web/namespaces/system/sites/%s/global-kubeconfigs", var.f5xc_api_url, var.f5xc_cluster_name)
  method          = "POST"
  request_headers = {
    # "only_once" hack (part 1) to only create it once (subsequent refresh and apply will fail)
    Authorization = fileexists(local.kubeconfig) ? "" : format("APIToken %s", var.f5xc_api_token) 
  }
  request_body    = jsonencode({expiration_timestamp: time_offset.exp_time.rfc3339, site: var.f5xc_cluster_name})
}

resource "local_file" "kubeconfig" {
  # "only_once" hack (part 2) to never overwrite it after initial creation
  content         = fileexists(local.kubeconfig) ? file(local.kubeconfig) : data.http.kubeconfig.response_body
  filename        = local.kubeconfig
}
