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
git clone -b release-2.20 https://github.com/kubernetes-sigs/kubespray.git ${HOME}/prophet-deploy/kubespray

echo "Copy inventory folder, and save it "
cp -rfp ${HOME}/prophet-deploy/kubespray/inventory/sample ${HOME}/prophet-deploy/kubespray/inventory/prophet

echo "Install necessary packages"

# kubespray 2.20 using ansible==5.7.1(ansible-core==2.12.5(python 3.8-3.10))
# So, we should using python3.9 at least.
echo "Install Python3.8 and pip"
sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa


echo "Install Python3 and pip"
sudo apt-get update
# python3-dev python3-setuptools python3-wheel
sudo apt-get -y install software-properties-common python3.8 python3.8-dev python3-pip
# set python3.8 as the default python3
sudo rm -rf /usr/bin/python3
sudo ln -s /usr/bin/python3.8 /usr/bin/python3

# Here we use a fixed version number to ensure compatibility.
#sudo python3 -m pip install pip==20.3.4
sudo python3 -m pip install --upgrade pip

echo "Install python packages"
sudo python3 -m pip install paramiko # need paramiko for ansible-playbook
sudo pip install --ignore-installed PyYAML # 防止ERROR: Cannot uninstall 'PyYAML'.错误

# google-auth 2.21.0 requires urllib3<2.0
pip uninstall google-auth
pip install --upgrade google-auth
# urllib3 ({0}) or chardet ({1}) doesn't match a supported
pip uninstall urllib3 chardet
pip install --upgrade requests

sudo python3 -m pip install -r script/requirements.txt

echo "Install sshpass"
sudo apt-get -y install sshpass

# kubespray使用的ansible已经是5.7.1了
#sed -i 's/ansible==.*/ansible==2.9.7/' ${HOME}/prophet-deploy/kubespray/requirements.txt

echo "Install kubespray's requirements and ansible is included"
sudo python3 -m pip install -r ${HOME}/prophet-deploy/kubespray/requirements.txt