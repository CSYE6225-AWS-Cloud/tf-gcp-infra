resource "google_pubsub_topic" "verify_email_topic" {
  name                       = var.VERIFY_EMAIL_TOPIC_NAME
  message_retention_duration = var.VERIFY_EMAIL_TOPIC_RETENTION_DURATION
}

resource "google_pubsub_topic_iam_member" "pubsub_publisher_member" {
  project = google_pubsub_topic.verify_email_topic.project
  topic   = google_pubsub_topic.verify_email_topic.name
  role    = var.ROLE_PUBSUB_PUBLISHER
  member  = "serviceAccount:${google_service_account.vm_instance_account.email}"
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  name  = var.VERIFY_EMAIL_SUBSCRIPTION_NAME
  topic = google_pubsub_topic.verify_email_topic.id

  ack_deadline_seconds         = 20
  message_retention_duration   = var.VERIFY_EMAIL_TOPIC_RETENTION_DURATION
  enable_message_ordering      = true
  enable_exactly_once_delivery = true
}

resource "google_pubsub_subscription_iam_member" "pubsub_subscriber_member" {
  subscription = google_pubsub_subscription.verify_email_subscription.name
  role         = var.ROLE_PUBSUB_SUBSCRIBER
  member       = "serviceAccount:${google_service_account.vm_instance_account.email}"
}

