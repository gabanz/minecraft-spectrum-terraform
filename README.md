## Minecraft server protected by Cloudflare Spectrum

### What

Terraform recipe to create your own personal [economical Minecraft server in Google Cloud](https://www.futurice.com/blog/friends-and-family-minecraft-server-terraform-recipe) that is proxied by [Cloudflare Spectrum](https://blog.cloudflare.com/cloudflare-for-ssh-rdp-and-minecraft/).

### Features
- Preemptible VM instance running Minecraft server in a docker container  
- Reserved public IP and persistent disk
- Advanced DDoS attack protection

### How

- Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html) and [gcloud](https://cloud.google.com/sdk/docs/quickstarts) command line tool
- Authenticate to Google Cloud
```
gcloud auth application-default login
```
- Get the Project ID
```
DEVSHELL_PROJECT_ID="$(gcloud config get-value project)"
echo $DEVSHELL_PROJECT_ID
```
- Create Google Cloud service account
```
gcloud iam service-accounts create terraform --display-name "Terraform service account"
```
- Create Google Cloud service account key
```
gcloud iam service-accounts keys create ./key.json \
  --iam-account terraform@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com
```
- Create Cloudflare API Token that contains `Zone Settings:Edit` permission
- Edit `terraform.tfvars` file with the corresponding variable values
``` 
# Cloudflare
cloudflare_api_token = "YOUR_CLOUDFLARE_API_TOKEN"
cloudflare_zone_id = "YOUR_CLOUDFLARE_ZONE_ID"
cloudflare_spectrum_hostname = "YOUR_SPECTRUM_HOSTNAME"

# GCP
gcp_project = "YOUR_GCP_PROJECT_ID"
credentials_file = "key.json"
gcp_region = "asia-southeast1"
gcp_zone = "asia-southeast1-b"
```
- Run Terraform in the directory containing the repository
```
terraform init
terraform plan
terraform apply 
```

### Cost
Approximate operating cost for GCP:

| Resources | Cost |
| ------------- |:-------------:|
| Reserved IP address | $1.46/month |
| Reserved 10Gb disk | $0.40 |
| Preemptible VM instance | $0.01/hour |

Cloudflare Spectrum features that are available depends on the plan you are subscribed to.

| Cloudflare Plan | Protocol | Data Allowance | Cost |
| ------------- |:-------------:|:-------------:|:-------------:|
| Free | none | n/a | $0/month |
| Pro | SSH, Minecraft | 5GB/month(*) | $20/month |
| Business | SSH, Minecraft, RDP | 10GB/month(*) | $200/month |
| Enterprise | SSH, Minecraft, RDP | 10GB/month(*) | Custom price |

(*) After the free cap you will be billed [$1/GB](https://support.cloudflare.com/hc/en-us/articles/360041721872). Traffic generated from DDoS attacks do not incur charges.
