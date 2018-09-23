#!/bin/bash

source define.sh

TMPTAG=k8s-${VER}.tar.gz
rm -f ${DOWNLOAD_DIR}/../${TMPTAG}
rm -rf ${DOWNLOAD_DIR}
mkdir -p ${DOWNLOAD_DIR}

curl -L ${DOWNLOAD_URL} -o ${DOWNLOAD_DIR}/../${TMPTAG}
tar xzvf ${DOWNLOAD_DIR}/../${TMPTAG} -C ${DOWNLOAD_DIR} --strip-components=1
rm -f ${DOWNLOAD_DIR}/../${TMPTAG}
