resource "google_dns_record_set" "application" {
  count        = var.VPC_COUNT
  name         = var.DNS_A_RECORD_NAME
  type         = var.A_RECORD
  ttl          = var.DNS_TTL
  managed_zone = var.DNS_MANAGED_ZONE_NAME
  rrdatas = [
    google_compute_instance.webapp_instance[count.index].network_interface[0].access_config[0].nat_ip
  ]
}