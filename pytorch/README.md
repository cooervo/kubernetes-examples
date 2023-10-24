## Steps

0. Networking
    a. connect via authorized networks only
    b. firewalls
- [x] Install micromamba
    - [X] brew install micromamba
    - [x] micromamba shell init -s {your-shell} -p ~/micromamba
- [x] Run python + flask server locally with:
        
       cd api/
       micromamba env create --file environment.yml

       flask --app {file-name} run` as in `flask --app app run

- [x] Build image with Dockerfile and run it locally
    - [x] build image with  `docker build -t {name} .`
    - [x] run image with `docker run -it -p 5001:5001 -d {name}`
    - [x] go to http://localhost:5001/ (currently won't work with https) you should see app running

- [x] Create GCP storage bucket for terraform state backend and use it's name at main.tf

- [ ] Artifact Repository
    - [x] provision via terraform
    - [x] docker build (amd64 compatible) docker image to Artifact Repository so it works in linux hosts, example:

          docker buildx build \
            --platform linux/amd64 \
            -t {REGION}-docker.pkg.dev/{PROJECT_ID}/{ARTIFACT_REPOSITORY_ID}/{NAME}:{VERSION} .
    - [x] push (amd64 compatible) docker image to Artifact Repository:

            docker push {NAME}:{VERSION}


- [ ] GKE
    - [ ] provision cluster via terraform (docu: https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
    - [ ] deploy flask in cluster (via helm?)

- [ ] Compute engine disk for persistency
    - [ ] provision via k8s with StorageClass
    - [ ] mount disk to GKE cluster

- [ ] **ArgoCD** for Cluster Deployment

- [ ] Redis (for cache or auth if needed)
    - [ ] provision via terraform
    - [ ] deploy via helm?
    - [ ] CRUD in python

- [ ] Train a model in pytorch simple Q/A of fictional character 

## Done: 

