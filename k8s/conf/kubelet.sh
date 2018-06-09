#!/bin/bash


# 1
# node address
NODE_IP="$1"
if [ ! $NODE_IP ]; then
  echo "ENTER NODE_IP eg:192.168.1.100"
  exit 1
fi


# kebelet conf
cat <<EOF >/usr/local/kubernetes/config/kubelet.conf
KUBE_LOGTOSTDERR="--logtostderr=true"
KUBE_LOG_DIR="--log-dir=/data/kubernetes/log"
KUBE_LOG_LEVEL="--v=2"

NODE_ADDRESS="--address=0.0.0.0"
NODE_PORT="--port=10250"
NODE_HOSTNAME="--hostname-override=${NODE_IP}"
KUBE_ALLOW_PRIV="--allow-privileged=false"

KUBELET_DNS_IP="--cluster-dns=${DNS_SERVER_IP}"
KUBELET_DNS_DOMAIN="--cluster-domain=${DNS_DOMAIN}"

KUBE_POD_INFRA_CONTAINER_IMAGE="--pod-infra-container-image=gcr.io/google_containers/pause-amd64:3.0"
KUBE_CONFIG="--kubeconfig=/data/kubernetes/config/kubeconfig.conf"
EOF


# kubelet service
cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.service
Requires=docker.service

[Service]
EnvironmentFile=/data/kubernetes/config/kubelet.conf
ExecStart=/usr/local/kubernetes/bin/kubelet \\
    \${KUBE_LOGTOSTDERR}                \\
    \${KUBE_LOG_DIR}                    \\
    \${KUBE_LOG_LEVEL}                  \\
    \${NODE_ADDRESS}                    \\
    \${NODE_PORT}                       \\
    \${NODE_HOSTNAME}                   \\
    \${KUBE_ALLOW_PRIV}                 \\
    \${KUBE_POD_INFRA_CONTAINER_IMAGE}" \\
    \${KUBE_CONFIG}	
Restart=on-failure
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet
