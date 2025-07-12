## Task 5: Simple Application Deployment with Helm

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

### 3. Deployment Flask App via Helm

```bash
# Create Docker image
docker build -t mlisitski86/flask-app:1.amd64 ./flask-app/

# Login in Docker Hub
docker login

# Push Docker image in Docker hub
docker push mlisitski86/flask-app:1.amd64

# Helm Flask App Configuration parameters
cat helm/flask-app/values.yaml

# Install Flask App
helm install flask-app ./helm/flask-app
```

## Configuration Details

### Flask App Setup

The Flask application is deployed using a custom Helm chart with the following configuration:

```nginx
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;
    server_name _;

    location / {
        proxy_pass http://10.0.4.11:32500/;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- **Image**: mlisitski86/flask-app:1.amd64
- **Service Type**: NodePort
- **Port**: 32500
- **Replicas**: 1

## Access Information

- **Flask App URL**: http://<Bastion IP>:8080 (via bastion reverse proxy)
- **NodePort**: 32500

## Verification Steps

### 1. Check Cluster Status

```bash
kubectl get nodes
kubectl get all --all-namespaces
```

### 2. Verify Flask App Deployment

```bash
kubectl get pods -l app=flask-app
kubectl get svc -l app=flask-app
```

### 3. Test Flask App Access

```bash
curl -I http://<Bastion IP>:8080
curl http://<Bastion IP>:8080
```

### 4. Verify Flask App Response

- Access the Flask app at http://<Bastion IP>:8080
- Verify that the application responds with the expected output
- Check logs if needed: `kubectl logs deployment.apps/flask-app`

## File Structure

```
flask-app/
├── Dockerfile
├── main.py
├── README.md
└── requirements.txt
helm/
├── flask-app
│   ├── Chart.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── NOTES.txt
│   │   └── service.yaml
│   └── values.yaml
└── helm_flask.sh
```

## Troubleshooting

### Flask App Pod Issues

```bash
kubectl describe deployment.apps/flask-app
kubectl logs deployment.apps/flask-app
```

### Network Issues

```bash
# Test connectivity to Flask app service
kubectl port-forward svc/flask-app 8080:32500
```

### Helm Issues

```bash
# Check Helm release status
helm list
helm status flask-app

# Uninstall and reinstall if needed
helm uninstall flask-app
helm install flask-app ./helm/flask-app
```
