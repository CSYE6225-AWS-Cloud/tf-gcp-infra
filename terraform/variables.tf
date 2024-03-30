variable "REGION" {
  type        = string
  default     = "us-east1"
  description = "Region to create the infrastructure"
}

variable "ZONE" {
  type        = string
  default     = "us-east-1-b"
  description = "Zone in the Region to create the infrastructure"
}

variable "VPC_COUNT" {
  type        = number
  default     = 1
  description = "Number of VPCs to create"
}

variable "VPC_NAME" {
  type        = string
  default     = "csye6225-vpc-network"
  description = "VPC Name"
}

variable "PROJECT" {
  type        = string
  default     = "csye6225-dev-415001"
  description = "Project name of the infrastructure"
}

variable "VPC_DESC" {
  type        = string
  default     = "VPC network for csye6225"
  description = "VPC network description"
}

variable "ROUTING_MODE" {
  type        = string
  default     = "REGIONAL"
  description = "VPC routing mode"
}

variable "IMAGE" {
  type        = string
  default     = "webapp-20240327130821"
  description = "Custom webapp image name"
}

variable "ROUTE_NEXT_HOP_GATEWAY" {
  type        = string
  default     = "default-internet-gateway"
  description = "Next hop gateway for route"
}

variable "WEBAPP_CONST" {
  type        = string
  default     = "webapp"
  description = "Application all constant"
}

variable "DB_CONST" {
  type        = string
  default     = "db"
  description = "DB all constant"
}

variable "BOOT_DISK_SIZE" {
  type        = number
  default     = 100
  description = "VM disk size"
}

variable "BOOT_DISK_TYPE" {
  type        = string
  default     = "pd-balanced"
  description = "VM disk type"
}

variable "VM_MACHINE_TYPE" {
  type        = string
  default     = "custom-1-2048" # custom - 1 cpu - 2gb ram
  description = "VM Machine Type"
}

variable "VM_INSTANCE_DESC" {
  type        = string
  default     = "VM instance to run webapp"
  description = "VM instance description"
}

variable "VM_WEBAPP_NAME" {
  type        = string
  default     = "webapp-vm-instance"
  description = "Instance name for webapp VM instance"
}

variable "FULL_INTERNET_RANGE" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Entire internet range CIDR"
}

variable "APP_FIREWALL_ALLOW_DESC" {
  type        = string
  default     = "Allow application for internet traffic"
  description = "Application port allow firewall description"
}

variable "APP_FIREWALL_DENY_ALL_DESC" {
  type        = string
  default     = "Deny all for internet traffic"
  description = "Deny all for internet traffic"
}

variable "FIREWALL_INGRESS" {
  type        = string
  default     = "INGRESS"
  description = "Ingress direction "
}

variable "ALLOW_APP_PORT_FIREWALL_PRIORITY" {
  type        = number
  default     = 1000
  description = "Priority for allowing app port firewall"
}

variable "DENY_ALL_PORT_FIREWALL_PRIORITY" {
  type        = number
  default     = 1001
  description = "Priority for allowing app port firewall"
}

variable "APPLICATION_PORT" {
  type        = string
  default     = "8080"
  description = "Application run port"
}

variable "WEBAPP_CIDR_RANGE" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Webapp subnet cidr range"
}

variable "DB_CIDR_RANGE" {
  type        = string
  default     = "10.0.1.0/24"
  description = "DB subnet cidr range"
}

variable "SERVICE_NETWORK_API" {
  type        = string
  default     = "servicenetworking.googleapis.com"
  description = "Private service networking access - url"
}

variable "DATABASE_VERSION" {
  type        = string
  default     = "MYSQL_8_0"
  description = "Database version for DB instance"
}

variable "DATABASE_TIER" {
  type        = string
  default     = "db-custom-1-3840"
  description = "Database vm instance tier"
}

variable "DATABASE_AVAILABILITY_TYPE" {
  type        = string
  default     = "REGIONAL"
  description = "Database availability type"
}

variable "DATABASE_DISK_SIZE" {
  type        = number
  default     = 10
  description = "Database disk size"
}

