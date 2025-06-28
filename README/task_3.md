# Task 3: K8s Cluster Configuration and Creation

## Infrastructure Changes from Task 2

### New Terraform Resources Added:

- **TLS Key Generation**: `tls_key.tf` - Automatic SSH key generation for K3s nodes
- **K3s Instances**: `k3s_instances.tf` - Control plane and worker node EC2 instances
- **K3s Variables**: `k3s_variables.tf` - K3s-specific configuration variables
- **Enhanced Bastion**: Updated bastion host with SSH key setup for K3s access

### Network Architecture:

- **Control Plane**: Deployed in private subnet `us-east-1a` (10.0.2.10/24)
- **Worker Node**: Deployed in private subnet `us-east-1b` (10.0.4.11/24)
- **Access**: All K3s nodes accessible via bastion host through private network

## Create K3s cluster

- **Control Plane**

  - Availability Zone: `us-east-1a`
  - IP: `10.0.2.10/24`

- **Worker Node**
  - Availability Zone: `us-east-1b`
  - IP: `10.0.4.11/24`

## Deployment Steps

1. **Apply Terraform Configuration**:

   ```bash
   cd terraform
   terraform apply
   ```

2. **Wait for K3s Installation** (5-10 minutes):

   - Control plane installs K3s server
   - Worker node joins cluster automatically
   - Bastion host configured with SSH access

3. **Setup Local Access**:
   ```bash
   chmod +x scripts/k3s_via_localhost.sh
   ./scripts/k3s_via_localhost.sh
   ```

## Prepare k3s cluster and bastion host

To understand how the K3s control plane, worker nodes, and bastion host are provisioned and configured, see the following files:

- `user_data/bastion_10.tftpl` - Bastion SSH key setup
- `user_data/control_plane_k3s.sh` - K3s server installation
- `user_data/node_k3s.tftpl` - Worker node setup and cluster joining

## Configure local machine to be able to work with cluster via local machine

To configure your local machine for interacting with the K3s cluster, use:

- `terraform/scripts/k3s_via_localhost.sh`

**Important:**  
Before running the above script, ensure that `kubectl` is installed on your local machine.

## Usage

After successful deployment:

```bash
# Test cluster access
KUBECONFIG=./temp_k3s/k3s.yaml kubectl get nodes

# For convenience
export KUBECONFIG=./temp_k3s/k3s.yaml
kubectl get nodes
```

## Security Notes

- K3s nodes are deployed in private subnets for security
- SSH access via bastion host only
- Automatic SSH key generation and distribution
- Cluster communication over private network
