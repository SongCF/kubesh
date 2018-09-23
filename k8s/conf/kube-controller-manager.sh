#!/bin/bash


source define.sh

# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi



# controller-manager service
cat <<EOF >/usr/lib/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes
After=kube-apiserver.service 
Requires=kube-apiserver.service

[Service]
ExecStart=/usr/bin/kube-controller-manager \
--master=http://${MASTER_ADDRESS}:${APISERVER_INSECURE_PORT} \
--logtostderr=false \
--log-dir=${LOG_DIR} \
--v=2                
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


# start
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl restart kube-controller-manager
systemctl status kube-controller-manager
