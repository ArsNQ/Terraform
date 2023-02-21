#!/bin/bash
IP_ADDRESSES_MASTER=$(terraform output -json public_ip_master | jq -r '.[] | .[]')

echo "ip_master: $IP_ADDRESSES_MASTER" >> /Users/eq29753/Documents/Github/deployKubernetes/containerd/setupMaster/vars/main.yml