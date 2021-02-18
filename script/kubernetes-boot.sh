#!/bin/bash

echo "setup k8s cluster"
cd ${HOME}/prophet-deploy/kubespray
# Ubuntu 20.04 doesn't have python2 pre-installed,
# but Ubuntu 16.04, 18.04, and 20.04 all have python3 pre-installed.
# So we use python3 as the default interpreter.
ansible-playbook -i inventory/kubespray/hosts.yml -e "ansible_python_interpreter=/usr/bin/python3" cluster.yml --become --become-user=root -e "@inventory/prophet/prophet.yml" || exit $?

sudo mkdir -p ${HOME}/prophet-deploy/kube || exit $?
sudo cp -rf ${HOME}/prophet-deploy/kubespray/inventory/pai/artifacts/admin.conf ${HOME}/prophet-deploy/kube/config || exit $?

echo "You can run the following commands to setup kubectl on you local host:"
echo "ansible-playbook -i ${HOME}/pai-deploy/kubespray/inventory/pai/hosts.yml set-kubectl.yml --ask-become-pass"
