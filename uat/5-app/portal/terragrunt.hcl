

terraform {
  source = "../../../aws-modules/modules/5.0-ec2-asg"
}

include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../0-network", "../../1-iam", "../../2-storage", "../../4-ingress"]
}

dependency "vpc" {
  config_path = "../../0-network" # path of VPC module
  mock_outputs = {
    vpc_id = "vpc-1230213"
  }
}

dependency "iam" {
  config_path = "../../1-iam" # path of IAM module
  mock_outputs = {
    iam_instance_profile_name = "test-iam"
    code_deploy_arn           = "arn:1234::1234"
  }
}

dependency "ingress" {
  config_path = "../../4-ingress" # path of Ingress module
  mock_outputs = {
    alb_name = "uat-projectname-app"
  }
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

inputs = {
  # Description: Application name.
  app_name = "asg-api"

  # Description: Image id of your ec2 instance e.g "ami-06ced22e5bebf3066"
  image_id = "ami-03154560ae43bf45e"

  # Description: Allow access to EC2 on this list of ports. e.g [80, 443, 5010]
  ingress_ports = [443, "3000-5100"]

  # Description: Allow egress from EC2 on this list of ports. e.g [80, 443, 5010]
  egress_ports = [443, 80, 27017, 9092, "3000-5100"]

  # Description: ASG size
  asg_min_size         = 1
  asg_max_size         = 2
  asg_desired_capacity = 1

  # Description: Protocol and port that target group will expose. e.g HTTP:80 or HTTP:443
  protocol_port = "HTTP:3009"

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # Uncomment the ones you wish to set
  # --------------------------------------------------------------------------------------------------------------------

  # Description: Allow scheduling of instance for cost savings. uptime: 8:00AM, downtime: 5:00PM
  # scheduled_scaling = false

  # Description: Instance type. default value is t3a.small
  # instance_type = "t3a.small"

  # Description: Enable warm pool to reduce latency when scaling out your ASG
  enable_warm_pool = true

  # Description: Choose whether to deploy instance to on [Public or Private]
  # deploy_to = "private"

  # Description: Attach public IP on network interface.
  # associate_public_ip = false

  # Description: Variable to set code deploy's auto rollback to previous version.
  # auto_rollback = true  # Description: Parameters to fill in to attach ASG to load balancer. parameters are: enable: [bool], alb_name: [string], host_header_values: [string]
  attach_to_lb = {
    enable             = true
    host_header_values = "asg-portal.redengabrinez.online"
    alb_name           = dependency.ingress.outputs.alb_name
  }

  service_role_arn = dependency.iam.outputs.code_deploy_arn
  instance_profile = dependency.iam.outputs.iam_instance_profile_name
  vpc_id           = dependency.vpc.outputs.vpc_id
  environment      = include.env.locals.env
}
