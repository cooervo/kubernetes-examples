# Install External Secrets Operator

```sh
helm repo add external-secrets https://charts.external-secrets.io

helm pull --repo https://charts.external-secrets.io external-secrets --untar

helm install external-secrets \
   external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace
```

source: https://external-secrets.io/latest/introduction/getting-started/ 

