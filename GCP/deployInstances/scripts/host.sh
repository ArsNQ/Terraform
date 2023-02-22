#!/bin/bash
# Récupère les adresses IP des machines créées avec Terraform.
IP_ADDRESSES_MASTER=$(terraform output -json public_ip_master | jq -r '.[] | .[]')
IP_ADDRESSES_WORKERS=$(terraform output -json public_ip_worker | jq -r '.[] | .[]')

num_master=0
num_worker=0

# Écrit les adresses IP des masters dans le fichier Ansible hosts.
echo "[k8sMasters]" > ~/deployKubernetes/containerd/hosts
for IP_ADDRESSES_MASTER in $IP_ADDRESSES_MASTER; do
    hostname_master="kubernetes-master-$(printf "%02d" $num_master)"
    echo "${hostname_master} ansible_host=$IP_ADDRESSES_MASTER ansible_user=ubuntu" >> ~/deployKubernetes/containerd/hosts
    num_master=$((num_master + 1))
done

# Écrit les adresses IP des workers dans le fichier Ansible hosts.
echo "[k8sWorkers]" >> /deployKubernetes/containerd/hosts
for IP_ADDRESSES_WORKERS in $IP_ADDRESSES_WORKERS; do
    hostname_worker="kubernetes-worker-$(printf "%02d" $num_worker)"
    echo "${hostname_worker} ansible_host=$IP_ADDRESSES_WORKERS ansible_user=ubuntu" >> ~/deployKubernetes/containerd/hosts
    num_worker=$((num_worker + 1))
done

echo "ip_master: $IP_ADDRESSES_MASTER" >> ~/deployKubernetes/containerd/setupMaster/vars/main.yml
