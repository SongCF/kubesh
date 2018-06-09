#!/bin/bash

#不同云厂商 内网/外网 网卡名字不同，请根据自己的情况更改eth0
IP=$(ip addr |grep inet |grep -v inet6 |grep eth1 |awk '{print $2}' |awk -F "/" '{print $1}')
echo $IP