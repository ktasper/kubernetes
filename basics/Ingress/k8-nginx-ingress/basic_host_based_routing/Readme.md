# Ingress Controller

- Check to see if there are any ingress controllers already installed
```bash
kubectl get ingress --all-namespaces
# Or
kubectl get services --all-namespaces | grep -i ingress
```

- As I am on EKS I want to use the correct manifest [here](https://kubernetes.github.io/ingress-nginx/deploy/#aws)
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.2/deploy/static/provider/aws/deploy.yaml
```

- Once deployed run this to get the DNS name of the LB:

```bash
kubectl -n ingress-nginx get services
```

> You want to ensure that your domain has that LB set as an alias. Example: CNAME --> helloworld.ktw.org.uk --> ad32505fbc5694dd1bec4ec8e78a8a45.....aws...nlb...
# Pods

- I have created a simple ngix demo manifest under `./pod.yaml`:

```bash
# Create the namespace
kubectl create namespace hello-world
# Apply our pod manifest
kubectl -n hello-world apply -f pod.yaml
# Check they are running
kubectl get pods -n hello-world 
```

- Before we even try to setup a service or a ingress rule we can port forward to see if its working as expected:

```bash
kubectl -n hello-world port-forward  pod/<pod-id> 8080:80
```

- Now visit http://localhost:8080 and you should see an nginx welcome page


# Service

- Now that we have deployed our pod we can create an internal service so kubernetes knows we want to route some form of traffic to the pod.

```bash
kubectl -n hello-world apply -f pod_service.yaml
```

# Ingress

- Now that the service is ready we can point an ingress rule to the service and allow traffic.

```bash
kubectl -n hello-world apply -f pod_ingress.yaml
```

> The only thing you want to ensure is that your DNS Provider is set up and pointing to the ingress otherwise it will not work



## Clean Up

- If you are like me and using terraform to deploy / destroy: Make sure you delete the ingress before running terraform delete.

```bash
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.2/deploy/static/provider/aws/deploy.yaml
```