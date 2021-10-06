# Jenkins Install

- Namespaces

```bash
kubectl create namespace jenkins
```

- Deploy an ingress controller
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.2/deploy/static/provider/aws/deploy.yaml
```

- Deploy Jenkins

```bash
# The server
kubectl -n jenkins apply -f jenkinsServer.yaml
# The services
kubectl -n jenkins apply -f jenkinsService.yaml
# The ingress
kubectl -n jenkins apply -f jenkinsIngress.yaml
```

> For the ingress to worked I set a CNAME pointing to the LB the ingress created

- Go to the URL. In my case its `http://jenkins.ktw.org.uk/`

- To get the unlock command you can run:

```
kubectl -n jenkins exec POD_NAME -- bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"
```


# Jenkins Setup

- After I have unlocked it, I choose to install the recommended plugins