#!/bin/bash

K8S_VER=v1.10.3
DOWNLOAD_URL=https://storage.googleapis.com/kubernetes-release/release/${K8S_VER}/kubernetes-server-linux-amd64.tar.gz
SAVE_DIR=./kubernetes-download

rm -f ${SAVE_DIR}/../kubernetes-${K8S_VER}-linux-amd64.tar.gz
rm -rf ${SAVE_DIR}
mkdir -p ${SAVE_DIR}

curl -L ${DOWNLOAD_URL} -o ${SAVE_DIR}/../kubernetes-${K8S_VER}-linux-amd64.tar.gz
tar xzvf ${SAVE_DIR}/../kubernetes-${K8S_VER}-linux-amd64.tar.gz -C ${SAVE_DIR} --strip-components=1
rm -f ${SAVE_DIR}/../kubernetes-${K8S_VER}-linux-amd64.tar.gz

# 删掉不必要的文件
mv ${SAVE_DIR} ${SAVE_DIR}tmp
mkdir -p ${SAVE_DIR}/server/bin
cp ${SAVE_DIR}tmp/server/bin/kube-apiserver ${SAVE_DIR}/server/bin/
cp ${SAVE_DIR}tmp/server/bin/kube-controller-manager ${SAVE_DIR}/server/bin/
cp ${SAVE_DIR}tmp/server/bin/kube-scheduler ${SAVE_DIR}/server/bin/
cp ${SAVE_DIR}tmp/server/bin/kube-proxy ${SAVE_DIR}/server/bin/
cp ${SAVE_DIR}tmp/server/bin/kubectl ${SAVE_DIR}/server/bin/
cp ${SAVE_DIR}tmp/server/bin/kubelet ${SAVE_DIR}/server/bin/
rm -rf ${SAVE_DIR}tmp