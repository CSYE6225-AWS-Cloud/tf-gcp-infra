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
  default     = "webapp-20240221174909"
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