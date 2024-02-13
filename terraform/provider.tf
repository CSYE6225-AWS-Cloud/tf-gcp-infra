provider "google" {
  project     = var.PROJECT
  credentials = file(var.GCP_CRED_PATH)
  region      = var.REGION
  zone        = var.ZONE
}