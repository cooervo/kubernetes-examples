Add an `A` record pointing to the nginx-ingress IP for the subdomain example `status.cooervo.com`

```sh

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm pull ingress-nginx/ingress-nginx --untar
helm install  ingress-nginx -n ingress-nginx charts/ingress-nginx -f values/ingress-nginx/values.yaml --create-namespace

```