Networking flow:

Istio ingress-gateway (installed via chart in terraform) -> istio-gateway -> virtual service -> destination rule -> service -> pod



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