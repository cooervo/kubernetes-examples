* Build (dry run) per env

```sh
# for dev
kustomize build overlays/dev

# for prod
kustomize build overlays/dev
```

* Deploy per env

```sh
# for dev
kustomize build overlays/dev | kubectl apply -f -

# for prod
kustomize build overlays/prod | kubectl apply -f -
```