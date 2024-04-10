resource "google_kms_key_ring" "csye6225-keyring" {
  name     = "keyring-1"
  location = var.REGION
}

resource "google_kms_crypto_key" "vm_disk_key" {
  name            = var.VM_DISK_KEY_NAME
  key_ring        = google_kms_key_ring.csye6225-keyring.id
  rotation_period = var.KEY_ROTATION_PERIOD
}

resource "google_kms_crypto_key" "sql_instance_key" {
  name            = var.SQL_INSTANCE_KEY_NAME
  key_ring        = google_kms_key_ring.csye6225-keyring.id
  rotation_period = var.KEY_ROTATION_PERIOD
}

resource "google_kms_crypto_key" "storage_bucket_key" {
  name            = var.STORAGE_BUCKET_KEY_NAME
  key_ring        = google_kms_key_ring.csye6225-keyring.id
  rotation_period = var.KEY_ROTATION_PERIOD
}