variable "load_balancer_name" {
  description = "Name of ALB."
  type = string
}

variable "alb_deploy_internal" {
  description = "Deploy ALB inside VPC"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Id of VPC where ALB will be deployed. Must have atleast 2 subnets deployed in differernt AZ."
  type = string
}

variable "https" {
  description = "Enable https to secure internet communication. e.g { enable: true, alb_certificate_name: 'web.example.com'}"
  type = object({
    enable               = bool
    alb_certificate_name = string
  })
  default = {
    enable               = false
    alb_certificate_name = null
  }
}

variable "alb_security_group" {
  description = "list of ports that ALB needs to reach out. e.g { egress_ports: [443, 80, 3000] }"
  type = object({
    egress_ports = list(string)
  })
}