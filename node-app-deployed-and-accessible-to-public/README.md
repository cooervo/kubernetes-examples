A simple example of a node app deployed and accessible to the whole public.

Documentation: https://medium.com/globant/kubernetes-deployment-deploy-nodejs-application-on-the-gke-505e5f60d2de 

- at `app` build the image:
docker build -t {example} .

- if building in mac M1 (architecture arm):
docker buildx build --platform linux/amd64 -t {example} .

- then push it to the registry (example to Docker Hub or Google Artifact Registry):
docker push {example}

- then `cd ../kubernetes`

- deploy the cluster: `kubectl apply -f deployment.yaml`

- deploy the service: `kubectl apply -f service.yaml`

- visit or curl "External endpoints" provided by the Service, we should be able to see: "Hello World!!"
