#!/bin/bash

while getopts "c:" opt; do
  case $opt in
    c)
      CLUSTER_CONFIG=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

echo "Create working folder in ${HOME}/prophet-deploy"
mkdir -p ${HOME}/prophet-deploy/

echo "Clone kubespray source code from github to ${HOME}/prophet-deploy"
sudo rm -rf ${HOME}/prophet-deploy/kubespray
git clone -b master https://github.com/ReyRen/kubespray.git ${HOME}/prophet-deploy/kubespray

echo "Copy inventory folder, and save it "
cp -rfp ${HOME}/prophet-deploy/kubespray/inventory/sample ${HOME}/prophet-deploy/kubespray/inventory/prophet


echo "Install necessray packages"

echo "Install Python3 and pip"
sudo apt-get -y update
sudo apt-get -y install software-properties-common python3 python3-dev
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py

echo "Install python packages"
sudo python3 -m pip install paramiko # need paramiko for ansible-playbook
sudo python3 -m pip install -r script/requirements.txt

echo "Install sshpass"
sudo apt-get -y install sshpass

echo "Install kubespray's requirements and ansible is included"
sudo python3 -m pip install -r ${HOME}/prophet-deploy/kubespray/requirements.txt

# ansible 2.7 doesn't support distribution info collection on Ubuntu 20.04
# Use ansible 2.9.7 as a workaround
# Reference: https://stackoverflow.com/questions/61460151/ansible-not-reporting-distribution-info-on-ubuntu-20-04
# We can upgrade kubespray version to avoid this issue in the future.
sudo python3 -m pip install ansible==2.9.7

