#
# Provider Configuration
#
terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.aws["region"]
}

provider "helm" {
  install_tiller                  = true
  service_account                 = "tiller"
  tiller_image                    = "gcr.io/kubernetes-helm/tiller:v2.15.2"
  automount_service_account_token = true

  kubernetes {
    config_path = var.eks["kubeconfig_path"]
  }
}


data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {
}
