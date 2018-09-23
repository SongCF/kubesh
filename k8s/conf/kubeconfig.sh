#!/bin/bash


source define.sh

# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi

KUBE_APISERVER="http://${MASTER_ADDRESS}:${APISERVER_INSECURE_PORT}"

# 设置集群参数
kubectl config set-cluster ${CLUSTER_NAME} \
  --server=${KUBE_APISERVER} \
  --kubeconfig=${WORK_DIR}/config/kubeconfig.conf

kubectl config set-context ${CONTEXT_NAME} \
  --cluster=${CLUSTER_NAME} \
  --kubeconfig=${WORK_DIR}/config/kubeconfig.conf

# 设置默认上下文
kubectl config use-context ${CONTEXT_NAME} --kubeconfig=${WORK_DIR}/config/kubeconfig.conf
