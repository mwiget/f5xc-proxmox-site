resource "volterra_token" "site" {
  name      = format("%s-token", var.project_prefix)
  namespace = "system"
}
