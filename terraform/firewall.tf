resource "google_compute_firewall" "allow_app_port" {
  count       = var.VPC_COUNT
  name        = "${var.PROJECT}-allow-${var.WEBAPP_CONST}-firewall-${count.index}"
  network     = google_compute_network.vpc[count.index].id
  description = var.APP_FIREWALL_ALLOW_DESC
  direction   = var.FIREWALL_INGRESS
  priority    = var.ALLOW_APP_PORT_FIREWALL_PRIORITY
  target_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0 ? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])

  allow {
    protocol = "tcp"
    ports    = [var.APPLICATION_PORT]
  }

  source_ranges = [var.FULL_INTERNET_RANGE]
}

resource "google_compute_firewall" "deny_all" {
  count       = var.VPC_COUNT
  name        = "${var.PROJECT}-deny-${var.WEBAPP_CONST}-all-firewall-${count.index}"
  network     = google_compute_network.vpc[count.index].id
  description = var.APP_FIREWALL_DENY_ALL_DESC
  direction   = var.FIREWALL_INGRESS
  priority    = var.DENY_ALL_PORT_FIREWALL_PRIORITY
  target_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0 ? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])

  deny {
    protocol = "tcp"
  }

  source_ranges = [var.FULL_INTERNET_RANGE]
}

resource "google_compute_firewall" "sql_access" {
  count     = var.VPC_COUNT
  name      = "allow-sql-access-${count.index}"
  network   = google_compute_network.vpc[count.index].id
  direction = var.FIREWALL_INGRESS

  allow {
    protocol = "tcp"
    ports    = [var.DATABASE_PORT]
  }

  source_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0 ? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])
  source_ranges = [
    google_compute_instance.webapp_instance[count.index].network_interface.0.network_ip
  ]
  destination_ranges = [
    google_sql_database_instance.database_instance[count.index].first_ip_address
  ]
}