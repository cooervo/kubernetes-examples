* Buiild per env

```sh
# for dev
kustomize build overlays/dev

# for prod
kustomize build overlays/dev
```

* Deploy per env

```sh
# for dev
kusomtize build overlays/dev | kubectl apply -f -

# for prod
kusomtize build overlays/prod | kubectl apply -f -
```