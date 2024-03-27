resource "google_service_account" "logger_account" {
  count        = var.VPC_COUNT
  account_id   = "${var.LOGGER_SERVICE_ACCOUNTID}-${count.index}"
  display_name = "${var.LOGGER_SERVICE_ACCOUNT_DISPLAY_NAME}-${count.index}"
}

resource "google_project_iam_binding" "logging_admin_binding" {
  count   = var.VPC_COUNT
  project = var.PROJECT
  role    = var.LOGGING_ADMIN_ROLE

  members = [
    "serviceAccount:${google_service_account.logger_account[count.index].email}"
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  count   = var.VPC_COUNT
  project = var.PROJECT
  role    = var.MONITORING_ROLE

  members = [
    "serviceAccount:${google_service_account.logger_account[count.index].email}"
  ]
}

resource "google_project_iam_binding" "pubsub_publisher" {
  count   = var.VPC_COUNT
  project = var.PROJECT
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.logger_account[count.index].email}"
  ]
}

resource "google_project_iam_binding" "pubsub_subscriber" {
  count   = var.VPC_COUNT
  project = var.PROJECT
  role    = var.ROLE_PUBSUB_SUBSCRIBER

  members = [
    "serviceAccount:${google_service_account.logger_account[count.index].email}"
  ]
}

resource "google_project_iam_binding" "cloud_function_invoker" {
  count   = var.VPC_COUNT
  project = var.PROJECT
  role    = var.ROLE_CLOUD_FUNCTION_INVOKER

  members = [
    "serviceAccount:${google_service_account.logger_account[count.index].email}"
  ]
}
