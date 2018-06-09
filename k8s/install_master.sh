#!/bin/bash


DOWNLOAD_DIR=./kubernetes-download
WORK_DIR=/data/kubernetes
NODE_IP=$(bash ../node_ip.sh)
MASTER_ADDRESS=${NODE_IP}

# 1
# etcd servers
ETCD_SERVERS="$1"
if [ ! $ETCD_SERVERS ]; then
  echo "ENTER ETCD_SERVERS(got by 'etcdctl member list') eg:http://192.168.100.50:2379,http://192.168.100.51:2379,http://192.168.100.52:2379"
  exit 1
fi


rm -rf ${WORK_DIR}
mkdir -p ${WORK_DIR}/config
systemctl stop kube-apiserver.service >/dev/null 2>&1
systemctl stop kube-controller-manager.service >/dev/null 2>&1
systemctl stop kube-scheduler.service >/dev/null 2>&1
systemctl stop kube-proxy.service >/dev/null 2>&1
cp ${DOWNLOAD_DIR}/server/bin/kube-apiserver /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-controller-manager /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-scheduler /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-proxy /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kubectl /usr/bin/



echo "set  kubeconfig ..."
bash conf/kubeconfig.sh ${MASTER_ADDRESS}

echo "set  apiserver ..."
bash conf/kube-apiserver.sh ${MASTER_ADDRESS} ${ETCD_SERVERS}

sleep 5s

echo "set  controller-manager ..."
bash conf/kube-controller-manager.sh ${MASTER_ADDRESS}

echo "set  scheduler ..."
bash conf/kube-scheduler.sh ${MASTER_ADDRESS}

echo "set proxy ..."
bash conf/kube-proxy.sh ${MASTER_ADDRESS} ${NODE_IP}

echo "install success ..."
