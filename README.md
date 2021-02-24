# tb-gcp-management-plane-architecture

## Dependencies
* Gcloud SDK (already installed in cloud shell)
* Git (already installed in cloud shell)
* Jq (already installed in cloud shell)
* Terraform (automatically installed by make setup)
* Terragrunt (automatically installed by make setup)

## Pre-Requisites
1. Cloud Shell - https://shell.cloud.google.com
1. GCP Project for deployment

## Setup
Execute the following in a Cloud Shell terminal:

```bash
gcloud services enable compute
git clone https://github.com/tranquilitybase-io/tb-gcp-management-plane-architecture.git

 cat <<EOF > deployment/common_vars.json
{
  "project_id": "[PROJECT]",
  "region": "europe-west2",
  "preemptive": true,
  "skip_forward_proxy": false,
  "skip_gke": false
}
EOF
source ./scripts/config.sh
make setup
```
Replace [PROJECT] in deployment/common_vars.json with the GCP Project ID.

## Deployment
Execute the following in a Cloud Shell terminal:
```bash
make apply
 
gcloud compute ssh $(gcloud compute instances list \
     --project $TG_PROJECT --format="value(name)" --filter=forward) \
     --zone $(gcloud compute instances list --project $TG_PROJECT --format="value(zone)" --filter=forward) \
     --project $TG_PROJECT \
     --tunnel-through-iap \
     -- -L 3128:localhost:3128
```
Execute the following in a *new* Cloud Shell terminal:

```bash
cd tb-gcp-management-plane-architecture
source ./scripts/config.sh
gcloud container clusters get-credentials tb-mgmt-gke --region $TG_REGION
 
env HTTPS_PROXY=localhost:3128 kubectl get nodes
env HTTPS_PROXY=localhost:3128 kubectl cluster-info
```
