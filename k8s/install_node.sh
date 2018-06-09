#!/bin/bash


DOWNLOAD_DIR=./kubernetes-download
WORK_DIR=/data/kubernetes
NODE_IP=$(bash ../node_ip.sh)


# 1
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.100.50"
  exit 1
fi


rm -rf ${WORK_DIR}
mkdir -p ${WORK_DIR}/config
systemctl stop kube-proxy.service >/dev/null 2>&1
systemctl stop kubelet.service >/dev/null 2>&1
cp ${DOWNLOAD_DIR}/server/bin/kube-proxy /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kubelet /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kubectl /usr/bin/



echo "set  kubeconfig ..."
bash conf/kubeconfig.sh ${MASTER_ADDRESS}

echo "set  kubelet ..."
bash conf/kubelet.sh ${NODE_IP}

echo "set proxy ..."
bash conf/kube-proxy.sh ${MASTER_ADDRESS} ${NODE_IP}

echo "install success ..."
