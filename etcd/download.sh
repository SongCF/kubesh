#!/bin/bash

ETCD_VER=v3.3.5

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/coreos/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}
SAVE_DIR=./etcd-download

rm -f ${SAVE_DIR}/../etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf ${SAVE_DIR}
mkdir -p ${SAVE_DIR}

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o ${SAVE_DIR}/../etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf ${SAVE_DIR}/../etcd-${ETCD_VER}-linux-amd64.tar.gz -C ${SAVE_DIR} --strip-components=1
rm -f ${SAVE_DIR}/../etcd-${ETCD_VER}-linux-amd64.tar.gz

${SAVE_DIR}/etcd --version
# <<COMMENT
# etcd Version: 3.3.5
# Git SHA: 70c872620
# Go Version: go1.9.6
# Go OS/Arch: linux/amd64
# COMMENT

ETCDCTL_API=3 ${SAVE_DIR}/etcdctl version
# <<COMMENT
# etcdctl version: 3.3.5
# API version: 3.3
# COMMENT
