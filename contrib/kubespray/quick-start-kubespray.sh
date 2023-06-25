#!/bin/bash

if getopts "v" opt; then
  case $opt in
    v)
      export ANSIBLE_DISPLAY_OK_HOSTS=yes
      export ANSIBLE_DISPLAY_SKIPPED_HOSTS=yes
      export ANSIBLE_CALLBACK_WHITELIST="profile_tasks"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
else
    export ANSIBLE_DISPLAY_OK_HOSTS=no
    export ANSIBLE_DISPLAY_SKIPPED_HOSTS=no
    export ANSIBLE_CALLBACK_WHITELIST=""
fi

# assume pwd is prophet/contrib/kubespray
LAYOUT="$PWD/config/layout.yaml"
CLUSTER_CONFIG="$PWD/config/config.yaml"

echo "layout config file path: ${LAYOUT}"
echo "cluster config file path: ${CLUSTER_CONFIG}"

echo "Setting up environment..."
# 如果出现 ERROR: Cannot uninstall 'PyYAML'的报错
# 执行 pip install --ignore-installed PyYAML
#/bin/bash script/environment.sh -c ${CLUSTER_CONFIG} || exit $?

echo "Checking layout.yaml schema..."
python3 script/validate_layout_schema.py -l ${LAYOUT} -c ${CLUSTER_CONFIG} || exit $?

echo "Checking requirement..."
/bin/bash requirement.sh -l ${LAYOUT} -c ${CLUSTER_CONFIG}