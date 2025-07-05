#!/bin/bash
export KUBECONFIG=./temp_k3s/k3s.yaml

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add jenkinsci https://charts.jenkins.io

helm install test-nginx bitnami/nginx
helm uninstall test-nginx

helm repo update

kubectl create namespace jenkins

kubectl apply -f ./jenkins/jenkins-01-volume.yaml

kubectl apply -f ./jenkins/jenkins-02-sa.yaml 

helm install jenkins -n jenkins -f ./jenkins/jenkins-values.yaml jenkinsci/jenkins
