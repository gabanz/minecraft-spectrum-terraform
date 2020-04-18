# Define the origin server in the specified format
locals {
  cloudflare_minecraft_origin = join("", ["tcp://", google_compute_address.minecraft.address, ":25565"])
  cloudflare_ssh_origin = join("", ["tcp://", google_compute_address.minecraft.address, ":22"])
}

# Define a Spectrum application that proxies Minecraft traffic
resource "cloudflare_spectrum_application" "minecraft_proxy" {
  zone_id      = var.cloudflare_zone_id
  protocol     = "minecraft"
  traffic_type = "direct"
  dns {
    type = "CNAME"
    name = var.cloudflare_spectrum_hostname
  }

  origin_direct = [
    local.cloudflare_minecraft_origin
  ]
}

# Define a Spectrum application that proxies SSH traffic
resource "cloudflare_spectrum_application" "ssh_proxy" {
  zone_id      = var.cloudflare_zone_id
  protocol     = "ssh"
  traffic_type = "direct"
  dns {
    type = "CNAME"
    name = var.cloudflare_spectrum_hostname
  }

  origin_direct = [
    local.cloudflare_ssh_origin
  ]
}