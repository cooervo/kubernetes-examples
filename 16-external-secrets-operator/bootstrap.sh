# throw error code if some command fails
set -e
# Exit on uninitialized variable
set -u
# Exit on error within any functions or subshells.
set -o pipefail

export GCP_PROJECT_ID="sandbox-38591" 
export ZONE="us-central1-a"
export REGION="us-central1"
export ESO_GCP_SERVICE_ACCOUNT="sa-external-secrets"
export ESO_K8S_SERVICE_ACCOUNT="external-secrets"
export ESO_K8S_NAMESPACE="external-secrets"

echo "
========================= 
Create Cluster 
========================="

gcloud container clusters create-auto "autopilot-cluster" \
  --region $REGION \
  --project $GCP_PROJECT_ID

echo "
========================= 
Bind the Service Accounts 
========================="

#Create GCP service account
gcloud iam service-accounts create $ESO_GCP_SERVICE_ACCOUNT \
--project=$GCP_PROJECT_ID

#Create IAM role bindings
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
--member "serviceAccount:$ESO_GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
--role "roles/secretmanager.secretAccessor"

#Allow kubernetes service account to impersonate GCP service account
gcloud iam service-accounts add-iam-policy-binding $ESO_GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$GCP_PROJECT_ID.svc.id.goog[$ESO_K8S_NAMESPACE/$ESO_K8S_SERVICE_ACCOUNT]"

echo "
================================================== 
Installing External Secrets Operator helm chars 
=================================================="

helm repo add external-secrets https://charts.external-secrets.io

helm pull --repo https://charts.external-secrets.io external-secrets --untar

helm install external-secrets \
   helm/charts/external-secrets/external-secrets \
    -n external-secrets \
    --create-namespace \

# add annotation to the k8s service account
kubectl annotate sa $ESO_K8S_SERVICE_ACCOUNT \
    iam.gke.io/gcp-service-account=$ESO_GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com \
    -n $ESO_K8S_NAMESPACE

# enable secret manager w/ gcloud
gcloud services enable secretmanager.googleapis.com

# Set up a sample secret in GCP secret manager
printf "MY-SECRET-FOOBAR" | gcloud secrets create eso-demo --data-file=- --project=$GCP_PROJECT_ID

# Apply the ESO resources
kubectl apply -f cluster-secret-store.yaml

kubectl apply -f external-secret.yaml
kubectl get secrets eso-demo-credential -o yaml

# get data.name from output and decrypt it
kubectl get secrets eso-demo-credential -o jsonpath='{.data.name}' | base64 --decode

# Expected output:
# MY-SECRET-FOOBAR


