terraform {
  source = "../../aws-modules/modules/4-ingress"
}

include "root" {
  path = find_in_parent_folders()
}

# Comment this line if you want to have common variables per environment
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "vpc" {
  config_path = "../0-network"
  mock_outputs = {
    vpc_id = "vpc-12345"
  }
}

# Change path depending on your need
dependencies {
  paths = ["../0-network"]
}

inputs = {
  load_balancer_name = "${include.env.locals.project_name}-${include.env.locals.env}"
  alb_security_group = { "egress_ports" = [80, 5003, 3000, 3001, 3009] }
  vpc_id             = dependency.vpc.outputs.vpc_id

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # Uncomment the ones you wish to set
  # --------------------------------------------------------------------------------------------------------------------

  # Description: Deploy ALB inside VPC
  # alb_deploy_internal = false

  # Description: Enable https to secure internet communication. e.g { enable: true, alb_certificate_name: '*.serino.com'}
  https =  {alb_certificate_name = "*.redengabrinez.online", enable = true}
}
