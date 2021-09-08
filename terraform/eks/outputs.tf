# EKS cluster module
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "vpc_id" {
  description = "ID of the deployed VPC"
  value       = module.vpc.vpc_id
}

