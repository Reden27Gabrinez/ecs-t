locals {
  tags = {
    Terraform   = true
    Environment = var.environment
  }
  create_db_subnets = length(var.database_subnets) > 0
  endpoint_svc      = var.enable_ssm ? ["com.amazonaws.ap-southeast-1.ssm", "com.amazonaws.ap-southeast-1.ec2messages", "com.amazonaws.ap-southeast-1.ssmmessages"] : []
}