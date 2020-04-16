# Defines the origin server in the specified format
locals {
  cloudflare_spectrum_origin = join("", ["tcp://", google_compute_address.minecraft.address, ":25565"])
}

# Define a spectrum application that proxies Minecraft traffic
resource "cloudflare_spectrum_application" "minecraft_proxy" {
  zone_id      = var.cloudflare_zone_id
  protocol     = "Minecraft"
  traffic_type = "direct"
  argo_smart_routing = false
  dns {
    type = "CNAME"
    name = var.cloudflare_spectrum_hostname
  }

  origin_direct = [
    local.cloudflare_spectrum_origin
  ]
}