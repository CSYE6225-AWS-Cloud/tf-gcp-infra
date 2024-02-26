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
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  count    = var.VPC_COUNT
  name     = var.VPC_COUNT == 1 ? var.WEBAPP_CONST : (count.index == 0 ? var.WEBAPP_CONST : "${var.WEBAPP_CONST}-${count.index}")
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
  special          = false
}

resource "google_sql_user" "users" {
  count    = var.VPC_COUNT
  name     = var.WEBAPP_CONST
  instance = google_sql_database_instance.database_instance[count.index].name
  password = random_password.password.result
}