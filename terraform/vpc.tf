resource "google_compute_network" "vpc" {
  count                           = var.VPC_COUNT
  name                            = "${var.PROJECT}-vpcd-${count.index}"
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
  count                    = var.VPC_COUNT
  ip_cidr_range            = var.DB_CIDR_RANGE
  name                     = var.VPC_COUNT == 1 ?var.DB_CONST : (count.index == 0 ? var.DB_CONST : "${var.DB_CONST}-${count.index}")
  network                  = google_compute_network.vpc[count.index].id
  region                   = var.REGION
  private_ip_google_access = true
}

resource "google_service_networking_connection" "db_private_vpc_conn" {
  count                   = var.VPC_COUNT
  network                 = google_compute_network.vpc[count.index].id
  service                 = var.SERVICE_NETWORK_API
  reserved_peering_ranges = [google_compute_global_address.db_private_ip[count.index].name]
}

resource "google_sql_database_instance" "database_instance" {
  count               = var.VPC_COUNT
  name                = "database-instance-${count.index}"
  database_version    = var.DATABASE_VERSION
  depends_on          = [google_service_networking_connection.db_private_vpc_conn]
  deletion_protection = false

  settings {
    tier              = var.DATABASE_TIER
    availability_type = var.DATABASE_AVAILABILITY_TYPE
    disk_size         = var.DATABASE_DISK_SIZE
    disk_type         = var.DATABASE_DISK_TYPE

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc[count.index].id
      enable_private_path_for_google_cloud_services = true

      /*authorized_networks { //TODO
        name  = "db-auth-net-${count.index}"
        value = google_compute_instance.webapp_instance[count.index].network_interface.0.network_ip
      }*/
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  count    = var.VPC_COUNT
  name     = var.VPC_COUNT == 1 ?var.WEBAPP_CONST : (count.index == 0 ? var.WEBAPP_CONST : "${var.WEBAPP_CONST}-${count.index}")
  instance = google_sql_database_instance.database_instance[count.index].name
}

resource "google_compute_global_address" "db_private_ip" {
  count         = var.VPC_COUNT
  name          = "db-private-ip-${count.index}"
  purpose       = var.DB_GLOBAL_ADDRESS_PURPOSE
  prefix_length = var.DB_GLOBAL_ADDRESS_CIDR_PREFIX
  address_type  = var.DB_GLOBAL_ADDRESS_TYPE
  network       = google_compute_network.vpc[count.index].id
}

resource "random_password" "password" {
  length           = var.RANDOM_PASS_LEN
  special          = true
  override_special = var.RANDOM_PASS_SPL_CHARS
}

resource "google_sql_user" "users" {
  count    = var.VPC_COUNT
  name     = var.WEBAPP_CONST
  instance = google_sql_database_instance.database_instance[count.index].name
  password = random_password.password.result
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

data "template_file" "startup_script" {
  count    = var.VPC_COUNT
  template = file("${path.module}/userdata.sh")
  vars     = {
    APPLICATION_PORT = var.APPLICATION_PORT
    IP_ADDRESS       = google_sql_database_instance.database_instance[count.index].ip_address.0.ip_address
    USERNAME         = google_sql_user.users[count.index].name
    PASSWORD         = google_sql_user.users[count.index].password
    DB_NAME          = google_sql_database.database[count.index].name
  }
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

  metadata_startup_script = data.template_file.startup_script[count.index].rendered
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