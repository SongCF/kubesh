#!/bin/bash


source define.sh

# 1 
# master address
MASTER_ADDRESS="$1"
if [ ! $MASTER_ADDRESS ]; then
  echo "ENTER MASTER_ADDRESS eg:192.168.1.2"
  exit 1
fi


# 2
# node address
NODE_IP="$2"
if [ ! $NODE_IP ]; then
  echo "ENTER NODE_IP eg:192.168.1.100"
  exit 1
fi



# proxy service
cat <<EOF >/usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Proxy
After=network.target

[Service]
ExecStart=/usr/bin/kube-proxy \
--master=http://${MASTER_ADDRESS}:${APISERVER_INSECURE_PORT} \
--hostname-override=${NODE_IP} \
--logtostderr=false \
--log-dir=${LOG_DIR} \
--v=2
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy
systemctl status kube-proxy
