variable "environment" {
  type = string
}

variable "parameter_store_env_names" {
  description = "List of names of environment config stored in ssm parameter store."
  type = list(string)
}

variable "ecs_task_execution_role_name" {
  description = "ECS Task Execution Role Name"
  type        = string
}