variable "DATABASE_DISK_TYPE" {
  type        = string
  default     = "PD_SSD"
  description = "Database disk type - hdd/ssd"
}

variable "DB_GLOBAL_ADDRESS_PURPOSE" {
  type        = string
  default     = "VPC_PEERING"
  description = "Database global compute address purpose"
}

variable "DB_GLOBAL_ADDRESS_CIDR_PREFIX" {
  type        = number
  default     = 24
  description = "Database global compute address cidr prefix"
}

variable "DB_GLOBAL_ADDRESS_TYPE" {
  type        = string
  default     = "INTERNAL"
  description = "Database global compute address type"
}

variable "RANDOM_PASS_LEN" {
  type        = number
  default     = 16
  description = "Database random password length"
}

variable "DATABASE_PORT" {
  type        = string
  default     = "3306"
  description = "Cloud SQL database port"
}

variable "LOGGER_SERVICE_ACCOUNTID" {
  type        = string
  default     = "csye6225-logging"
  description = "Service account id for logger service VM attach"
}

variable "LOGGER_SERVICE_ACCOUNT_DISPLAY_NAME" {
  type        = string
  default     = "CSYE6225 Application logging"
  description = "Service account display name for logger service VM attach"
}

variable "LOGGING_ADMIN_ROLE" {
  type        = string
  default     = "roles/logging.admin"
  description = "Service account logging admin role"
}

variable "MONITORING_ROLE" {
  type        = string
  default     = "roles/monitoring.metricWriter"
  description = "Service account Monitoring metric writer role"
}

variable "VM_SERVICE_ACCOUNT_SCOPES" {
  type        = list(string)
  default     = ["logging-write", "monitoring-write", "pubsub"]
  description = "VM Instance service account scopes"
}

variable "DNS_A_RECORD_NAME" {
  type        = string
  default     = "gokulakrishnanr.me."
  description = "DNS Name"
}

variable "A_RECORD" {
  type        = string
  default     = "A"
  description = "A Record"
}

variable "DNS_TTL" {
  type        = number
  default     = 60
  description = "DNS Time to live"
}

variable "DNS_MANAGED_ZONE_NAME" {
  type        = string
  default     = "csye6225"
  description = "DNS Managed zone name"
}

variable "SERVERLESS_CONST" {
  type        = string
  default     = "serverless"
  description = "serverless all constant"
}

variable "MAILGUN_API_KEY" {
  type        = string
  description = "Mailgun api key"
}

variable "SENDER_DOMAIN" {
  type        = string
  default     = "gokulakrishnanr.me"
  description = "Sender domain"
}

variable "VERIFY_EMAIL_FUNC_NAME" {
  type        = string
  default     = "verify-email-function"
  description = "Verify email function name"
}

variable "VERIFY_EMAIL_FUNC_DESC" {
  type        = string
  default     = "Spring Cloud Function to send user verification email"
  description = "Verify email function description"
}

variable "FUNCTION_RUNTIME_JAVA" {
  type        = string
  default     = "java17"
  description = "Cloud serverless function runtime type - java"
}

variable "VERIFY_EMAIL_FUNCTION_ENTRY" {
  type        = string
  default     = "com.neu.csye6225.cloud.functions.VerificationEmailFunction"
  description = "Verify email function java entry point class"
}

variable "VERIFY_EMAIL_FUNCTION_AVAILABLE_MEMORY" {
  type        = string
  default     = "256M"
  description = "Verify email function memory"
}

variable "VERIFY_FUNCTION_TIMEOUT" {
  type    = number
  default = 60
}

variable "VERIFY_FUNCTION_INGRESS" {
  type    = string
  default = "ALLOW_INTERNAL_ONLY"
}

