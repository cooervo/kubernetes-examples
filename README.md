# Steps

## Node in GKE
1. Create a GKE cluster via terraform
2. run nodejs server locally and check it works
3. build docker image, tag it and push to Google Artifact Registry (https://cloud.google.com/artifact-registry/docs/docker/pushing-and-pulling)
4. deploy it in GKE cluster
5. check it works

## Step by step

* manually create the Container Registry at GCP (TODO in CI)
* cd k8s-llm/node-kube/app
* Build and tag
* docker build -t us-east1-docker.pkg.dev/winter-field-401115/dev-artifact-repository-docker/dev-node-image:v1.2 .

* docker push us-east1-docker.pkg.dev/winter-field-401115/dev-artifact-repository-docker/dev-node-image:v1.2


## Python in GKE
1. run server locally
2. check it works
3. repeat steps 3-5 as above but for python

## LLM in GKE
1. run server locally
2. check it works
3. repeat steps 3-5 as above but for LLM

Extras
- create Artifact Repository via terraform
- connect to a database
- connect via authorized networks only
- how to manage secrets?
- ArgoCD



