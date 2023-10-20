## Todo steps

0. Networking
    a. connect via authorized networks only
    b. firewalls
1. run python + flask server locally with:
    
       flask --app {file-name} run` as in `flask --app app run

3. build image with Dockefile
    a. build image with  `docker build -t {name} .`
    b. run image with `docker run -it -p 5001:5001 -d {name}`
    c. go to http://localhost:5001/ (currently won't work with https)
4. Artifact Repository
    a. provision via terraform
    b. push docker image to Artifact Repository
5. GKE
    a. provision cluster via terraform
    b. deploy app via helm?
6. Compute engine disk for persistency
    a. provision via terraform
    b. mount disk to GKE cluster
7. Redis (for cache or auth if needed)
    a. provision via terraform
    b. deploy via helm?
    c. CRUD in python
8. ArgoCD for Cluster Deployment
9. Train a model in pytorch simple Q/A of fictional character 

## Done: 

