resource "google_cloudfunctions2_function" "verify_email_function" {
  location    = var.REGION
  name        = var.VERIFY_EMAIL_FUNC_NAME
  description = var.VERIFY_EMAIL_FUNC_DESC

  build_config {
    runtime     = var.FUNCTION_RUNTIME_JAVA
    entry_point = var.VERIFY_EMAIL_FUNCTION_ENTRY
    source {
      storage_source {
        bucket = google_storage_bucket.functions_bucket.name
        object = google_storage_bucket_object.serverless_function_archive.name
      }
    }
  }

  service_config {
    max_instance_count             = 1
    available_memory               = var.VERIFY_EMAIL_FUNCTION_AVAILABLE_MEMORY
    timeout_seconds                = var.VERIFY_FUNCTION_TIMEOUT
    ingress_settings               = var.VERIFY_FUNCTION_INGRESS
    all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.logger_account.email
    environment_variables = {
      CSYE6225_SQL_DB_CONNSTR = "jdbc:mysql://${google_sql_database_instance.database_instance.ip_address.0.ip_address}/${google_sql_database.database.name}"
      CSYE6225_SQL_DB_USER    = google_sql_user.users.name
      CSYE6225_SQL_DB_PWD     = google_sql_user.users.password
      MAILGUN_API_KEY         = var.MAILGUN_API_KEY
      SENDER_DOMAIN           = var.SENDER_DOMAIN
    }
    vpc_connector                 = google_vpc_access_connector.connector.id
    vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
  }

  event_trigger {
    trigger_region = var.REGION
    event_type     = var.VERIFY_FUNCTION_EVENT_TYPE
    pubsub_topic   = google_pubsub_topic.verify_email_topic.id
    retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
  }

}

resource "google_storage_bucket" "functions_bucket" {
  name          = "${var.PROJECT}-functions-bucket"
  location      = var.STORAGE_BUCKET_LOCATION
  force_destroy = true
}

resource "google_storage_bucket_object" "serverless_function_archive" {
  name   = var.FUNCTION_ARCHIVE_NAME
  bucket = google_storage_bucket.functions_bucket.name
  source = var.FUNCTION_ARCHIVE_LOCAL_PATH
}

resource "google_cloudfunctions2_function_iam_member" "functions_invoker_member" {
  cloud_function = google_cloudfunctions2_function.verify_email_function.name

  role   = var.ROLE_CLOUD_FUNCTION_INVOKER
  member = "serviceAccount:${google_service_account.logger_account.email}"
}