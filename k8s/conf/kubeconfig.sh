#!/bin/bash


# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi


KUBE_APISERVER="http://${MASTER_ADDRESS}:6444"

# 设置集群参数
kubectl config set-cluster default-cluster \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/data/kubernetes/config/kubeconfig.conf

kubectl config set-context default-context \
  --cluster=default-cluster \
  --kubeconfig=/data/kubernetes/config/kubeconfig.conf

# 设置默认上下文
kubectl config use-context default-context --kubeconfig=/data/kubernetes/config/kubeconfig.conf
