output "vpc_id" {
  description = "name of vpc"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "list of public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnets" {
  description = "list of private subnets"
  value       = aws_subnet.private.*.id
}

output "nat_gw_id" {
  description = "NAT gateway id"
  value       = var.enable_nat ? aws_nat_gateway.nat[0].id : "None"
}
