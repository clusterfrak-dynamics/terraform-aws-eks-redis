variable "aws" {
  type    = any
  default = {}
}

variable "eks" {
  type    = any
  default = {}
}

variable "env" {
}

variable "redis_id" {
  default = "redis"
}

variable "redis_engine" {
  default = "redis"
}

variable "redis_engine_version" {
  default = "5.0.5"
}

variable "redis_automatic_failover_enabled" {
  default = false
}

variable "redis_node_type" {
  default = "cache.t2.medium"
}

variable "redis_number_cache_clusters" {
  default = 1
}

variable "redis_parameter_group_name" {
  default = "default.redis5.0"
}

variable "redis_port" {
  default = 6379
}

variable "redis_security_group_ids" {
  type = list
  default = []
}

variable "redis_at_rest_encryption_enabled" {
  default = true
}

variable "redis_transit_encryption_enabled" {
  default = true
}

variable "redis_snapshot_window" {
  default = "02:00-04:00"
}

variable "redis_maintenance_window" {
  default = "sun:00:00-sun:02:00"
}

variable "redis_snapshot_retention_limit" {
  default = null
}

variable "redis_apply_immediately" {
  default = false
}

variable "tags" {
  type    = any
  default = {}
}

variable "redis_cluster_mode" {
  type                      = any
  default                   = {
    enabled                 = false
  }
}

variable "redis_azs" {
  default = null
  type    = list
}

variable "inject_secret_into_ns" {
  default = []
  type    = list
}

variable "redis_exporter" {
  type    = any
}

variable "redis_token_enabled" {
  default = false
}

variable "redis_subnets" {
  type = list
  default = []
}
