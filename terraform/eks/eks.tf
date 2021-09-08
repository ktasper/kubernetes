#################################### EKS Cluster

module "cluster_label" {
  # This label is here to be referenced from subnet tags module while avoiding cycle ref (subnet > cluster > subnet)
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  attributes = ["cluster"]
  context    = module.label.context
}

module "eks_cluster" {
  source                                    = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=tags/0.39.0"
  enabled                                   = true
  region                                    = var.region
  kubernetes_version                        = var.kubernetes_version
  enabled_cluster_log_types                 = var.enabled_cluster_log_types
  cluster_log_retention_period              = var.cluster_log_retention_period
  kubernetes_config_map_ignore_role_changes = true
  oidc_provider_enabled                     = true
  cluster_encryption_config_enabled         = true
  wait_for_cluster_command                  = "curl --silent --fail --retry 60 --retry-delay 5 --insecure --output /dev/null $ENDPOINT/healthz"
  vpc_id                                    = module.vpc.vpc_id
  subnet_ids                                = module.subnets.private_subnet_ids
  attributes                                = module.cluster_label.attributes
  context                                   = module.cluster_label.context
}



#################################### EKS Nodegroups

locals {
  kubeauth_args = var.profile == null ? ["eks", "get-token", "--cluster-name", module.eks_cluster.eks_cluster_id] : ["eks", "get-token", "--profile", var.profile, "--cluster-name", module.eks_cluster.eks_cluster_id]

  # Do not create Node Group before the EKS cluster is created and the `aws-auth` Kubernetes ConfigMap is applied.
  inputs = {
    cluster_name             = module.eks_cluster.eks_cluster_id
    kubernetes_config_map_id = module.eks_cluster.kubernetes_config_map_id
  }
}

# Nodegroup definition

module "eks_node_group" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-eks-node-group.git?ref=tags/0.20.0"
  cluster_name                            = local.inputs["cluster_name"]
  enabled                                 = true
  capacity_type                           = "ON_DEMAND"
  instance_types                          = var.instance_types
  desired_size                            = var.desired_size
  min_size                                = var.min_size
  max_size                                = var.max_size
  ec2_ssh_key                             = var.ec2_ssh_key
  source_security_group_ids               = var.source_security_group_ids
  kubernetes_version                      = var.kubernetes_version
  disk_size                               = var.disk_size
  launch_template_disk_encryption_enabled = true
  create_before_destroy                   = true
  cluster_autoscaler_enabled              = true
  resources_to_tag                        = ["instance", "volume", "spot-instances-request"]
  subnet_ids                              = module.subnets.private_subnet_ids
  attributes                              = ["ondemand"]
  depends_on                              = [module.subnets]
  context                                 = module.label.context
}


#################################### EKS Authentication for kubernetes

# Set the kubernetes auth for managing the aws_auth cm
provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.eks_cluster.eks_cluster_certificate_authority_data)
  host                   = module.eks_cluster.eks_cluster_endpoint
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = local.kubeauth_args
    command     = "aws"
  }
}
