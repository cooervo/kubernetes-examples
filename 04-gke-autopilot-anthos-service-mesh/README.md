## Steps

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


## Deployment notes:

1.  first provision infra with terraform this includes provisioning GKE cluster just run

        cd terraform/
        terraform init
        terraform apply // IMPORTANT: might need to comment out anthos mesh service code block since it needs gke cluster to be up and running, somehow depends_on doesn't work

2. Build and push docker image(s) 

        cd api/
        docker buildx build \
          --platform linux/amd64 \
          -t {REGION}-docker.pkg.dev/{PROJECT_ID}/{ARTIFACT_REPOSITORY_ID}/{NAME}:{VERSION} .

  - If pushing to GCP Artifact Registry:
  
        gcloud auth login # Log into gcloud:
        gcloud auth configure-docker {GCP_REGION}-docker.pkg.dev # Configure docker to authorize you to push to your GCP_REGION

  - Push to GCP Artifact Registry or docker hub:
        docker push {NAME}:{VERSION}

3. Run istioctl analyze to check if anything is missing (might need to install istioctl)

        `istioctl analyze`

        # Example output:

        The namespace is not enabled for Istio injection. Run 'kubectl label namespace {NAMESPACE} istio-injection=enabled' to enable it, or 'kubectl label namespace {NAMESPACE} istio-injection=disabled' to explicitly mark it as not needing injection.

        if `istioctl analyze` returns no errors (example: `✔ No validation issues found when analyzing namespace: default`) then proceed to next step.

3.  Run k8s deployments and services:

        # connect to the gcp cluster using project id and region (this is in Gke cluster console)
        gcloud container clusters get-credentials {CLUSTER_NAME} --region {region} --project {PROJECT_ID}
        
        # at dir `4-gke-anthos-service-mesh` run:
        kubectl apply -f kubernetes/ # or run each file independently with `kubectl apply -f {file-name}`
