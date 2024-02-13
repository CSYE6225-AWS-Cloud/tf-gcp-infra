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

variable "GCP_CRED_PATH" {
  type        = string
  default     = "F:/NEU/Cloud/assignments/Java/csye6225-tf-gcp-infra-b2e7c205dc81.json"
  description = "Credentials path of the infrastructure"
}

variable "PROJECT" {
  type        = string
  default     = "csye6225-tf-gcp-infra"
  description = "Project name of the infrastructure"
}

variable "VPC_DESC" {
  type        = string
  default     = "VPC network for csye6225"
  description = "VPC network description"
}

variable "SUBNET" {
  type = list(object({
    ip_cidr_range = string
    name          = string
  }))
  default = [
    {
      ip_cidr_range = "10.0.0.0/24"
      name          = "webapp"
    },
    {
      ip_cidr_range = "10.0.1.0/24"
      name          = "db"
    }
  ]
  description = "VPC subnet configs"
}

variable "ROUTE" {
  type = list(object({
    name       = string
    dest_range = string
    tags       = list(string)
  }))
  default = [
    {
      name       = "webapp-route"
      dest_range = "0.0.0.0/0"
      tags       = ["webapp"]
    }
  ]
  description = "VPC route configs"
}