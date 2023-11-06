## Steps

0. Networking
   a. connect via authorized networks only
   b. firewalls

- [x] Install micromamba
  - [x] brew install micromamba
  - [x] micromamba shell init -s {your-shell} -p ~/micromamba
- [x] Run python + flask server locally with:

       cd api/
       micromamba env create --file environment.yml
       micromamba activate {env-name}
       flask --app {file-name} run` as in `flask --app app run

- [x] Build image with Dockerfile and run it locally

  - [x] build image with `docker build -t {name} .`
  - [x] run image with `docker run -it -p 5001:5001 -d {name}`
  - [x] go to http://localhost:5001/ (currently won't work with https) you should see app running

- [x] Create GCP storage bucket for terraform state backend and use it's name at main.tf

- [x] Artifact Repository

  - [x] provision via terraform
  - [x] docker build (amd64 compatible) docker image to Artifact Repository so it works in linux hosts, example:

        docker buildx build \
          --platform linux/amd64 \
          -t {REGION}-docker.pkg.dev/{PROJECT_ID}/{ARTIFACT_REPOSITORY_ID}/{NAME}:{VERSION} .

  - [x] push (amd64 compatible) docker image to Artifact Repository:

          docker push {NAME}:{VERSION}

- [x] GKE

  - [x] provision cluster via terraform (docu: https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
  - [x] deploy flask in cluster
  - [ ] Helm how does it fit?

- [x] Big Query

  - [x] provision via terraform
  - [x] add a sample data set, user table and insert sample user
  - [x] Add connection to BigQuery from flask/python locally

- [x] Add **Workload identity** to allow k8s pods running flask to connect to BigQuery (tutorial:https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to )

- [ ] Install Pytorch and use a model

  - [ ] test sentiment analysis model works locally
  - [ ] test sentiment analysis model works in k8s cluster

- [ ] Add another type of Pods

  - [ ] allow access from python pods to new pods 
  - [ ] disallow public access to new pods

- [ ] **ArgoCD** for Cluster Deployment ?

- [ ] **Cloud Build** for CI/CD ?

- [ ] Add Promtheus https://cloud.google.com/stackdriver/docs/solutions/gke

- [ ] Redis (for cache or auth if needed)

  - [ ] provision via terraform
  - [ ] deploy via helm?
  - [ ] CRUD in python

- [ ] Train a model in pytorch simple Q/A of fictional character
- [ ] Use vars in k8s config files instead of hardcoded values such as project id


## Deployment notes:

1.  first provision infra with terraform this includes provisioning GKE cluster just run

        cd terraform/
        terraform init
        terraform apply

2. Build and push docker image(s) 

        cd api/
        docker buildx build \
          --platform linux/amd64 \
          -t {REGION}-docker.pkg.dev/{PROJECT_ID}/{ARTIFACT_REPOSITORY_ID}/{NAME}:{VERSION} .
        docker push {NAME}:{VERSION}

3.  Run k8s service account, cluster and service

        cd kubernetes/

        # connect to the gcp cluster using project id and region
        gcloud container clusters get-credentials {CLUSTER_NAME} --region {region} --project {PROJECT_ID}
        
        # or as alternative use a zone
        # gcloud container clusters get-credentials {CLUSTER_NAME} --zone {zone} --project {PROJECT_ID}

        kubectl apply -f k8s-service-account.yaml
        kubectl apply -f service.yaml

4.  Bind **workload identity** to allow pods in k8s cluster to connect to BigQuery (source: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to)

    bind to project level
       
    ```
        gcloud projects add-iam-policy-binding {PROJECT_ID} \
    --member "serviceAccount:{IAM_SERVICE_ACCOUNT}@{PROJECT_ID}.iam.gserviceaccount.com" \
    --role "roles/iam.workloadIdentityUser"
    ```

    then bind the iam service account

    ```
    gcloud iam service-accounts add-iam-policy-binding {IAM_SERVICE_ACCOUNT}@{PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:{PROJECT_ID}.svc.id.goog[{KUBERNETES_NAMESPACE}/{K8S_SERVICE_ACCOUNT}]"
    ```

5. Now we can create the deployment:

        kubectl create -f deployment.yaml
