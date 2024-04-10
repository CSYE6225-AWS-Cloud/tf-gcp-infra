resource "google_compute_global_address" "webapp_global_address" {
  name = var.LB_GLOBAL_ADDRESS_NAME
}

resource "google_compute_global_forwarding_rule" "webapp_forwarding_rule" {
  name                  = var.LB_FORWARDING_RULE_NAME
  load_balancing_scheme = var.LB_LOAD_BALANCING_SCHEME
  port_range            = var.LB_FORWARDING_PORT
  target                = google_compute_target_https_proxy.webapp_https_proxy.id
  ip_address            = google_compute_global_address.webapp_global_address.id
}

resource "google_compute_target_https_proxy" "webapp_https_proxy" {
  name    = var.LB_HTTPS_PROXY
  url_map = google_compute_url_map.webapp_url_map.id
  ssl_certificates = [
    var.LB_SSL_CERTIFICATE
  ]
}

resource "google_compute_url_map" "webapp_url_map" {
  name            = var.LB_URL_MAP_NAME
  default_service = google_compute_backend_service.webapp_backend_service.id
}

resource "google_compute_region_instance_group_manager" "appserver" {
  name               = var.GROUP_MANAGER_NAME
  base_instance_name = var.GROUP_BASE_INSTANCE_NAME

  version {
    instance_template = google_compute_region_instance_template.webapp_instance_template.self_link
  }

  named_port {
    name = "http"
    port = var.APPLICATION_PORT
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_health_check.id
    initial_delay_sec = var.GROUP_MANAGER_AUTOHEALING_INITIAL_DELAY
  }
}

resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  name   = var.AUTOSCALER_NAME
  target = google_compute_region_instance_group_manager.appserver.id

  autoscaling_policy {
    max_replicas = var.AUTOSCALER_MAX_REPLICAS
    min_replicas = var.AUTOSCALER_MIN_REPLICAS
    cooldown_period = var.AUTOSCALER_COOLDOWN_PERIOD

    cpu_utilization {
      target = var.AUTOSCALER_CPU_UTILIZATION
    }
  }
}

resource "google_compute_health_check" "http_health_check" {
  name = var.HEALTH_CHECK_NAME

  timeout_sec        = var.HEALTH_CHECK_TIMEOUT
  check_interval_sec = var.HEALTH_CHECK_INTERVAL

  http_health_check {
    port         = var.APPLICATION_PORT
    request_path = var.HEALTH_CHECK_REQUEST_PATH
  }

  log_config {
    enable = true
  }
}

resource "google_compute_backend_service" "webapp_backend_service" {
  name                  = var.LB_BACKEND_SERVICE_NAME
  protocol              = var.LB_BACKEND_SERVICE_PROTOCOL
  load_balancing_scheme = var.LB_LOAD_BALANCING_SCHEME
  timeout_sec           = var.LB_BACKEND_SERVICE_TIMEOUT
  health_checks         = [google_compute_health_check.http_health_check.id]
  backend {
    group           = google_compute_region_instance_group_manager.appserver.instance_group
    balancing_mode  = var.LB_BACKEND_SERVICE_BALANCING_MODE
    capacity_scaler = var.LB_BACKEND_SERVICE_CAPACITY_SCALER
  }
}