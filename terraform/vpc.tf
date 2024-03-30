resource "google_compute_network" "vpc" {
  name                            = var.VPC_NAME
  description                     = var.VPC_DESC
  auto_create_subnetworks         = false
  routing_mode                    = var.ROUTING_MODE
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "webapp" {
  ip_cidr_range            = var.WEBAPP_CIDR_RANGE
  name                     = var.WEBAPP_CONST
  network                  = google_compute_network.vpc.id
  region                   = var.REGION
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "db" {
  ip_cidr_range            = var.DB_CIDR_RANGE
  name                     = var.DB_CONST
  network                  = google_compute_network.vpc.id
  region                   = var.REGION
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "serverless" {
  ip_cidr_range = var.SERVERLESS_CIDR_RANGE
  name          = var.SERVERLESS_CONST
  network       = google_compute_network.vpc.id
  region        = var.REGION
}

resource "google_vpc_access_connector" "connector" {
  name = var.VPC_CONNECTOR_NAME
  subnet {
    name = google_compute_subnetwork.serverless.name
  }
  machine_type = var.VPC_CONNECTOR_MACHINE_TYPE
}

resource "google_compute_route" "route" {
  name             = "${var.WEBAPP_CONST}-route"
  dest_range       = var.FULL_INTERNET_RANGE
  next_hop_gateway = var.ROUTE_NEXT_HOP_GATEWAY
  network          = google_compute_network.vpc.id
  tags             = [var.WEBAPP_CONST]
}