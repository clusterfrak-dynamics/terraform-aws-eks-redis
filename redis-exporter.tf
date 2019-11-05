locals {
  values_redis_exporter = <<VALUES
image:
  tag: "${var.redis_exporter["version"]}"
redisAddress: redis://127.0.0.1:6379
env:
  - name: REDIS_PASSWORD
    value: "${var.redis_token_enabled ? random_uuid.redis_token[0].result : ""}"
VALUES
}

resource "helm_release" "redis_exporter" {
  count      = var.redis_exporter["enabled"] ? 1 : 0
  repository = data.helm_repository.stable.metadata[0].name
  name       = "${var.redis_id}-${var.env}"
  chart      = "prometheus-redis-exporter"
  version    = var.redis_exporter["chart_version"]
  values     = concat([local.values_redis_exporter], [var.redis_exporter["extra_values"]])
  namespace  = var.redis_exporter["namespace"]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=kubeconfig -n monitoring apply -f files/servicemonitor.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=kubeconfig -n monitoring patch deployments ${var.redis_id}-${var.env}-prometheus-redis-exporter --patch '${templatefile("templates/patch.tpl", { configmap_name = "${var.redis_id}-${var.env}-stunnel-config" })}'"
  }
}

resource "kubernetes_config_map" "stunnel" {
  count      = var.redis_exporter["enabled"] ? 1 : 0
  metadata {
    name      = "${var.redis_id}-${var.env}-stunnel-config"
    namespace = "monitoring"
  }

  data             = {
    "stunnel.conf" = "${templatefile("templates/stunnel.tpl", { redis_host = var.redis_cluster_mode["enabled"] ? aws_elasticache_replication_group.redis_cluster[0].configuration_endpoint_address : aws_elasticache_replication_group.redis[0].primary_endpoint_address, redis_port =var.redis_port})}"
  }
}
