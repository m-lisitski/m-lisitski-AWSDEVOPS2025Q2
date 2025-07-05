#!/bin/bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install nginx bitnami/nginx


helm repo add jenkinsci https://charts.jenkins.io
helm repo update

helm search repo jenkinsci

wget https://raw.githubusercontent.com/installing-jenkins-on-kubernetes/jenkins-01-volume.yaml
kubectl apply -f ./jenkins/jenkins-01-volume.yaml

kubectl create namespace jenkins

wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-02-sa.yaml

# Modify labels and annotations to enable usage with Helm
#
# metadata:
#   labels:
#     app.kubernetes.io/managed-by: Helm
#   annotations:
#     meta.helm.sh/release-name: jenkins
#     meta.helm.sh/release-namespace: jenkins


kubectl apply -f ./jenkins/jenkins-02-sa.yaml 

wget -O jenkins-values.yaml raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml

# 222   serviceType: NodePort
# 231   nodePort: 32000
# 407   installPlugins:
#           - role-strategy
# 1265  storageClass: jenkins-pv
# 1320  serviceAccount:
# 1331      create: false
# 1335  name: jenkins

kubectl create namespace jenkins
chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f ./jenkins/jenkins-values.yaml $chart

# NAME: jenkins
# LAST DEPLOYED: Sat Jul  5 08:58:30 2025
# NAMESPACE: jenkins
# STATUS: deployed
# REVISION: 1
# NOTES:
# 1. Get your 'admin' user password by running:
#   kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
# 2. Get the Jenkins URL to visit by running these commands in the same shell:
#   echo http://127.0.0.1:8080
#   kubectl --namespace jenkins port-forward svc/jenkins 8080:8080

# 3. Login with the password from step 1 and the username: admin
# 4. Configure security realm and authorization strategy
# 5. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http://127.0.0.1:8080/configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos

# For more information on running Jenkins on Kubernetes, visit:
# https://cloud.google.com/solutions/jenkins-on-container-engine

# For more information about Jenkins Configuration as Code, visit:
# https://jenkins.io/projects/jcasc/


# NOTE: Consider using a custom image with pre-installed plugins

# If you get the following error, you forgot to modify the ServiceAccount metadata labels and annotations.
# See above for details.
#
# Error: INSTALLATION FAILED: 
# Unable to continue with install: 
# ServiceAccount "jenkins" in namespace "jenkins" exists 
# and cannot be imported into the current release: invalid ownership metadata; 
# label validation error: missing key "app.kubernetes.io/managed-by": 
#     must be set to "Helm"; 
# annotation validation error: missing key "meta.helm.sh/release-name": 
#     must be set to "jenkins"; 
# annotation validation error: 
#     missing key "meta.helm.sh/release-namespace": 
#         must be set to "jenkins"


# NAME            READY   STATUS                  RESTARTS        AGE
# pod/jenkins-0   0/2     Init:CrashLoopBackOff   5 (2m21s ago)   5m49s

# Michaels-MacBook-Air: epam_task_3_k3s m.lisitski$ kubectl -n jenkins logs pod/jenkins-0
# Defaulted container "jenkins" out of: jenkins, config-reload, config-reload-init (init), init (init)
# Error from server (BadRequest): container "jenkins" in pod "jenkins-0" is waiting to start: PodInitializing
# Michaels-MacBook-Air: epam_task_3_k3s m.lisitski$ kubectl logs pod/jenkins-0 -n jenkins -c init
# /var/jenkins_config/apply_config.sh: 4: cannot create /var/jenkins_home/jenkins.install.UpgradeWizard.state: Permission denied
# disable Setup Wizard

# You need to change permissions of the Jenkins volume to allow Jenkins to write to it.
# You need to do it on the host machine where the volume is mounted.

chown -R 1000:1000 /data/jenkins-volume/


# Login under admin user
# You can get the password by running the following command:
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

# Create new user 
# Login under this user
# Create new job
# Create new pipeline job
# 
# You can check logs
# kubectl exec -n jenkins -it jenkins-0 -- cat /var/jenkins_home/jobs/<job-name>/builds/<build-number>/log

# install nginx on any node in k3s cluster
# 
# replace content /etc/nginx/sites-available/default to ./jenkins/nginx.conf

nginx -t
systemctl restart nginx


# "Hello World" job is created via JCasC in HELM chart values.

# Modify jenkins-02-sa.yaml
#
# Add job-dsl plugin to the list of plugins to be installed. 
#
# 407 installPlugins:
#        - job-dsl
#
# 80 password: "admin-password"
#
#
#  524 line in helm jenkins values.yaml
# configScripts:
#   welcome-message: |
#     jenkins:
#       systemMessage: Welcome to our CI\CD server. This Jenkins is configured and managed 'as code'.
#     jobs:
#       - script: >
#           pipelineJob('hello-world') {
#             definition {
#               cps {
#                 script('''
#                   pipeline {
#                     agent any
#                     stages {
#                       stage('Say Hello') {
#                         steps {
#                           echo 'Hello, World!'
#                         }
#                       }
#                     }
#                   }
#                 ''')
#                 sandbox()
#               }
#             }
#           }

kubectl port-forward -n jenkins pod/jenkins-0 8080:8080 &

# Open http://localhost:8080 in your browser
# You can login under admin user

# Or you can use Bastion public IP address
# http://<bastion-ip>
