resource "google_service_account" "vm_instance_account" {
  account_id   = var.VM_SERVICE_ACCOUNTID
  display_name = var.VM_SERVICE_ACCOUNT_DISPLAY_NAME
}

resource "google_project_iam_binding" "vm_logging_admin_binding" {
  project = var.PROJECT
  role    = var.LOGGING_ADMIN_ROLE

  members = [
    "serviceAccount:${google_service_account.vm_instance_account.email}"
  ]
}

resource "google_project_iam_binding" "vm_monitoring_metric_writer_binding" {
  project = var.PROJECT
  role    = var.MONITORING_ROLE

  members = [
    "serviceAccount:${google_service_account.vm_instance_account.email}"
  ]
}

resource "google_project_iam_binding" "vm_pubsub_publisher" {
  project = var.PROJECT
  role    = var.ROLE_PUBSUB_PUBLISHER

  members = [
    "serviceAccount:${google_service_account.vm_instance_account.email}"
  ]
}

resource "google_project_iam_binding" "vm_enc_decrypt" {
  project = var.PROJECT
  role    = var.ROLE_KMS_ENCRYPT_DECRYPT

  members = [
    "serviceAccount:${google_service_account.vm_instance_account.email}"
  ]
}

resource "google_service_account" "cloud_function_account" {
  account_id   = var.FN_SERVICE_ACCOUNTID
  display_name = var.FN_SERVICE_ACCOUNT_DISPLAY_NAME
}

resource "google_project_iam_binding" "fn_kms_enc_decrypt" {
  project = var.PROJECT
  role    = var.ROLE_KMS_ENCRYPT_DECRYPT

  members = [
    "serviceAccount:${google_service_account.cloud_function_account.email}"
  ]
}

resource "google_project_iam_binding" "fn_pub_subscriber" {
  project = var.PROJECT
  role    = var.ROLE_RUN_INVOKER

  members = [
    "serviceAccount:${google_service_account.cloud_function_account.email}"
  ]
}

resource "google_project_iam_binding" "fn_cloud_function_invoker" {
  project = var.PROJECT
  role    = var.ROLE_CLOUD_FUNCTION_INVOKER

  members = [
    "serviceAccount:${google_service_account.cloud_function_account.email}"
  ]
}

data "google_storage_project_service_account" "storage_bucket_account" {
}

resource "google_kms_crypto_key_iam_binding" "storage_bucket_enc_decrypt_binding" {
  crypto_key_id = google_kms_crypto_key.storage_bucket_key.id
  role          = var.ROLE_KMS_ENCRYPT_DECRYPT

  members = [
    "serviceAccount:${data.google_storage_project_service_account.storage_bucket_account.email_address}"
  ]
}

resource "google_project_service_identity" "cloud_sql_service_identity" {
  provider = google-beta
  project  = var.PROJECT
  service  = var.SQL_ADMIN_SERVICE
}

resource "google_kms_crypto_key_iam_binding" "sql_enc_decrypt_binding" {
  crypto_key_id = google_kms_crypto_key.sql_instance_key.id
  role          = var.ROLE_KMS_ENCRYPT_DECRYPT

  members = [
    "serviceAccount:${google_project_service_identity.cloud_sql_service_identity.email}",
  ]
}

data "google_project" "project" {
}

resource "google_kms_crypto_key_iam_binding" "vm_enc_decrypt_binding" {
  crypto_key_id = google_kms_crypto_key.vm_disk_key.id
  role          = var.ROLE_KMS_ENCRYPT_DECRYPT

  members = [
    "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com",
  ]
}
