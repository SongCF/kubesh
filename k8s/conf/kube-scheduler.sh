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
KUBE_SCHEDULER_ARGS=" \
--master=http://${MASTER_ADDRESS}:6444 \
--logtostderr=true \
--log-dir=/data/kubernetes/log \
--v=2"
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
ExecStart=/usr/bin/kube-scheduler \
--master=http://${MASTER_ADDRESS}:6444 \
--logtostderr=true \
--log-dir=/data/kubernetes/log \
--v=2
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl restart kube-scheduler
systemctl status kube-scheduler
