resource "google_compute_network" "vpc" {
  name                            = "${var.PROJECT}-vpc"
  description                     = var.VPC_DESC
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet" {
  count = length(var.SUBNET)
  ip_cidr_range = var.SUBNET[count.index].ip_cidr_range
  name          = var.SUBNET[count.index].name
  network       = google_compute_network.vpc.id
  region        = var.REGION
}

resource "google_compute_route" "route" {
  count = length(var.ROUTE)
  name             = var.ROUTE[count.index].name
  dest_range       = var.ROUTE[count.index].dest_range
  next_hop_gateway = "default-internet-gateway"
  network          = google_compute_network.vpc.id
  tags             = var.ROUTE[count.index].tags
}