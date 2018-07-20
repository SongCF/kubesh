#!/bin/bash

K8S_VER=v1.11.1
DOWNLOAD_SERVER_URL=https://dl.k8s.io/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz
DOWNLOAD_CLIENT_URL=https://dl.k8s.io/${K8S_VER}/kubernetes-client-linux-amd64.tar.gz
DOWNLOAD_NODE_URL=https://dl.k8s.io/${K8S_VER}/kubernetes-node-linux-amd64.tar.gz

SAVE_DIR=./kubernetes-download

rm -f ${SAVE_DIR}/../kubernetes-server-linux-amd64.tar.gz 
rm -f ${SAVE_DIR}/../kubernetes-client-linux-amd64.tar.gz 
rm -f ${SAVE_DIR}/../kubernetes-node-linux-amd64.tar.gz
rm -rf ${SAVE_DIR}
mkdir -p ${SAVE_DIR}

curl -L ${DOWNLOAD_SERVER_URL} -o ${SAVE_DIR}/../kubernetes-server-linux-amd64.tar.gz
curl -L ${DOWNLOAD_CLIENT_URL} -o ${SAVE_DIR}/../kubernetes-client-linux-amd64.tar.gz
curl -L ${DOWNLOAD_NODE_URL} -o ${SAVE_DIR}/../kubernetes-node-linux-amd64.tar.gz

tar xzvf ${SAVE_DIR}/../kubernetes-server-linux-amd64.tar.gz -C ${SAVE_DIR}
tar xzvf ${SAVE_DIR}/../kubernetes-client-linux-amd64.tar.gz -C ${SAVE_DIR}
tar xzvf ${SAVE_DIR}/../kubernetes-node-linux-amd64.tar.gz -C ${SAVE_DIR}

rm -f ${SAVE_DIR}/../kubernetes-server-linux-amd64.tar.gz
rm -f ${SAVE_DIR}/../kubernetes-client-linux-amd64.tar.gz
rm -f ${SAVE_DIR}/../kubernetes-node-linux-amd64.tar.gz

# 删掉不必要的文件
# mv ${SAVE_DIR} ${SAVE_DIR}tmp
# mkdir -p ${SAVE_DIR}/server/bin
# cp ${SAVE_DIR}tmp/server/bin/kube-apiserver ${SAVE_DIR}/server/bin/
# cp ${SAVE_DIR}tmp/server/bin/kube-controller-manager ${SAVE_DIR}/server/bin/
# cp ${SAVE_DIR}tmp/server/bin/kube-scheduler ${SAVE_DIR}/server/bin/
# cp ${SAVE_DIR}tmp/server/bin/kube-proxy ${SAVE_DIR}/server/bin/
# cp ${SAVE_DIR}tmp/server/bin/kubectl ${SAVE_DIR}/server/bin/
# cp ${SAVE_DIR}tmp/server/bin/kubelet ${SAVE_DIR}/server/bin/
# rm -rf ${SAVE_DIR}tmp