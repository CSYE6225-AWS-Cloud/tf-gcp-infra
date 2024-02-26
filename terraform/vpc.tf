resource "google_compute_network" "vpc" {
  count                           = var.VPC_COUNT
  name                            = "${var.VPC_NAME}-${count.index}"
  description                     = "${var.VPC_DESC}-${count.index}"
  auto_create_subnetworks         = false
  routing_mode                    = var.ROUTING_MODE
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  count         = var.VPC_COUNT
  ip_cidr_range = var.WEBAPP_CIDR_RANGE
  name          = var.VPC_COUNT == 1 ? var.WEBAPP_CONST : (count.index == 0 ? var.WEBAPP_CONST : "${var.WEBAPP_CONST}-${count.index}")
  network       = google_compute_network.vpc[count.index].id
  region        = var.REGION
}

resource "google_compute_subnetwork" "db" {
  count                    = var.VPC_COUNT
  ip_cidr_range            = var.DB_CIDR_RANGE
  name                     = var.VPC_COUNT == 1 ? var.DB_CONST : (count.index == 0 ? var.DB_CONST : "${var.DB_CONST}-${count.index}")
  network                  = google_compute_network.vpc[count.index].id
  region                   = var.REGION
  private_ip_google_access = true
}

resource "google_compute_route" "route" {
  count            = var.VPC_COUNT
  name             = var.VPC_COUNT == 1 ? "${var.WEBAPP_CONST}-route" : (count.index == 0 ? "${var.WEBAPP_CONST}-route" : "${var.WEBAPP_CONST}-route-${count.index}")
  dest_range       = var.FULL_INTERNET_RANGE
  next_hop_gateway = var.ROUTE_NEXT_HOP_GATEWAY
  network          = google_compute_network.vpc[count.index].id
  tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0 ? [
    var.WEBAPP_CONST
    ] : [
    "${var.WEBAPP_CONST}-${count.index}"
  ])
}