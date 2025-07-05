## Task 4: Jenkins Installation and Configuration

## Installation Steps

### 1. Infrastructure Setup

```bash
cd terraform

# Initialize Terraform
terraform init

# Deploy infrastructure
terraform apply

# Prepare environment to use k3s from local machine
./scripts/k3s_via_localhost.sh
```

### 2. Helm Installation Verification

```bash
# Apply k3s configuration path environment
export KUBECONFIG=./temp_k3s/k3s.yaml

# Add Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Test Helm installation with Nginx chart
helm install nginx-test bitnami/nginx
kubectl get pods
helm uninstall nginx-test
```

### 3. Jenkins Installation

```bash
# Prepare cluster for managing persistent volumes (PV) and persistent volume claims (PVC)
kubectl apply -f ./jenkins/jenkins-01-volume.yaml

# Create Jenkins namespace
kubectl create namespace jenkins

# Create k3s Service Account for Jenkins
kubectl apply -f ./jenkins/jenkins-02-sa.yaml

# Add Jenkins Helm repository
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

# Install Jenkins with custom values
helm install jenkins jenkinsci/jenkins \
  --namespace jenkins \
  --values k3s-jenkins/jenkins-values.yaml
```

## Configuration Details

### Persistent Storage

- Uses `local-path` storage class (K3s default)
- 20Gi persistent volume for Jenkins data

### Authentication & Security

- **Security Realm**: Local authentication with admin user
- **Authorization**: Logged-in users can do anything
- **Admin Credentials**:
  - Username: `admin`
  - Password: `admin-password`
- **Security**: Role-Based Plugin will be installed with Jenkins
  - Dashboard -> Manage Jenkins -> Security
    `Authorization` change to `Role-Based Strategy`
  - change temp admin password
  - create new user
  - add new user admin role
- **TLS**:
  - if needed can be created self-signed certificate or use certbot to create TLS certificate

### JCasC (Jenkins Configuration as Code)

The Jenkins configuration is managed through JCasC with the following features:

```yaml
JCasC:
  defaultConfig: true
  overwriteConfiguration: false
  configScripts:
    welcome-message: |
      jenkins:
        systemMessage: Welcome to our CI\CD server. This Jenkins is configured and managed 'as code'.
      jobs:
        - script: >
            freestyleJob('hello-world') {
              description('A simple freestyle job that prints Hello World')
              steps {
                shell('echo "Hello world"')
              }
            }
```

### Reverse Proxy Setup

Nginx is configured on the bastion host to proxy requests to Jenkins:

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    location / {
        proxy_pass http://10.0.4.11:32000/;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Access Information

- **Jenkins URL**: http://<Bastion IP> (via bastion reverse proxy)
- **Admin Username**: admin
- **Admin Password**: admin-password
- **NodePort**: 32000

## Verification Steps

### 1. Check Cluster Status

```bash
kubectl get nodes
kubectl get all --all-namespaces
```

### 2. Verify Jenkins Deployment

```bash
kubectl get pods -n jenkins
kubectl get svc -n jenkins
```

### 3. Test Jenkins Access

```bash
curl -I http://<Bastion IP>
```

### 4. Verify Hello World Job

- Access Jenkins UI at http://<Bastion IP>
- Login with admin/admin-password
- Navigate to the "hello-world" job
- Run the job and verify "Hello world" appears in the console output

## File Structure

```
jenkins_check/
├── k3s-jenkins/
│   ├── jenkins-values.yaml      # Helm values with JCasC configuration
│   ├── jenkins-01-volume.yaml   # Persistent volume configuration
│   ├── jenkins-02-sa.yaml       # Service account configuration
│   ├── jenkins.sh               # Jenkins setup script
│   └── nginx.conf               # Reverse proxy configuration
├── scripts/
│   └── k3s_via_localhost.sh     # K3s access script
├── user_data/                   # Cloud-init scripts
├── *.tf                         # Terraform configuration files
```

## Troubleshooting

### Jenkins Pod Issues

```bash
kubectl describe pod jenkins-0 -n jenkins
kubectl logs jenkins-0 -n jenkins -c jenkins
```

### Storage Issues

```bash
kubectl get pv
kubectl get pvc -n jenkins
```

### Network Issues

```bash
# Test connectivity to Jenkins service
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```
