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
cat <<EOF >/data/kubernetes/config/kube-apiserver.conf
KUBE_ETCD_SERVERS="--etcd-servers=${ETCD_SERVERS}"
KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"
KUBE_API_PORT="--insecure-port=6443"
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE}"
KUBE_ADMISSION_CONTROL="--admission-control=${ADMISSION_CONTROL}"

NODE_PORT="--kubelet-port=10250"
KUBE_ADVERTISE_ADDR="--advertise-address=${MASTER_ADDRESS}"
KUBE_ALLOW_PRIV="--allow-privileged=false"

KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_LEVEL="--v=2"
KUBE_LOG_DIR="--log-dir=/data/kubernetes/log"
EOF


# apiserver service
cat <<EOF >/usr/lib/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=http://github.com/kubernetes/kubernetes
After=network.target
After=etcd.service

[Service]
Type=notify
EnvironmentFile=/data/kubernetes/config/kube-apiserver.conf
ExecStart=/usr/bin/kube-apiserver \\
    \${KUBE_ETCD_SERVERS}        \\
    \${KUBE_API_ADDRESS}         \\
    \${KUBE_API_PORT}            \\
    \${KUBE_SERVICE_ADDRESSES}   \\
    \${KUBE_ADMISSION_CONTROL}   \\
    \${NODE_PORT}                \\
    \${KUBE_ADVERTISE_ADDR}      \\
    \${KUBE_ALLOW_PRIV}          \\
    \${KUBE_LOGTOSTDERR}         \\
    \${KUBE_LOG_LEVEL}           \\
    \${KUBE_LOG_DIR}             
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# start
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl restart kube-apiserver
