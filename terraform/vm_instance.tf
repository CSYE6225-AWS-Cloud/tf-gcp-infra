data "template_file" "startup_script" {
  template = file("${path.module}/userdata.sh")
  vars = {
    APPLICATION_PORT = var.APPLICATION_PORT
    IP_ADDRESS       = google_sql_database_instance.database_instance.ip_address.0.ip_address
    USERNAME         = google_sql_user.users.name
    PASSWORD         = google_sql_user.users.password
    DB_NAME          = google_sql_database.database.name
  }
}

resource "google_compute_region_instance_template" "webapp_instance_template" {
  name         = var.VM_WEBAPP_NAME
  description  = var.VM_INSTANCE_DESC
  machine_type = var.VM_MACHINE_TYPE
  tags         = [var.WEBAPP_CONST]

  disk {
    device_name  = var.VM_DISK_DEVICE_NAME
    source_image = var.IMAGE
    disk_size_gb = var.BOOT_DISK_SIZE
    auto_delete  = true
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.vm_disk_key.id
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.webapp.id
  }

  service_account {
    email  = google_service_account.vm_instance_account.email
    scopes = var.VM_SERVICE_ACCOUNT_SCOPES
  }

  metadata_startup_script = data.template_file.startup_script.rendered
}