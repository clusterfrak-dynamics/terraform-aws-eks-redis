// ElastiCache Replication Group for Redis 

variable "redis_cluster" {
  description = "Count of nodes in cluster"
}

variable "redis_node_type" {
  description = "The type of node to create in the node group"
}

variable "redis_failover" {
  description = "Automatic failover (Not available for T1/T2 instances)"
  default     = false
}

variable "redis_version" {
  description = "The version number of the cache engine to be used for the cache clusters in this replication group"
}

variable "redis_at_rest_encryption_enabled" {
  description = "(Optional) Whether to enable encryption at rest"
  default     = true
}

variable "redis_transit_encryption_enabled" {
  description = "(Optional) Whether to enable encryption in transit"
  default     = true
}

variable "tags" {
  description = "Tags for redis nodes"
  default     = {}
}

// ElastiCache Network for Redis

variable "vpc_id" {
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}

variable "redis_port" {
  description = "Redis port"
  default     = 6379
}

variable "name" {
  description = "Name for the Redis replication group i.e. UserObject"
}

variable "owner" {
  description = "Instance where is attached the Service previously mentionned"
}

variable "env" {
  description = "Kind of environment we are going to launch the Service"
}

variable "app" {
  description = "Name of the application"
}

variable "subnets" {
  description = "List of VPC Subnet IDs for the cache subnet group"
  type        = "list"
}

variable "redis_security_group" {
  description = "Security Groups from EKS Worker Node"
}


// Miscallenious settings

variable "redis_apply_immediately" {
  description = "Apply changes immediately"
}

variable "redis_maintenance_window" {
  description = "Maintenance window"
}
