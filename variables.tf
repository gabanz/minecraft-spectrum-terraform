# Cloudflare
variable "cloudflare_api_token" {
  description = "API Token must have Edit Zone Settings permission"
}

variable "cloudflare_zone_id" {
  description = "The Zone ID that the Spectrum application resides in"
}

variable "cloudflare_spectrum_hostname" {
  description = "The hostname that proxies the Spectrum app"
}

# GCP
variable "gcp_project" {
  description = "The Project ID under which the resources created will be billed for"
}

variable "credentials_file" {
  description = "Service Account key file in JSON format. Project Editor permission needed"
}

variable "gcp_region" {
  description = "The region where the origin resources will be created in"
}

variable "gcp_zone" {
  description = "The zone where the origin resources will be created in"
}

