# CSYE6225 - Terraform IaC - Google Cloud Platform

## Stack
- **Infrastructure as Code (IaC) Tool**: Terraform
- **Cloud Provider**: Google Cloud Platform (GCP)

## Change Log
### Version #1
- **VPC Configuration**:
    - Disabled auto-creation of subnets
    - Deleted default routes on creation
- **Subnet Configuration**:
    - Created two subnets for the VPC
- **Route Configuration**:
    - Configured a route for one of the subnets within the VPC
