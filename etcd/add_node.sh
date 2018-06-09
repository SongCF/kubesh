#!/bin/bash


# ectd集群添加节点
# https://blog.csdn.net/yunlilang/article/details/79726424

NODE_NAME="$1"
NODE_ADDR="$2"

if [ ! $NODE_NAME ]; then
  echo "ENTER NODE_NAME eg:etcd05"
  exit 1
fi
if [ ! $NODE_ADDR ]; then
  echo "ENTER NODE_ADDR eg:http://192.168.1.2:2380"
  exit 1
fi


etcdctl member add $NODE_NAME $NODE_ADDR