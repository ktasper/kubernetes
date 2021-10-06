# kubernetes
A place for all my manifests / random kubernetes stuff


# Docker File

## Windows
On Windows thius is what I use to start my container:

```powershell
docker build . -t k8_worker
```

```powershell
docker run -it -v $HOME/.aws/:/root/.aws -w /app myimage bash
```


# Deploy Terraform

Dont forget to set a `terraform.tfvars` to overwrite the `variables.tf` file

```
cd terraform/eks
terraform apply --auto-approve
```

# Destroy Terraform
```
cd terraform/eks
terraform destroy --auto-approve
```

# Get K(C)ontext

```bash
# Get the cluster name
aws --region <region-code> eks list-clusters
# Set the context
aws --region <region-code> eks update-kubeconfig --name <cluster_name>
```