variable "environment" {
  type        = string
  description = "Name of environment"
}

variable "project_name" {
  type = string
}

variable "cidr_block" {
  type        = string
  description = "CIDR block to be used by the vpc."
}

variable "private_subnets" {
  description = "Private subnets of VPC e.g 10.0.1.0/24, 10.0.2.0/24"
  type    = list(string)
}

variable "public_subnets" {
  type    = list(string)
  description = "Public subnets of VPC e.g 10.0.1.0/24, 10.0.2.0/24"
}

variable "database_subnets" {
  description = "Private subnets dedicated to database"
  type    = list(string)
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Object that contains tags."
  default     = null
}

variable "enable_ssm" {
  description = "Enable private access on ec2 instance using session manager."
  type    = bool
  default = false
}

variable "enable_nat" {
  description = "Allow creation of NAT gateway for private instance to communicate to the internet."
  type = bool
  default = false
}