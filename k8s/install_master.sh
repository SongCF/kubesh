#!/bin/bash

NODE_IP=$(bash ../node_ip.sh)
if [ ! ${NODE_IP}} ]; then
  echo "node_ip.sh failed"
  exit 1
fi
MASTER_ADDRESS=${NODE_IP}


# 1
# etcd servers
ETCD_SERVERS="$1"
if [ ! $ETCD_SERVERS ]; then
  echo "ENTER ETCD_SERVERS(got by 'etcdctl member list') eg:http://192.168.100.50:2379,http://192.168.100.51:2379,http://192.168.100.52:2379"
  exit 1
fi


source define.sh


rm -rf ${WORK_DIR}
mkdir -p ${WORK_DIR}/config
mkdir -p ${WORK_DIR}/log
systemctl stop kube-apiserver.service >/dev/null 2>&1
systemctl stop kube-controller-manager.service >/dev/null 2>&1
systemctl stop kube-scheduler.service >/dev/null 2>&1
systemctl stop kubelet.service >/dev/null 2>&1
systemctl stop kube-proxy.service >/dev/null 2>&1
cp ${DOWNLOAD_DIR}/server/bin/kube-apiserver /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-controller-manager /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-scheduler /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kubelet /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kube-proxy /usr/bin/
cp ${DOWNLOAD_DIR}/server/bin/kubectl /usr/bin/



echo -e "\n\n\n--------------------------------------------------"
echo "set  apiserver ..."
echo "bash conf/kube-apiserver.sh ${MASTER_ADDRESS} ${ETCD_SERVERS}"
bash conf/kube-apiserver.sh ${MASTER_ADDRESS} ${ETCD_SERVERS}

sleep 5s

echo -e "\n\n\n--------------------------------------------------"
echo "set  controller-manager ..."
echo "bash conf/kube-controller-manager.sh ${MASTER_ADDRESS}"
bash conf/kube-controller-manager.sh ${MASTER_ADDRESS}

echo -e "\n\n\n--------------------------------------------------"
echo "set  scheduler ..."
echo "bash conf/kube-scheduler.sh ${MASTER_ADDRESS}"
bash conf/kube-scheduler.sh ${MASTER_ADDRESS}

echo -e "\n\n\n--------------------------------------------------"
echo "set kubelet ..."
echo "bash conf/kubelet.sh ${MASTER_ADDRESS} ${NODE_IP}"
bash conf/kubelet.sh ${MASTER_ADDRESS} ${NODE_IP}

echo -e "\n\n\n--------------------------------------------------"
echo "set  proxy ..."
echo "bash conf/kube-proxy.sh ${MASTER_ADDRESS} ${NODE_IP}"
bash conf/kube-proxy.sh ${MASTER_ADDRESS} ${NODE_IP}

echo -e "\n\n\n--------------------------------------------------"
ps -aux |grep kube
echo -e "\nsetup end."
