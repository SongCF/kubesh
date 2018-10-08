#!/bin/bash


LOCAL_IP=$(bash ../node_ip.sh)

# 1
# node name
ETCD_NAME="$1"
if [ ! $ETCD_NAME ]; then
  echo "ENTER ETCD_NAME eg:etcd01"
  exit 1
fi

# 2
# cluster state
if [ ! "$2" ]; then
  echo "ENTER Node level: master/node"
  exit 1
fi
CLUSTER_STATE="existing"
if [ "$2" == "master" ]; then
	CLUSTER_STATE="new"
fi

# 3
# cluster list
CLUSTER_LIST="${ETCD_NAME}=http://${LOCAL_IP}:2380"
if [ "$CLUSTER_STATE" == "existing" ]; then
	if [ ! "$3" ]; then
		echo "ENTER ETCD_INITIAL_CLUSTER, got it by run add_node.sh at master."
		exit 1
	else 
		CLUSTER_LIST="$3"
	fi
fi


source define.sh


mkdir -p /usr/lib/systemd/system/
systemctl stop etcd.service >/dev/null 2>&1

rm -r ${WORK_DIR} >/dev/null 2>&1
mkdir -p ${WORK_DIR}
cp ${DOWNLOAD_DIR}/etcd /usr/bin/
cp ${DOWNLOAD_DIR}/etcdctl /usr/bin/


# etcd.conf
cat <<EOF >${WORK_DIR}/etcd.conf
# [member]
# 节点名称
ETCD_NAME="${ETCD_NAME}"
# 数据存放位置
ETCD_DATA_DIR="${WORK_DIR}/default.etcd"
# 监听其他 Etcd 实例的地址
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
# 监听客户端地址
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"

#[cluster]
# 通知其他 Etcd 实例地址
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://${LOCAL_IP}:2380"
# 初始化集群内节点地址
ETCD_INITIAL_CLUSTER="${CLUSTER_LIST}"
# 初始化集群状态 
ETCD_INITIAL_CLUSTER_STATE="${CLUSTER_STATE}"
# 初始化集群 token
ETCD_INITIAL_CLUSTER_TOKEN="20182199-k8s-etcd-cluster"
# 通知 客户端地址
ETCD_ADVERTISE_CLIENT_URLS="http://${LOCAL_IP}:2379"
EOF

# etcd.service
cat <<EOF >/usr/lib/systemd/system/etcd.service
[Unit]
Description=Etcd Server
After=network.target

[Service]
Type=notify
WorkingDirectory=${WORK_DIR}
EnvironmentFile=-${WORK_DIR}/etcd.conf
ExecStart=/usr/bin/etcd \\
	--name=\${ETCD_NAME} \\
	--data-dir=\${ETCD_DATA_DIR} \\
	--listen-peer-urls=\${ETCD_LISTEN_PEER_URLS} \\
	--listen-client-urls=\${ETCD_LISTEN_CLIENT_URLS} \\
	--advertise-client-urls=\${ETCD_ADVERTISE_CLIENT_URLS} \\
	--initial-advertise-peer-urls=\${ETCD_INITIAL_ADVERTISE_PEER_URLS} \\
	--initial-cluster=\${ETCD_INITIAL_CLUSTER} \\
	--initial-cluster-token=\${ETCD_INITIAL_CLUSTER_TOKEN} \\
	--initial-cluster-state=\${ETCD_INITIAL_CLUSTER_STATE} \\
	--auto-compaction-retention=1

[Install]
WantedBy=multi-user.target
EOF


# start
systemctl daemon-reload
systemctl enable etcd.service
systemctl start etcd.service
etcdctl cluster-health

