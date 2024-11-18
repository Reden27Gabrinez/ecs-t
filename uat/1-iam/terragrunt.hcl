terraform {
  source = "../../aws-modules/modules/1-iam"
}

include "root" {
  path = find_in_parent_folders()
}

# Comment this line if you want to have common variables per environment
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------
  environment = include.env.locals.env
  # Description: List of names of environment config stored in ssm parameter store.
  parameter_store_env_names = ["ecommerce-portal-b64-env", "ecommerce-api-b64-env", "ecommerce-api-b64-eco", "ecommerce-portal-b64-eco"]
}
