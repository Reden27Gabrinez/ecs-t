locals {
  region = "ap-southeast-1"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket = "test-eks-cluster"
    key    = "test-red/${path_relative_to_include()}/terraform.tfstate"
    region = local.region
    #    encrypt        = true
    #    dynamodb_table = "my-lock-table"
  }
}