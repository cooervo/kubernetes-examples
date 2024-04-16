# ClusterPolicies in this example:
    - pods image need a tag & no "latest" mutable tag allowed, only inmutable/deterministic tag such as 1.1.0
    - only allow images from specific registry
    - no service should be NodePort only allowed for IngressGateway

# install notes

helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm pull --repo https://kyverno.github.io/kyverno/ kyverno  --untar 
helm install kyverno charts/kyverno -n kyverno --create-namespace -f chart-values/kyverno.values.yaml

helm pull --repo https://kyverno.github.io/kyverno/ kyverno/kyverno-policies 
helm install kyverno-policies charts/kyverno-policies -n kyverno --create-namespace
