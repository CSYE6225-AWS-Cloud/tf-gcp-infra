resource "google_compute_network" "vpc" {
  count                           = var.VPC_COUNT
  name                            = "${var.PROJECT}-vpc-${count.index}"
  description                     = "${var.VPC_DESC}-${count.index}"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet" {
  count         = var.VPC_COUNT * length(var.SUBNET)
  ip_cidr_range = var.SUBNET[count.index%length(var.SUBNET)].ip_cidr_range
  name          = var.VPC_COUNT == 1 ? var.SUBNET[count.index%length(var.SUBNET)].name : "${var.SUBNET[count.index%length(var.SUBNET)].name}-${floor(count.index / length(var.SUBNET))}${count.index%length(var.SUBNET)}"
  network       = google_compute_network.vpc[floor(count.index / length(var.SUBNET))].id
  region        = var.REGION
}

resource "google_compute_route" "route" {
  count            = var.VPC_COUNT
  name             = var.VPC_COUNT == 1 ? var.ROUTE[0].name : "${var.ROUTE[0].name}-${floor(count.index / length(var.SUBNET))}${count.index%length(var.SUBNET)}"
  dest_range       = var.ROUTE[0].dest_range
  next_hop_gateway = "default-internet-gateway"
  network          = google_compute_network.vpc[floor(count.index / length(var.SUBNET))].id
  tags             = var.VPC_COUNT == 1 ? [var.ROUTE[0].tags] : [
    "${var.ROUTE[0].tags}-${floor(count.index / length(var.SUBNET))}${count.index%length(var.SUBNET)}"
  ]
}