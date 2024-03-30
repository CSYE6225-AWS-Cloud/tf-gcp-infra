resource "google_service_account" "logger_account" {
  account_id   = var.LOGGER_SERVICE_ACCOUNTID
  display_name = var.LOGGER_SERVICE_ACCOUNT_DISPLAY_NAME
}

resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.PROJECT
  role    = var.LOGGING_ADMIN_ROLE

  members = [
    "serviceAccount:${google_service_account.logger_account.email}"
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.PROJECT
  role    = var.MONITORING_ROLE

  members = [
    "serviceAccount:${google_service_account.logger_account.email}"
  ]
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.PROJECT
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.logger_account.email}"
  ]
}

resource "google_project_iam_binding" "pubsub_subscriber" {
  project = var.PROJECT
  role    = var.ROLE_PUBSUB_SUBSCRIBER

  members = [
    "serviceAccount:${google_service_account.logger_account.email}"
  ]
}

resource "google_project_iam_binding" "cloud_function_invoker" {
  project = var.PROJECT
  role    = var.ROLE_CLOUD_FUNCTION_INVOKER

  members = [
    "serviceAccount:${google_service_account.logger_account.email}"
  ]
}
