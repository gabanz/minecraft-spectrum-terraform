provider "cloudflare" {
  version = "~> 2.5.1"
  api_token = var.cloudflare_api_token
}

provider "google" {
  version = "~> 3.17"
  credentials = file(var.credentials_file)
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}
