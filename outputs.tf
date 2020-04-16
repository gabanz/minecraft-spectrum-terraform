# Outputs the public IP Address assigned to the Google Compute Engine instance after
# terraform apply
output "minecraft_ip" {
  value = google_compute_address.minecraft.address
}