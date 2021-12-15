# Ingress Controller

- Check to see if there are any ingress controllers already installed
```bash
kubectl get ingress --all-namespaces
# Or
kubectl get services --all-namespaces | grep -i ingress
```

- Install the ingress controller via helm
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

It can take a minute or two for the cloud provider to provide and link a public IP address. When it is complete, you can see the external IP address using the kubectl command:

```
kubectl get svc
```


## DNS

Once the load balancer is deployed you want to ensure that your domain has that LB set as an alias. `Example: A --> kuard.ktw.org.uk --> <DO EXTERNAL IP>`

# Namespace
I also want to set up a namespace for testing my web apps in called certman-demo

```
kubectl create namespace certman-demo
```


# Cert Manager
Now we need to install certmanager from the guide [here](https://cert-manager.io/docs/installation/) This will deploy all the resources we need to run the service

```
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
```

# Dummy Webserver

We are going to deploy `kuard`.

The `kuard_no_tls` deployment is a simple web server that does not have TLS enabled, it uses the `Kubernetes Ingress Controller Fake Certificate`.


```
kubectl apply -f kuard_no_tls.yaml
```

If I vist the website I see the kaurd interface and I see that the certificate is not valid as its the `Kubernetes Ingress Controller Fake Certificate`.


# Configure Let's Encrypt Issuer(s)

- Since we want to do this properly we need to create 2 issuers for cert-manager to use. A `prod` and a `staging` issuer so we can test our certificates before we deploy them to production. We want to do this because you can hit a limit on how many certificates you can create with the production issuer.

```
kubectl apply -f issuers.yaml
```

We want to check the `status` of each issuer once it has been deployed.

```
kubectl describe issuer letsencrypt-staging -n certman-demo
&
kubectl describe issuer letsencrypt-prod -n certman-demo
```

> An Issuer is a namespaced resource, and it is not possible to issue certificates from an Issuer in a different namespace. This means you will need to create an Issuer in each namespace you wish to obtain Certificates in.

If you want to create a single Issuer that can be consumed in multiple namespaces, you should consider creating a ClusterIssuer resource

# Re-deploy Kuard with TLS

- Delete the `kuard_no_tls` deployment

```
kubectl delete -f kuard_no_tls.yaml
```

- Deploy the `kuard` deployment with (TLS enabled)

```
kubectl apply -f kuard.yaml
```


You can check the status of the certificate by running:

```
kubectl describe certificate kuard-tls -n certman-demo
```

## Troubleshooting
https://cert-manager.io/docs/faq/acme/

```
kubectl get certificaterequest -n certman-demo
kubectl describe certificaterequest kuard-tls-hvvkw -n certman-demo

kubectl get order  -n certman-demo
kubectl describe order kuard-tls-hvvkw-998649775 -n certman-demo

kubectl get challenges -n certman-demo
kubectl describe challenges kuard-tls-gpmkw-998649775-49208348 -n certman-demo

```

One of my issues was I was using the issues in the default namespace when they should have been in the certman-demo namespace.

The error is `Waiting for HTTP-01 challenge propagation: failed to perform self check GET request 'http://kuard.ktw.org.uk/.well-known/acme-challenge/wp_vxdUBBGLZQllLX4wi8l9Na179ySqoBPmCP-UgqzQ': Get "http://kuard.ktw.org.uk/.well-known/acme-challenge/wp_vxdUBBGLZQllLX4wi8l9Na179ySqoBPmCP-UgqzQ"`



## Same but with cluster issuers

```
kubectl apply -f .\cluster_issuers.yaml
```

```
kubectl describe issuer letsencrypt-staging
&
kubectl describe issuer letsencrypt-prod
```


```
kubectl apply -f kuard_clusterissuer.yaml
```

