helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm pull --repo https://kyverno.github.io/kyverno/ kyverno  --untar 
helm install kyverno charts/kyverno -n kyverno --create-namespace -f chart-values/kyverno.values.yaml

helm pull --repo https://kyverno.github.io/kyverno/ kyverno/kyverno-policies 
helm install kyverno-policies charts/kyverno-policies -n kyverno --create-namespace

