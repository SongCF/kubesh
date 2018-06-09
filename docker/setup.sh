#!/bin/bash

DOCKER_DIR=./etcd-download
WORK_DIR=/data/docker


mkdir -p /usr/lib/systemd/system/
systemctl stop docker.service >/dev/null 2>&1
cp ${DOCKER_DIR}/* /usr/bin/
rm -r ${WORK_DIR}
mkdir -p ${WORK_DIR}




cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
[Service]
Type=notify
EnvironmentFile=-${WORK_DIR}/docker.conf
ExecStart=/usr/bin/dockerd \
                -H tcp://0.0.0.0:4243 \
                -H unix:///var/run/docker.sock

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl status docker

systemctl enable docker
systemctl restart docker

echo "## docker version"
docker version
