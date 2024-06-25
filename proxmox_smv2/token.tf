resource "restapi_object" "token" {
  id_attribute = "metadata/name"
  path         = "/register/namespaces/system/tokens"
  data         = local.token
}

locals {
  token = jsonencode({
    "metadata": {
      "name": var.f5xc_cluster_name,
      "namespace": "system"
    }
    "spec": {
      "type": "JWT",
      "site_name": var.f5xc_cluster_name
    }
  })
}

output "token" {
  value = { 
    content = regex("content:(\\S+)", restapi_object.token.api_data.spec)[0],
    site_name = regex("site_name:(\\S+)", restapi_object.token.api_data.spec)[0]
  }
}
