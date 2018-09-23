#!/bin/bash

DOCKER_DIR=./docker-download
WORK_DIR=/usr/local/docker
groupadd docker

mkdir -p /usr/lib/systemd/system/
systemctl stop docker.service >/dev/null 2>&1

rm -r ${WORK_DIR} >/dev/null 2>&1
mkdir -p ${WORK_DIR}
cp ${DOCKER_DIR}/* /usr/bin/
# ln -sf ${WORK_DIR}/docker /usr/bin/docker



cat <<EOF >/usr/lib/systemd/system/docker.socket
[Unit]
Description=Docker Socket for the API
PartOf=docker.service

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF


cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
WorkingDirectory=${WORK_DIR}
# EnvironmentFile=-${WORK_DIR}/docker.conf
ExecStart=/usr/bin/dockerd -H fd:// \
    --registry-mirror=https://wlathsyw.mirror.aliyuncs.com
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
docker version
