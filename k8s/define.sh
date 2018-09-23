
# download
DOWNLOAD_DIR=./kubernetes-download
VER=v1.11.1
DOWNLOAD_URL="https://dl.k8s.io/${VER}/kubernetes-server-linux-amd64.tar.gz"
# setup dir
WORK_DIR=/usr/local/kubernetes
LOG_DIR=${WORK_DIR}/log

# apiserver
SERVICE_CLUSTER_IP_RANGE="192.168.0.0/16"
DNS_SERVER_IP="192.168.0.2"
ADMISSION_CONTROL="NamespaceLifecycle,LimitRanger,SecurityContextDeny,DefaultStorageClass,ResourceQuota"
APISERVER_PORT=6443
APISERVER_INSECURE_PORT=8080

CLUSTER_NAME=clusterk8s
CONTEXT_NAME=contextk8s