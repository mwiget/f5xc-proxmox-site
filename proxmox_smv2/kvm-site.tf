resource "restapi_object" "kvm-site" {
  id_attribute = "metadata/name"
  path          = "/config/namespaces/system/securemesh_site_v2s"
  data         = local.kvm-site
}

locals {
  kvm-site = jsonencode({
    "metadata": {
      "name": var.f5xc_cluster_name,
      "disable": false
    },
    "spec": {
      "kvm": {
        "not_managed": {}
      },
      "no_network_policy": {},
      "no_forward_proxy": {},
      "software_settings": {
        "sw": {
          "default_sw_version": {}
        },
        "os": {
          "default_os_version": {}
        }
      },
      "upgrade_settings": {
        "kubernetes_upgrade_drain": {
          "disable_upgrade_drain": {}
        }
      },
      "logs_streaming_disabled": {},
      "block_all_services": {},
      "performance_enhancement_mode": {
        "perf_mode_l7_enhanced": {}
      },
      "offline_survivability_mode": {
        "no_offline_survivability_mode": {}
      },
      "tunnel_dead_timeout": 0,
      "load_balancing": {
        "vip_vrrp_mode": "VIP_VRRP_DISABLE"
      },
      "no_s2s_connectivity_sli": {},
      "no_s2s_connectivity_slo": {},
      "local_vrf": {
        "default_config": {},
        "default_sli_config": {}
      },
      "tunnel_type": "SITE_TO_SITE_TUNNEL_IPSEC_OR_SSL",
      "re_select": {
        "geo_proximity": {}
      },
      "disable_ha": {}
    }
  })
}

output "kvm-site-1" {
  value = { 
    raw = restapi_object.kvm-site
    #    site_name = regex("site_name:(\\S+)", restapi_object.token-1.api_data.spec)[0]
  }
}

