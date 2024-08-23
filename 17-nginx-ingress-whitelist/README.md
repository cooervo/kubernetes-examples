Add an `A` record pointing to the nginx-ingress IP for the subdomain example `status.cooervo.com`

```shell
cd 17-nginx-ingress-whitelist/
cd charts/

# Install the nginx-ingress repo, pull and untar it in the charts/ dir
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm pull ingress-nginx/ingress-nginx --untar
helm install  ingress-nginx -n ingress-nginx charts/ingress-nginx -f values/ingress-nginx/values.yaml --create-namespace

# Install sample app
kubectl apply -f status-app/

# install the ingress for it with whitelisted IPs
kubectl apply -f status-ingress.yaml
```