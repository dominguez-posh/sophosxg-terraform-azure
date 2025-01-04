// Azure configuration
variable "subscription_id" {
  type    = string
  default = "9561adc1-4585-4110-9645-0323f841560c"
}

variable "location" {
  type    = string
  default = "germanywestcentral"
}

variable "sfos_dnsname" {
  type    = string
  default = "sfosxgstest123"
}

// Standard_D2s_v3
variable "size" {
  type    = string
  default = "Standard_D2s_v3"
}

// License Type to create Sophos-VM
// Provide the license type for Sophos-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
  #default = "payg-new"
}

variable "vnetcidr" {
  default = "10.1.0.0/16"
}

variable "publiccidr" {
  default = "10.1.0.0/24"
}

variable "xgswanip" {
  default = "10.1.0.254"
}

variable "privatecidr" {
  default = "10.1.1.0/24"
}

variable "xgslanip" {
  default = "10.1.1.254"
}

variable "environment_tag" {
  default = "Terraform Sophos Deployment"
}

variable "publisher" {
  type    = string
  default = "sophos"
}

variable "adminusername" {
  type    = string
  default = "sfosadm"
}

// To accept marketplace agreement
variable "accept" {
  default = "true"
}