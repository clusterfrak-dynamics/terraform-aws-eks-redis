# Attached Subnets Resource on the ElastiCache Redis cluster
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "tf-redis-${var.name}-${var.env}-${var.vpc_id}"
  subnet_ids = var.subnets
}

# Create the HA Redis Cluster
resource "aws_elasticache_replication_group" "redis" {
  apply_immediately             = var.redis_apply_immediately
  at_rest_encryption_enabled    = var.redis_at_rest_encryption_enabled
  automatic_failover_enabled    = var.redis_failover
  engine_version                = var.redis_version
  maintenance_window            = var.redis_maintenance_window
  node_type                     = var.redis_node_type
  number_cache_clusters         = var.redis_cluster
  port                          = var.redis_port
  replication_group_id          = format("%.20s", "${var.name}-${var.env}")
  replication_group_description = "Terraform-managed ElastiCache replication group for ${var.name}-${var.env}-${var.vpc_id}"
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = [var.redis_security_group]
  transit_encryption_enabled    = var.redis_transit_encryption_enabled
}

