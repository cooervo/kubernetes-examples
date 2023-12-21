# ===================================================================================================
#                              Install istio base, istiod, and istio gateway
# ===================================================================================================

# Source: https://istio.io/latest/docs/setup/install/helm/
# istioctl analyze can be used to debug

# to pull charts locally
# helm pull istio/base --version 1.20 --untar
# helm pull istio/istiod --version 1.20 --untar
# helm pull istio/gatewat --version 1.20 --untar

echo -e "1) Create the namespace, istio-system, for the Istio components \n"
kubectl create namespace istio-system
# kubectl create namespace istio-system

echo -e "2) Install istio/base chart which contains Custom Resource Definitions (CRDs), i.e.: VirtualService, used by the Istio control plane \n"
helm install istio-base charts/base -n istio-system --set defaultRevision=default
#helm install istio-base istio/base -n istio-system --set defaultRevision=defau

echo -e "3) Install istiod which adds istio's control plane functionality \n"
helm install istiod charts/istiod -n istio-system --wait
#helm install istiod istio/istiod -n istio-system --wait


echo -e "4) Install istio/gateway which allows us to use istio's ingress gateway to handle external traffic entering the Istio service mesh \n"
kubectl create namespace istio-ingress
helm install ingressgateway charts/gateway -n istio-ingress

echo -e "5) Install the gateway  \n"
kubectl apply -f path/to/my/gateway.yml

# install deploy/party/party-virtual-service.yml at mosaic-lazer repo

echo -e "6) Enable Istio auto injection for namespace default \n"
kubectl label namespace default istio-injection=enabled

# restart nodes so istio label can be injected:
# kubectl -n default rollout restart deploy 

# Get the node port for the istio ingress gateway:
#         kubectl get svc {SERVICE_NAME} -n {NAMESPACE} -o jsonpath='{.spec.ports[?(@.name=="{PORT_NAME_TO_MATCH}")].nodePort

#         kubectl get svc ingressgateway -n istio-ingress -o jsonpath='{.spec.ports[?(@.name=="http-web")].nodePort}'

# create firewall rule using the port of the ingressgateway
#  gcloud compute firewall-rules create test-allow-gateway-http --allow tcp:30673 --network=party-vpc

# Get list of nodes and their external IP address:
    #   kubectl get nodes -o wide

# test with curl
#curl -v -H "Host: {HOST_NAME}" \  
#      http://{NODE_EXTERNAL_IP}:{INGRESS_GATEWAY_NODE_PORT}