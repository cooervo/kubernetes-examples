# installing argo cd via helm

1. helm repo add argo https://argoproj.github.io/argo-helm
2. helm pull argo/argo-cd --untar 
3. cd 008-argocd-app-of-apps/helm
4. update  following file in argocd.values.yaml with desired namespaces:
  `config.params.application.namespaces: "default, cert-manager"`
5. helm install argocd argo-cd/ \
    -f chart-values/argo-cd.values.yaml \
    -n argocd --create-namespace
6. kubectl port-forward svc/argocd-server -n argocd 8080:443
7. visit http://localhost:8080 and login with the default username & password
    username: `admin`
    get password from command: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
8. cd 7-argocd-app-of-apps/
9. manually install the app of apps:
    8.1. Go to argocd UI >  Applications > Create > Copy paste manifest yaml of the app of apps: `7-argocd-app-of-apps/applications.yaml`
    8.2. kubectl apply -f applications.yaml 
10. visit https://localhost:8080/applications/argocd/my-app-of-apps
11. make sure you have pushed latest changes to the git repo
12. ArgoCD should now be updated but you can sync just in case

