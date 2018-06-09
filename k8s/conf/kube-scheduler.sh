#!/bin/bash


# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi


# kube scheduler conf
cat <<EOF >/data/kubernetes/config/kube-scheduler.conf
KUBE_MASTER="--master=http://${MASTER_ADDRESS}:6443"
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_DIR="--log-dir=/data/kubernetes/log"
KUBE_LOG_LEVEL="--v=2"
EOF


# kube scheduler service
cat <<EOF >/usr/lib/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes
After=kube-apiserver.service 
Requires=kube-apiserver.service

[Service]
EnvironmentFile=/data/kubernetes/config/kube-scheduler.conf
ExecStart=/usr/local/kubernetes/bin/kube-scheduler \\
        \${KUBE_MASTER} \\
        \${KUBE_LOGTOSTDERR} \\
        \${KUBE_LOG_DIR} \\
        \${KUBE_LOG_LEVEL} 
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler
