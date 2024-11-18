terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders()
}

# Comment this line if you want to have common variables per environment
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
}

inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------
  environment = include.env.locals.env
  # Description: List of names of environment config stored in ssm parameter store.
  parameter_store_env_names = []
}
