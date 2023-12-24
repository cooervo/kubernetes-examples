# Networking flow:

**`k8s ingress` -> `superset service` -> `superset deployment`**

### Instalation steps

1. run terraform at `terraform/` folder
2. install `superset` within namespace `superset` with helm: 

       helm install -n superset superset superset/ -f superset/chart-values/superset-values.yaml

3. Wait until all workloads are running, and Jobs are completed
4. install `ingress` in `kubernetes/` folder.
    
    a. wait until `ManagedCertificate` is provisioned can take around 60 minutes (can be checked via `k9s`)

5. use `kubectl get ingress -n superset` to get the external IP of the `ingress`
6. go to your domain name manager (ex CloudDNS)
7. set `A` record for `superset.example.com` pointing to the external IP of the `ingress`
    
8. use `dig` command to double check when domain is pointing to the correct IP:
        
        dig +short superset.testmosaic.com

9. open browser and go to `superset.example.com` it should work
10. use credentials username from `superset/chart-values/super-values.yaml`
