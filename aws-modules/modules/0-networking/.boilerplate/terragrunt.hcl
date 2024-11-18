terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders()
}

# Uncomment this line if you want to have common variables per environment
# include "env" {
#   path           = find_in_parent_folders("env.hcl")
#   expose         = true
# }

inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------
  cidr_block      = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  environment     = include.env.locals.env
  project_name    = include.env.locals.project_name

  # --------------------------------------------------------------------------------------------------------------------
  # Optional input variables
  # Uncomment the ones you wish to set
  # --------------------------------------------------------------------------------------------------------------------

  # Description: Private subnets dedicated to database

  # database_subnets = []

  # Description: Object that contains tags.
  # tags = {Name = "sample-app", environment = "uat"}

  # Description: Enable private access on ec2 instance using session manager.
  # enable_ssm = false

  # Description: Allow creation of NAT gateway for private instance to communicate to the internet.
  # enable_nat = false
}
