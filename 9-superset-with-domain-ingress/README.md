# Networking flow:

**`Istio ingress-gateway` -> `istio-gateway` -> `virtual service(s)` -> `destination rule(s)` -> `service` -> `deployment`**

### Instalation steps

1. run terraform at `terraform/` folder
2. install istio from script `/istio/install-istio-in-cluster.sh`
3. install resource in `kubernetes/` folder. `kubectl apply -f kubernetes/`
4. in GKE check service copy the external IP of the `istio-ingressgateway` service installed in past with command (`helm install ingressgateway istio/charts/gateway -n istio-ingress`)
5. go to your domain name manager
6. set `A` record for `app.testmosaic.com` pointing to the external IP of the `ingressgateway`
7. set `A` record for `test.testmosaic.com` pointing to the external IP of the `ingressgateway`
8. open browser and go to `app.testmosaic.com` and `test.testmosaic.com` app should work
