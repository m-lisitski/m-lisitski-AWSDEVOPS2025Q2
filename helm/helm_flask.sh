#!/bin/bash
export KUBECONFIG=./temp_k3s/k3s.yaml

helm install flask-app ./helm/flask-app
