#!/bin/bash


cp -r ../etcd-download ./etcd-download

chmod +x ./etcd-download/etcd
chmod +x ./etcd-download/etcdctl

docker build -t etcd:v3.2.6 .
