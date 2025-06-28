#!/bin/bash
set -euo pipefail

BASTION_PUBLIC_IP=$(terraform output -raw bastion_10_public_ip)

echo "Bastion public IP: $BASTION_PUBLIC_IP"
echo 
echo "Create /temp_k3s folder"
rm -rf temp_k3s 2>/dev/null; mkdir -p temp_k3s
echo
echo "Copy .ssh/k3s from bastion to ./temp_k3s/k3s on localhost"
echo "No timeout set — press Ctrl + C if it hangs and retry later."
scp -i ~/.ssh/id_rsa "ubuntu@$BASTION_PUBLIC_IP:.ssh/k3s" ./temp_k3s
chmod 600 ./temp_k3s/k3s

echo 
echo "Trying to connect to control plane and save kubelet configuration file k3s.yaml to ./temp_k3s/..."
echo "It can last up to 5 min due to Control Plane should be installed and run"
MAX_RETRIES=10
RETRIES=0
until ssh -J "ubuntu@$BASTION_PUBLIC_IP" \
    -i ./temp_k3s/k3s \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    ubuntu@10.0.2.10 \
    'sudo cat /etc/rancher/k3s/k3s.yaml' > ./temp_k3s/k3s.yaml 2> /dev/tty; do

    ((RETRIES++))
    if [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "Max retries reached. Exiting."
    exit 1
    fi
    echo "Failed..."
    echo "Trying again in a moment..."
    sleep 50
done

chmod 600 ./temp_k3s/k3s.yaml

echo 
echo "Create tunnel 6443:localhost:6443 between localhost and Control Plane"
ssh -i ./temp_k3s/k3s -fN -L 6443:localhost:6443  ubuntu@10.0.2.10 -J "ubuntu@$BASTION_PUBLIC_IP"

echo
echo "Tunnel to control plane is established on port 6443"
echo 

echo "Test connection with k3s..."
KUBECONFIG=./temp_k3s/k3s.yaml kubectl get node
echo 
echo "It's normal to see only the Control Plane node at first — Node will join in 3-5 minutes."
echo

date

echo 
echo "K3s is now ready to use from your local machine."
echo 
echo "Try to run:"
echo "  KUBECONFIG=./temp_k3s/k3s.yaml kubectl get node"
echo
echo "For convenience: "
echo "  export KUBECONFIG=./temp_k3s/k3s.yaml"
echo 