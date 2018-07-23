#!/bin/bash



# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi

# 2
# etcd servers
ETCD_SERVERS="$2"
if [ ! $ETCD_SERVERS ]; then
  echo "ENTER ETCD_SERVERS eg:http://192.168.100.50:2379,http://192.168.100.50:2379,http://192.168.100.50:2379"
  exit 1
fi

SERVICE_CLUSTER_IP_RANGE="192.168.0.0/16"
ADMISSION_CONTROL="NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,DefaultStorageClass,ResourceQuota"


# apiserver.conf
mkdir -p /etc/kubernetes/
cat <<EOF >/data/kubernetes/config/kube-apiserver.conf
KUBE_API_ARGS=" \
--storage-backend=etcd3 \
--etcd-servers=${ETCD_SERVERS} \
--bind-address=0.0.0.0 \
--secure-port=6443 \
--insecure-bind-address=0.0.0.0 \
--insecure-port=6444 \
--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
--service-node-port-range=1-65535 \
--enable-admission-plugins=${ADMISSION_CONTROL} \
--allow-privileged=false \
--logtostderr=true \
--log-dir=/data/kubernetes/log \
--v=2"
EOF


# apiserver service
cat <<EOF >/usr/lib/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://kubernetes.io/docs/concepts/overview
After=network.target
After=etcd.service

[Service]
EnvironmentFile=/data/kubernetes/config/kube-apiserver.conf
ExecStart=/usr/bin/kube-apiserver \
--storage-backend=etcd3 \
--etcd-servers=${ETCD_SERVERS} \
--bind-address=0.0.0.0 \
--secure-port=6443 \
--insecure-bind-address=0.0.0.0 \
--insecure-port=6444 \
--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
--service-node-port-range=1-65535 \
--enable-admission-plugins=${ADMISSION_CONTROL} \
--logtostderr=true \
--log-dir=/data/kubernetes/log \
--v=2
Restart=on-failure
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


# start
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver
