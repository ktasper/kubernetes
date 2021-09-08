# This is the default variables file, don't change this, update any custom variable definition into terraform.tfvars

### main.tf ###
variable "region" {
  default     = "eu-west-1"
  description = "AWS Region"
}

variable "profile" {
  default     = null
  description = "If provided, terraform will deploy using aws cli defined profile"
}

# Deployment ID
variable "name" {
  default = "devops"
}


# Additional tags to be added to the "deployment" tag
variable "deployment_tags" {
  default     = "tf"
  description = "Internal variable"
}

variable "createdby" {
  default     = null
  description = "Internal variable, if == `null` it is set to the AWS caller identity as resolved locally by aws sts"
}


### vpc.tf ###

variable "cidr_block" {
  default     = "10.10.10.0/24"
  description = "CIDR for the VPC"
}


### infra_eks.tf ###

variable "kubernetes_version" {
  type        = string
  default     = "1.20"
  description = "The default kubernetes version you want on EKS"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_log_retention_period" {
  type        = number
  default     = 1
  description = "Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html."
}

### infra_eks_nodes.tf ###

variable "instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "The instance type you want to use for the eks worker nodes"
}

variable "desired_size" {
  type        = string
  default     = 1
  description = "The desired size of the worker nodes on EKS"
}

variable "min_size" {
  type        = string
  default     = 1
  description = "The minimum size of the worker nodes on EKS"
}

variable "max_size" {
  type        = string
  description = "The max size of the worker nodes on EKS"
  default     = 8
}

variable "ec2_ssh_key" {
  description = "The ssh key you want to use if you need to ssh to the worker nodes"
  type        = string
  default     = "mykey"
}

variable "source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Set of EC2 Security Group IDs to allow SSH access (port 22) to the worker nodes. If you specify `ec2_ssh_key`, but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
}

variable "disk_size" {
  type        = number
  default     = 30
  description = "The number of GB you want the worker nodes to have"
}
