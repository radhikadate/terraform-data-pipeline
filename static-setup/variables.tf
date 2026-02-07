variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.20.0.0/20"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.20.16.0/20"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
  default     = "10.20.128.0/20"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
  default     = "10.20.144.0/20"
}

variable "availability_zone_1" {
  description = "Availability zone for subnet 1"
  type        = string
  default     = "ap-southeast-2a"
}

variable "availability_zone_2" {
  description = "Availability zone for subnet 2"
  type        = string
  default     = "ap-southeast-2b"
}
