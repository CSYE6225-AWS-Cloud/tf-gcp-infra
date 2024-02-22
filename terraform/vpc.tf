resource "google_compute_network" "vpc" {
  count                           = var.VPC_COUNT
  name                            = "${var.PROJECT}-vpc-${count.index}"
  description                     = "${var.VPC_DESC}-${count.index}"
  auto_create_subnetworks         = false
  routing_mode                    = var.ROUTING_MODE
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  count         = var.VPC_COUNT
  ip_cidr_range = var.WEBAPP_CIDR_RANGE
  name          = var.VPC_COUNT == 1 ?var.WEBAPP_CONST : (count.index == 0 ? var.WEBAPP_CONST : "${var.WEBAPP_CONST}-${count.index}")
  network       = google_compute_network.vpc[count.index].id
  region        = var.REGION
}

resource "google_compute_subnetwork" "db" {
  count         = var.VPC_COUNT
  ip_cidr_range = var.DB_CIDR_RANGE
  name          = var.VPC_COUNT == 1 ?var.DB_CONST : (count.index == 0 ? var.DB_CONST : "${var.DB_CONST}-${count.index}")
  network       = google_compute_network.vpc[count.index].id
  region        = var.REGION
}

resource "google_compute_route" "route" {
  count            = var.VPC_COUNT
  name             = var.VPC_COUNT == 1 ? "${var.WEBAPP_CONST}-route" : (count.index == 0? "${var.WEBAPP_CONST}-route" : "${var.WEBAPP_CONST}-route-${count.index}")
  dest_range       = var.FULL_INTERNET_RANGE
  next_hop_gateway = var.ROUTE_NEXT_HOP_GATEWAY
  network          = google_compute_network.vpc[count.index].id
  tags             = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0? [
    var.WEBAPP_CONST
  ] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])
}

resource "google_compute_firewall" "allow_app_port" {
  count       = var.VPC_COUNT
  name        = "${var.PROJECT}-allow-${var.WEBAPP_CONST}-firewall-${count.index}"
  network     = google_compute_network.vpc[count.index].id
  description = var.APP_FIREWALL_ALLOW_DESC
  direction   = var.FIREWALL_INGRESS
  priority    = var.ALLOW_APP_PORT_FIREWALL_PRIORITY
  target_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0? [var.WEBAPP_CONST] : [
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
  target_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])

  deny {
    protocol = "tcp"
  }

  source_ranges = [var.FULL_INTERNET_RANGE]
}

resource "google_compute_instance" "webapp_instance" {
  count        = var.VPC_COUNT
  name         = "${var.VM_WEBAPP_NAME}-${count.index}"
  machine_type = var.VM_MACHINE_TYPE
  description  = "${var.VM_INSTANCE_DESC}-${count.index}"
  tags         = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])

  boot_disk {
    initialize_params {
      image = var.IMAGE
      size  = var.BOOT_DISK_SIZE
      type  = var.BOOT_DISK_TYPE
    }
    auto_delete = true
    device_name = "${var.WEBAPP_CONST}-vm-disk"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.webapp[count.index].id
    access_config {}
  }
}

resource "google_compute_firewall" "internal_ssh_conf" {
  count       = var.VPC_COUNT
  name        = "${var.PROJECT}-firewall-internal-ssh-${count.index}"
  network     = google_compute_network.vpc[count.index].id
  direction   = var.FIREWALL_INGRESS
  priority    = var.ALLOW_APP_PORT_FIREWALL_PRIORITY
  target_tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0? [var.WEBAPP_CONST] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}