/*
This was taken from:
https://github.com/futurice/terraform-examples/blob/master/google_cloud/minecraft/main.tf
*/

# Create service account to run service with no permissions
resource "google_service_account" "minecraft" {
  account_id   = "minecraft"
  display_name = "minecraft"
}

# Permenant Minecraft disk, stays around when VM is off
resource "google_compute_disk" "minecraft" {
  name  = "minecraft"
  type  = "pd-standard"
  zone  = var.gcp_zone
  image = "cos-cloud/cos-stable"
}

# Permenant IP address, stays around when VM is off
resource "google_compute_address" "minecraft" {
  name   = "minecraft-ip"
  region = var.gcp_region
}

# VM to run Minecraft, we use preemptable which will shutdown within 24 hours
resource "google_compute_instance" "minecraft" {
  name         = "minecraft"
  machine_type = "n1-standard-1"
  zone         = var.gcp_zone
  tags         = ["minecraft"]

  # Run itzg/minecraft-server docker image on startup
  # The instructions of https://hub.docker.com/r/itzg/minecraft-server/ are applicable
  # For instance, Ssh into the instance and you can run
  #  docker logs mc
  #  docker exec -i mc rcon-cli
  # Once in rcon-cli you can "op <player_id>" to make someone an operator (admin)
  # Use 'sudo journalctl -u google-startup-scripts.service' to retrieve the startup script output
  metadata_startup_script = "docker run -d -p 25565:25565 -e EULA=TRUE -v /var/minecraft:/data --name mc --rm=true itzg/minecraft-server:latest;"

  boot_disk {
    auto_delete = false # Keep disk after shutdown (game data)
    source      = google_compute_disk.minecraft.self_link
  }

  network_interface {
    network = google_compute_network.minecraft.name
    access_config {
      nat_ip = google_compute_address.minecraft.address
    }
  }

  service_account {
    email  = google_service_account.minecraft.email
    scopes = ["userinfo-email"]
  }

  scheduling {
    preemptible       = true # Closes within 24 hours (sometimes sooner)
    automatic_restart = false
  }
}

# Create a private network so the minecraft instance cannot access
# any other resources.
resource "google_compute_network" "minecraft" {
  name = "minecraft"
}

# Get the IP ranges of Cloudflare edge nodes
data "cloudflare_ip_ranges" "cloudflare" {}

# Open the firewall for Minecraft traffic
resource "google_compute_firewall" "minecraft" {
  name    = "minecraft"
  network = google_compute_network.minecraft.name
  # Minecraft client port
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  # ICMP (ping)
  allow {
    protocol = "icmp"
  }
  # SSH (for RCON-CLI access)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # Lockdown the origin server to allow only traffic from Cloudflare, deny all others
  source_ranges = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
  target_tags   = ["minecraft"]
}