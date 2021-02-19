#!/bin/bash
set -e

while getopts "l:c:" opt; do
  case $opt in
    l)
      LAYOUT=$OPTARG
      ;;
    c)
      CLUSTER_CONFIG=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

mkdir -p ${HOME}/prophet-deploy/cluster-cfg

LOCAL_PAI_PATH=$(realpath $PWD/../..)
echo "Local prophet folder path: $LOCAL_PAI_PATH"

echo "Generating kubespray configuration"
python3 ${LOCAL_PAI_PATH}/contrib/kubespray/script/k8s_generator.py -l ${LAYOUT} -c ${CLUSTER_CONFIG} -o ${HOME}/prophet-deploy/cluster-cfg

cp ${HOME}/prophet-deploy/cluster-cfg/prophet.yml ${HOME}/prophet-deploy/kubespray/inventory/prophet/
cp ${HOME}/prophet-deploy/cluster-cfg/hosts.yml ${HOME}/prophet-deploy/kubespray/inventory/prophet/
