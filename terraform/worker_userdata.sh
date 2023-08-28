#!/bin/bash

# Update and install necessary dependencies
apt-get update
apt-get install -y apt-transport-https curl

# Setup Docker repository and install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Setup Kubernetes repository and install Kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

# The below join command is just a placeholder
# You will need to replace it with the actual command from the master node's kubeadm_init_output.txt file
kubeadm join ${master_ip}:6443 --token [token] --discovery-token-ca-cert-hash [hash]