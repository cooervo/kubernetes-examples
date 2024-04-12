### 1) Install Prometheus

```sh    
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
```    

#### Access Prometheus in browser

```sh
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9090
```

source: https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus#install-chart

### 2) Install Grafana

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

source: https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/


#### Access Grafana in browser

```sh

# Get the password (admin is username)
kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-grafana" -o jsonpath="{.items[0].metadata.name}") 
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

create the example ns and run the example app

```sh
kubectl create ns example
kubectl apply -f example-app/
```