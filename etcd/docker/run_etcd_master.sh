#!/bin/bash

if [ ! -n "$1" ] ;then
    echo "you have not input environment! dev/test/rel"
    exit 1
fi
ENV=$1


ETCDP0=2379
ETCDP1=2380
if [ "$ENV" == "dev" ];then
    echo "dev"
    ETCDP0=22379
    ETCDP1=22380
elif [ "$ENV" == "test" ];then
    echo "test"
    ETCDP0=12379
    ETCDP1=12380
elif [ "$ENV" == "rel" ];then
    echo "rel"
    ETCDP0=2379
    ETCDP1=2380
else
    echo "error env, input: dev/test/rel"
    exit 1
fi


docker run \
  -d \
  -p $ETCDP0:2379 \
  -p $ETCDP1:2380 \
  -e ETCDCTL_API=3 \
  --name $ENV-etcd \
  --network=net-cvd-$ENV \
  --volume=/data/$ENV/etcd:/data \
  etcd:v3.2.6 \
  /bin/etcd \
  --name my-etcd-1 \
  --data-dir /data \
  --listen-client-urls http://0.0.0.0:2379 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --initial-cluster my-etcd-1=http://0.0.0.0:2380 \
  --initial-cluster-token my-etcd-token \
  --initial-cluster-state new

sleep 2s

docker logs $ENV-etcd

docker exec $ENV-etcd /bin/etcdctl version
