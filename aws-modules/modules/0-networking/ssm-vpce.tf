## ENABLE SESSION MANAGER ON PRIVATE NETWORK
resource "aws_vpc_endpoint" "session_manager" {
  count               = length(local.endpoint_svc)
  vpc_id              = aws_vpc.vpc.id
  service_name        = local.endpoint_svc[count.index]
  subnet_ids          = [aws_subnet.private[0].id]
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  tags = merge({ Name = "${local.endpoint_svc[count.index]}-endpoint" },
    local.tags,
    var.tags
  )
}
