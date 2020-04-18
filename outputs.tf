# Outputs the public IP Address assigned to the Google Compute Engine instance
output "origin_ip" {
  value = google_compute_address.minecraft.address
}

# Outputs the hostname of the Spectrum app
output "spectrum_hostname" {
  value = var.cloudflare_spectrum_hostname
}