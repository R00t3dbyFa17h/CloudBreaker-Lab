# ☁️ CloudBreaker Lab: IaaC Attack & Defense Playground

> **Repository Goal:** To practice identifying and exploiting the top cloud misconfigurations by deploying intentionally vulnerable infrastructure and then securing it. This project focuses on the intersection of Infrastructure-as-Code (IaaC), Offensive Cloud Security, and effective remediation.

## 🛡️ The Challenge: Misconfiguration is the New SQLi

The #1 risk in cloud environments is not unpatched code, but human error in configuration (e.g., publicly accessible storage buckets, overly permissive IAM roles). This lab demonstrates the full lifecycle: deploying insecure AWS infrastructure, identifying the flaws, and automating the secure fix.

## 🧠 Offensive & Defensive Strategy

This lab uses a three-stage approach to simulate a real-world cloud security audit:

### Stage 1: Deployment (Infrastructure-as-Code)
* **Tools:** Terraform
* **Action:** We use Terraform to deploy intentionally insecure AWS resources (e.g., an EC2 instance with an overly permissive Security Group, a public S3 bucket, a weak IAM policy).
* **Skill Demonstrated:** Mastery of IaC for rapid environment creation.

### Stage 2: Audit & Exploitation (Penetration Testing)
* **Tools:** ScoutSuite / Prowler, AWS CLI, Python/Bash
* **Action:** We run automated Cloud Security Posture Management (CSPM) tools (ScoutSuite/Prowler) against the deployed infrastructure to find the misconfigurations. We then use the AWS CLI and custom scripts to exploit those findings (e.g., listing the contents of a public S3 bucket).
* **Skill Demonstrated:** Vulnerability Identification, Auditing, and Exploitation of Cloud APIs.

### Stage 3: Remediation (Engineering Fixes)
* **Tools:** Terraform, HCL (HashiCorp Configuration Language)
* **Action:** We rewrite the original Terraform files to securely patch the deployed resources (e.g., restricting the Security Group, enforcing bucket policy, applying Least Privilege to IAM roles). We then use `terraform apply` to fix the environment.
* **Skill Demonstrated:** Secure Configuration, Remediation, and Version Control for infrastructure.

## 📂 Architecture & Misconfiguration Targets

The repository is structured to test specific, high-risk cloud scenarios:

| Scenario | Service | Misconfiguration | Remediation Goal |
| :--- | :--- | :--- | :--- |
| Data Leak | AWS S3 | Public Read/Write Access on a bucket policy. | Enforce least-privilege bucket access and block public access settings. |
| Lateral Movement | AWS IAM | Overly permissive IAM role attached to an EC2 instance. | Restrict the IAM policy to only the necessary services (Least Privilege). |
| Network Exposure | AWS EC2 / VPC | Security Group open to 0.0.0.0/0 (Inbound HTTP/SSH). | Enforce ingress rules for specific IP ranges or only to internal subnets. |

## ⚠️ Legal Disclaimer

This lab is for **Educational and Authorized Security Testing Only**. Do not run these misconfiguration scripts against any production environment. The author assumes no liability for unauthorized use.

---

## 🎮 Complete Demo: Mission 1 (The Leaky Bucket)

Follow these steps to simulate the full Attack & Defense lifecycle.

### 🛑 Prerequisites
1.  **AWS CLI** installed and configured with `aws configure`.
2.  **Terraform** installed.
3.  **Git** installed.

### Phase 1: The Red Team (Deploy & Exploitation)
First, we deploy the misconfigured infrastructure.

```bash
# 1. Navigate to the vulnerable config
cd vulnerable-configs

# 2. Initialize and Apply Terraform
terraform init
terraform apply -auto-approve
```

**The Exploitation:**
Now that the bucket is live, we use our audit script to simulate an anonymous attacker trying to list the files.

```bash
# 3. Get the bucket name from Terraform output or AWS Console
# 4. Run the audit script
../scripts/audit_mission1.sh <YOUR_BUCKET_NAME>
```

**Expected Output:**
> ❌ CRITICAL VULNERABILITY FOUND!
> The bucket is Publicly Accessible.

---

### Phase 2: The Blue Team (Remediation)
Now, we apply the secure configuration to patch the hole.

```bash
# 1. Navigate to the secure config
cd ../secure-configs

# 2. Apply the fix (Terraform will update the existing bucket)
terraform init
terraform apply -auto-approve
```

**Verify the Fix:**
Run the audit script again to confirm the door is closed.

```bash
../scripts/audit_mission1.sh <YOUR_BUCKET_NAME>
```

**Expected Output:**
> ✅ SECURE.
> Access Denied for anonymous users.

---

### 🧹 Phase 3: Cleanup
**CRITICAL:** Always destroy your resources to avoid cloud costs.

```bash
terraform destroy -auto-approve
```
