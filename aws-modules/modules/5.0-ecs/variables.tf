variable "demo_app_cluster_name" {
  description = "ECS Cluster Name"
  type        = string
}

variable "demo_app_task_family" {
  description = "ECS Task Family"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  type        = number
}

variable "demo_app_task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "demo_app_service_name" {
  description = "ECS Service Name"
  type        = string
}
