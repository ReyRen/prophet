#!/bin/bash

# assume pwd is prophet/contrib/kubespray
LAYOUT="$PWD/config/layout.yaml"
CLUSTER_CONFIG="$PWD/config/config.yaml"

echo "layout config file path: ${LAYOUT}"
echo "cluster config file path: ${CLUSTER_CONFIG}"

echo "Setting up environment..."
/bin/bash script/environment.sh -c ${CLUSTER_CONFIG} || exit $?

echo "Checking layout.yaml schema..."
python3 script/validate_layout_schema.py -l ${LAYOUT} -c ${CLUSTER_CONFIG} || exit $?

echo "Checking requirements..."
/bin/bash requirement.sh -l ${LAYOUT} -c ${CLUSTER_CONFIG}
ret_code_check=$?
if [ $ret_code_check -ne 0 ]; then
  echo ""
  echo "Please press ENTER to stop the script, check the log, and modify the cluster setting to meet the requirements."
  echo "If you are very sure about the configuration, and still want to continue, you can type in \"continue\" to force the script to proceed."
  read user_input
  if [ "${user_input}"x != "continue"x ]; then
    exit $ret_code_check
  fi
fi

echo "Generating kubespray configuration..."
/bin/bash script/configuration-kubespray.sh -l ${LAYOUT} -c ${CLUSTER_CONFIG} || exit $?

echo "Performing ping test..."
ansible all -i ${HOME}/prophet-deploy/cluster-cfg/hosts.yml -m ping || exit $?

echo "Performing pre-check..."
ansible-playbook -i ${HOME}/prophet-pre-check/pre-check.yml set-host-daemon-port-range.yml -e "@${CLUSTER_CONFIG}" || exit $?

echo "Performing pre-installation..."
ansible-playbook -i ${HOME}/prophet-deploy/cluster-cfg/hosts.yml pre-installation.yml || exit $?

echo "Starting kubernetes..."
/bin/bash script/kubernetes-boot.sh || exit $?
