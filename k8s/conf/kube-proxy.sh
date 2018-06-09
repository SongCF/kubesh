#!/bin/bash



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


# proxy conf
cat <<EOF >/data/kubernetes/config/kube-proxy.conf
KUBE_MASTER="--master=http://${MASTER_ADDRESS}:6443"
NODE_HOSTNAME="--hostname-override=${NODE_IP}"
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_DIR="--log-dir=/data/kubernetes/log"
KUBE_LOG_LEVEL="--v=2"
EOF


# proxy service
cat <<EOF >/usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Proxy
After=network.target

[Service]
EnvironmentFile=/data/kubernetes/config/kube-proxy.conf
ExecStart=/usr/local/kubernetes/bin/kube-proxy \\
    \${KUBE_MASTER}         \\
    \${NODE_HOSTNAME}       \\
    \${KUBE_LOGTOSTDERR}    \\
    \${KUBE_LOG_DIR}        \\
    \${KUBE_LOG_LEVEL}
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-proxy
systemctl restart kube-proxy
