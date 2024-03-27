data "template_file" "startup_script" {
  count    = var.VPC_COUNT
  template = file("${path.module}/userdata.sh")
  vars = {
    APPLICATION_PORT = var.APPLICATION_PORT
    IP_ADDRESS       = google_sql_database_instance.database_instance[count.index].ip_address.0.ip_address
    USERNAME         = google_sql_user.users[count.index].name
    PASSWORD         = google_sql_user.users[count.index].password
    DB_NAME          = google_sql_database.database[count.index].name
  }
}

resource "google_compute_instance" "webapp_instance" {
  count                     = var.VPC_COUNT
  name                      = "${var.VM_WEBAPP_NAME}-${count.index}"
  machine_type              = var.VM_MACHINE_TYPE
  description               = "${var.VM_INSTANCE_DESC}-${count.index}"
  allow_stopping_for_update = true
  tags = var.VPC_COUNT == 1 ? [var.WEBAPP_CONST] : (count.index == 0 ? [
    var.WEBAPP_CONST
  ] : [
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

  service_account {
    email  = google_service_account.logger_account[count.index].email
    scopes = var.VM_SERVICE_ACCOUNT_SCOPES
  }
}