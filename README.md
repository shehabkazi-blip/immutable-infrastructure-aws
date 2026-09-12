# Immutable Infrastructure CI/CD Pipeline (AWS, Packer, Ansible, Terraform)

An automated, production-grade DevOps pipeline that builds hardened AWS AMIs and provisions immutable infrastructure, eliminating configuration drift.

## 🚀 Architecture & Tech Stack

- **Cloud Provider:** AWS (`us-west-2`)
- **AMI Baking:** Packer (with HashiCorp Amazon plugin)
- **OS Hardening & Configuration:** Ansible (UFW firewall, Fail2ban setup)
- **Infrastructure Provisioning:** Terraform (Auto Scaling Groups, Launch Templates)
- **CI/CD Automation:** GitHub Actions

---

## 🛠️ Pipeline Workflow

1. **Trigger:** A `git push` to the `main` branch triggers the GitHub Actions pipeline.
2. **Packer Build:** Packer spins up a temporary EC2 instance using the base Ubuntu 22.04 AMI, invokes Ansible to apply security hardening, and bakes a fresh **Golden AMI**.
3. **Terraform Apply:** Terraform takes the newly generated Golden AMI and orchestrates the Auto Scaling Group (ASG) deployment on default AWS VPC subnets.

---

## 📂 Repository Structure

```text
├── .github
│   └── workflows
│       └── deploy.yml      # GitHub Actions CI/CD Pipeline
├── ansible
│   └── hardening.yml       # Ansible playbook for OS security (UFW, Fail2ban)
├── packer
│   └── ubuntu-hardened.pkr.hcl # Packer configuration for Golden AMI
└── terraform
    └── main.tf             # Terraform configuration for ASG & Infrastructure



⚙️ Setup & Deployment
1. Prerequisites
AWS Account with appropriate IAM permissions.

GitHub Repository Secrets configured:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

2. Manual Execution / Local Testing
If you want to run components locally:

Packer Build:

Bash
cd packer
packer init .
packer build ubuntu-hardened.pkr.hcl
Terraform Apply:

Bash
cd terraform
terraform init
terraform apply
🧹 Cleanup
To avoid unexpected AWS charges, destroy the infrastructure:

Bash
cd terraform
terraform destroy
(Note: Remember to deregister the custom AMI and delete associated snapshots from the AWS EC2 console if no longer needed).
