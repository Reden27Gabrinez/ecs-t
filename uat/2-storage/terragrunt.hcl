terraform {
  source = "../../aws-modules/modules/2-storage"
}

include "root" {
  path = find_in_parent_folders()
}

# Comment this line if you want to have common variables per environment
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "iam" {
  config_path = "../1-iam"
  mock_outputs = {
    iam_instance_role = "test-iam-profile-name"
  }
}

# Change path depending on your need
dependencies {
  paths = ["../1-iam"]
}

inputs = {
  # --------------------------------------------------------------------------------------------------------------------
  # Required input variables
  # --------------------------------------------------------------------------------------------------------------------
  bucket_name       = "${include.env.locals.project_name}-${include.env.locals.env}-cd-artifact"
  iam-instance-role = dependency.iam.outputs.iam_instance_role
}
