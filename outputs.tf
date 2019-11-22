output "redis_primary_endpoint_address" {
  value = var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].primary_endpoint_address : aws_elasticache_replication_group.redis[0].primary_endpoint_address
}

output "redis_configuration_endpoint_address" {
  value = var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].configuration_endpoint_address : aws_elasticache_replication_group.redis[0].configuration_endpoint_address
}

output "redis_member_clusters" {
  value = join(",", var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].member_clusters : aws_elasticache_replication_group.redis[0].member_clusters)
}

output "redis_port" {
  value = var.redis_port
}

output "redis_token" {
  value     = var.redis_token_enabled ? random_uuid.redis_token[0].result : null
  sensitive = true
}
