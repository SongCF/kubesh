#!/bin/bash

# https://docs.docker.com/install/linux/docker-ce/binaries/

VER=18.03.1

DOWNLOAD_URL=https://download.docker.com/linux/static/stable/x86_64/docker-${VER}-ce.tgz
TAR=docker-${VER}-ce.tgz
SAVE_DIR=./docker-download

rm -f ${SAVE_DIR}/../${TAR}
rm -rf ${SAVE_DIR}
mkdir -p ${SAVE_DIR}

curl -L ${DOWNLOAD_URL} -o ${SAVE_DIR}/../${TAR}
tar xzvf ${SAVE_DIR}/../${TAR} -C ${SAVE_DIR} --strip-components=1
rm -f ${SAVE_DIR}/../${TAR}