variable "VERIFY_FUNCTION_EVENT_TYPE" {
  type    = string
  default = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "FUNCTION_ARCHIVE_NAME" {
  type    = string
  default = "serverless-0.0.1-SNAPSHOT-jar-with-dependencies.zip"
}

variable "FUNCTION_ARCHIVE_LOCAL_PATH" {
  type    = string
  default = "F:/NEU/Cloud/assignments/Java/serverless-fork/target/serverless-0.0.1-SNAPSHOT-jar-with-dependencies.zip"
}

variable "ROLE_CLOUD_FUNCTION_INVOKER" {
  type    = string
  default = "roles/cloudfunctions.invoker"
}

variable "STORAGE_BUCKET_LOCATION" {
  type    = string
  default = "US"
}

variable "VERIFY_EMAIL_TOPIC_NAME" {
  type    = string
  default = "verify_email"
}

variable "VERIFY_EMAIL_TOPIC_RETENTION_DURATION" {
  type    = string
  default = "604800s"
}

variable "ROLE_PUBSUB_PUBLISHER" {
  type    = string
  default = "roles/pubsub.publisher"
}

variable "VERIFY_EMAIL_SUBSCRIPTION_NAME" {
  type    = string
  default = "verify-email-subscription"
}

variable "ROLE_PUBSUB_SUBSCRIBER" {
  type    = string
  default = "roles/pubsub.subscriber"
}

variable "SERVERLESS_CIDR_RANGE" {
  type    = string
  default = "10.0.2.0/28"
}

variable "VPC_CONNECTOR_NAME" {
  type    = string
  default = "vpc-con"
}

variable "VPC_CONNECTOR_MACHINE_TYPE" {
  type    = string
  default = "f1-micro"
}

variable "AUTOSCALER_NAME" {
  type    = string
  default = "webapp-autoscaler"
}

variable "AUTOSCALER_MAX_REPLICAS" {
  type    = number
  default = 2
}

variable "AUTOSCALER_MIN_REPLICAS" {
  type    = number
  default = 1
}

variable "HEALTH_CHECK_TIMEOUT" {
  type    = number
  default = 20
}
variable "HEALTH_CHECK_INTERVAL" {
  type    = number
  default = 30
}
variable "HEALTH_CHECK_REQUEST_PATH" {
  type    = string
  default = "/healthz"
}
variable "AUTOSCALER_CPU_UTILIZATION" {
  type    = number
  default = 0.05
}
variable "HEALTH_CHECK_NAME" {
  type    = string
  default = "http-health-check"
}
variable "GROUP_MANAGER_NAME" {
  type    = string
  default = "webapp-igm"
}
variable "GROUP_BASE_INSTANCE_NAME" {
  type    = string
  default = "webapp"
}
variable "GROUP_MANAGER_AUTOHEALING_INITIAL_DELAY" {
  type    = number
  default = 300
}
variable "LB_URL_MAP_NAME" {
  type    = string
  default = "l7-xlb-url-map"
}
variable "LB_HTTPS_PROXY" {
  type    = string
  default = "lb-https-proxy"
}
variable "LB_SSL_CERTIFICATE" {
  type    = string
  default = "projects/csye6225-dev-415001/global/sslCertificates/csye6225-gokulakrishnanr"
}
variable "LB_FORWARDING_RULE_NAME" {
  type    = string
  default = "l7-xlb-forwarding-rule"
}
variable "LB_LOAD_BALANCING_SCHEME" {
  type    = string
  default = "EXTERNAL"
}
variable "LB_FORWARDING_PORT" {
  type    = string
  default = "443"
}
variable "LB_BACKEND_SERVICE_NAME" {
  type    = string
  default = "l7-xlb-backend-service"
}
variable "LB_BACKEND_SERVICE_PROTOCOL" {
  type    = string
  default = "HTTP"
}
variable "LB_BACKEND_SERVICE_TIMEOUT" {
  type    = number
  default = 10
}
variable "LB_BACKEND_SERVICE_BALANCING_MODE" {
  type    = string
  default = "UTILIZATION"
}

variable "LB_BACKEND_SERVICE_CAPACITY_SCALER" {
  type    = number
  default = 1.0
}

variable "LB_GLOBAL_ADDRESS_NAME" {
  type    = string
  default = "l7-xlb-static-ip"
}

variable "LB_HEALTH_CHECK_RANGES" {
  type    = list(string)
  default = ["130.211.0.0/22", "35.191.0.0/16"]
}