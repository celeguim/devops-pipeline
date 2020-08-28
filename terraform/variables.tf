variable vpc_name { default = "VPC HA Custom" }

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "public_subnet_cidr_block" {
  default = "10.10.1.0/24"
}

variable "private_subnet_cidr_block" {
  default = "10.10.2.0/24"
}
