# installing argo cd via helm

1. helm repo add argo https://argoproj.github.io/argo-helm
2. helm pull argo/argo-cd --untar 
3. cd 7-argocd-app-of-apps/helm
4. helm install argocd argo-cd/ \
    -f chart-values/argo-cd.values.yaml \
    -n argocd --create-namespace
5. kubectl port-forward svc/argocd-server -n argocd 8080:443
6. visit http://localhost:8080 and login with the default username & password
    username: `admin`
    get password from command: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
7. cd 7-argocd-app-of-apps/
8. kubectl apply -f applications.yaml # install the app of apps:
7. visit https://localhost:8080/applications/argocd/my-app-of-apps

