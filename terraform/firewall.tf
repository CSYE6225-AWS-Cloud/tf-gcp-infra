resource "google_compute_firewall" "allow_app_port" {
  name        = "${var.PROJECT}-allow-${var.WEBAPP_CONST}-firewall"
  network     = google_compute_network.vpc.id
  description = var.APP_FIREWALL_ALLOW_DESC
  direction   = var.FIREWALL_INGRESS
  priority    = var.ALLOW_APP_PORT_FIREWALL_PRIORITY
  target_tags = [var.WEBAPP_CONST]

  allow {
    protocol = "tcp"
    ports    = [var.APPLICATION_PORT]
  }

  source_ranges = [google_compute_global_address.webapp_global_address.address]
}

resource "google_compute_firewall" "allow_lb_health_checks" {
  name    = "allow-lb-health-checks"
  network = google_compute_network.vpc.id

  allow {
    protocol = "tcp"
    ports    = [var.APPLICATION_PORT]
  }

  source_ranges = var.LB_HEALTH_CHECK_RANGES
  target_tags   = [var.WEBAPP_CONST]
}

resource "google_compute_firewall" "deny_all" {
  name        = "${var.PROJECT}-deny-${var.WEBAPP_CONST}-all-firewall"
  network     = google_compute_network.vpc.id
  description = var.APP_FIREWALL_DENY_ALL_DESC
  direction   = var.FIREWALL_INGRESS
  priority    = var.DENY_ALL_PORT_FIREWALL_PRIORITY
  target_tags = [var.WEBAPP_CONST]

  deny {
    protocol = "tcp"
  }

  source_ranges = [var.FULL_INTERNET_RANGE]
}

resource "google_compute_firewall" "sql_access" {
  name      = "${var.PROJECT}-allow-sql-access"
  network   = google_compute_network.vpc.id
  direction = var.FIREWALL_INGRESS
  priority  = var.ALLOW_APP_PORT_FIREWALL_PRIORITY

  allow {
    protocol = "tcp"
    ports    = [var.DATABASE_PORT]
  }

  source_tags = [var.WEBAPP_CONST]
  destination_ranges = [
    google_sql_database_instance.database_instance.first_ip_address
  ]
}