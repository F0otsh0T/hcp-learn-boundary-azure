#! /bin/bash

set -euo pipefail

echo "[INFO] Setting Logging"
sudo touch /var/log/user-data.log
sudo chown root:adm /var/log/user-data.log
# exec > >(tee /var/log/boundary_worker_setup.log|logger -t boundary_worker_setup -s 2>/dev/console) 2>&1
#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

# echo "Fixing SSH permissions..."
# sudo echo "${ssh_public_key}" >> /home/ubuntu/.ssh/authorized_keys
# echo "[INFO] Inject SSH Public Key"
# echo "${ssh_public_key}" >> ~/.ssh/authorized_keys

# echo "[INFO] Test Attribute Insertion"
# echo "ssh_public_key: ${ssh_public_key}"
# echo "${ssh_public_key}" > /tmp/ssh_public_key
# echo "boundary_cluster_id: ${boundary_cluster_id}"
# echo "${boundary_cluster_id}" > /tmp/cluster_id

# mkdir /home/ubuntu/boundary/ && cd /home/ubuntu/boundary/

echo "[INFO] Creating Boundary Auth and Session Recording Directories"
mkdir -p /var/tmp/boundary-auth
mkdir -p /var/tmp/boundary-session-recording

sudo chmod 777 -R /var/tmp/boundary*

echo "[INFO] Installing Boundary"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - ;\
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" ;\
sudo apt-get update && sudo apt-get install boundary-enterprise -y

echo "[INFO] Boundary Version"
boundary version

echo "[INFO] Installing Azure CLI"
# // https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt // #
sudo apt-get update && sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update && sudo apt-get install azure-cli -y

echo "[INFO] Installing JQ and Unzip"
cd /tmp
sudo apt-get update && sudo apt-get install -y jq unzip

# echo "[INFO] Manual Install of Boundary Worker
# #wget -q "$(curl -fsSL "https://api.releases.hashicorp.com/v1/releases/boundary-worker/latest?license_class=hcp" | jq -r '.builds[] | select(.arch == "amd64" and .os == "linux") | .url')" 
# wget -q "$(curl -fsSL "https://api.releases.hashicorp.com/v1/releases/boundary/latest?license_class=enterprise" | jq -r '.builds[] | select(.arch == "amd64" and .os == "linux") | .url')" 
# unzip *.zip
# #sudo cp /tmp/boundary-worker /bin
# sudo cp /tmp/boundary /bin
# #boundary-worker -v
# boundary -v
