## Initializing new stack in Pulumi

- make sure we already provisioned needed infra with terraform:
    - enable KMS API: `gcloud services enable cloudkms.googleapis.com`
    - Add `roles/cloudkms.cryptoKeyEncrypterDecrypter` & `roles/cloudkms.admin` to your google account
    - visit: https://console.cloud.google.com/security/kms/keyrings?hl=en&{PROJECT_ID}
    - create a key ring and key 
    - create the bucket for pulumi state
- copy and paste the pulumi secret from KMS Key Rings > Key > Click 3 vertical dots on right > Copy Resource name

- login to gcloud with Application Default Credentials (ADC)

```sh
gcloud auth application-default login
```

- login to your desired backend

```sh
pulumi login gs://my-bucket-name-example
```

- use the resource name to initialize the stack:

```sh

# notice the secrets-provider flag must start with gcpkms:// for GCP KMS
pulumi stack init {STACK_NAME} --secrets-provider="gcpkms://projects/{PROJECT_ID}/locations/{REGION}/keyRings/{ENV}-key-ring/cryptoKeys/pulumi-secret"
```

## Dev Workflow for configuring k8s resource with Pulumi

4. pulumi update with defined stack and corresponding config file

```sh
# cd to kubernetes/ directory

pulumi up -s {STACK_NAME} --config-file stacks/Pulumi.{STACK_NAME}.yaml

# for party-ai-server stack
pu -s prod-core --config-file stacks/Pulumi.prod-core.yaml

```

## Set up config secrets

Set the secret
    
```sh       
pulumi config set --path stack:data.test-foo-bar --secret “testvalue”
```

Get the secret
    
```sh       
pulumi config get --path stack:data.test-foo-bar
```

Delete the secret
    
```sh       
pulumi config rm --path stack:data.test-foo-bar
```