resource "random_uuid" "redis_token" {
  count = var.redis_token_enabled ? 1 : 0
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "tf-redis-${var.redis_id}-${var.env}"
  subnet_ids = var.redis_subnets
}

resource "aws_elasticache_replication_group" "redis" {
  count                         = var.redis_cluster_mode["enabled"] ? 0 : 1
  automatic_failover_enabled    = var.redis_automatic_failover_enabled
  availability_zones            = var.redis_azs
  replication_group_id          = "${var.redis_id}-${var.env}"
  replication_group_description = "${var.redis_id}-${var.env}"
  node_type                     = var.redis_node_type
  number_cache_clusters         = var.redis_number_cache_clusters
  parameter_group_name          = var.redis_parameter_group_name
  port                          = var.redis_port
  engine                        = var.redis_engine
  engine_version                = var.redis_engine_version
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = var.redis_security_group_ids
  at_rest_encryption_enabled    = var.redis_at_rest_encryption_enabled
  transit_encryption_enabled    = var.redis_transit_encryption_enabled
  auth_token                    = var.redis_token_enabled ? random_uuid.redis_token[0].result : null
  snapshot_window               = var.redis_snapshot_window
  maintenance_window            = var.redis_maintenance_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  apply_immediately             = var.redis_apply_immediately
  tags                          = var.tags
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  count                         = var.redis_cluster_mode["enabled"] ? 1 : 0
  automatic_failover_enabled    = true
  availability_zones            = var.redis_azs
  replication_group_id          = "${var.redis_id}-${var.env}"
  replication_group_description = "${var.redis_id}-${var.env}"
  node_type                     = var.redis_node_type
  parameter_group_name          = var.redis_parameter_group_name
  port                          = var.redis_port
  engine                        = var.redis_engine
  engine_version                = var.redis_engine_version
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = var.redis_security_group_ids
  at_rest_encryption_enabled    = var.redis_at_rest_encryption_enabled
  transit_encryption_enabled    = var.redis_transit_encryption_enabled
  auth_token                    = var.redis_token_enabled ? random_uuid.redis_token[0].result : null
  snapshot_window               = var.redis_snapshot_window
  maintenance_window            = var.redis_maintenance_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  apply_immediately             = var.redis_apply_immediately
  tags                          = var.tags

  cluster_mode {
    replicas_per_node_group = var.redis_cluster_mode["replicas_per_node_group"]
    num_node_groups         = var.redis_cluster_mode["num_node_groups"]
  }
}

resource "kubernetes_secret" "redis_secrets" {
  count = length(var.inject_secret_into_ns)

  metadata {
    name      = "redis-${var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].id : aws_elasticache_replication_group.redis[0].id}"
    namespace = var.inject_secret_into_ns[count.index]
  }

  data                                   =  {
    REDIS_PRIMARY_ENDPOINT_ADDRESS       = var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].primary_endpoint_address : aws_elasticache_replication_group.redis[0].primary_endpoint_address
    REDIS_CONFIGURATION_ENDPOINT_ADDRESS = var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].configuration_endpoint_address : aws_elasticache_replication_group.redis[0].configuration_endpoint_address
    REDIS_MEMBER_CLUSTERS                = join(",",var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].member_clusters : aws_elasticache_replication_group.redis[0].member_clusters)
    REDIS_PORT                           = var.redis_port
    REDIS_AUTH                           = var.redis_token_enabled ? random_uuid.redis_token[0].result : null
  }
}
