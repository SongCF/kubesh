k8s集群安装脚本
===============

1. k8s集群二进制安装方法，不使用kubeamin，官方对kubeadmin的解释是不适用于大规模集群，仅用于快速搭建测试集群(截止目前v1.10，不清楚未来是什么态度)。
2. 各组建的安装需要下载二进制文件，更改download.sh中的版本号，下载当前最新的版本。

# 使用方法
1. 更改 `node_ip.sh` 脚本中的网卡名字，该脚本用于识别本机IP，你的集群使用内网或外网IP需要改为对应的网卡名称
2. 安装Etcd集群，参考 etcd/readme.md
3. 安装Docker，参考 docker/readme.md
4. 安装k8s集群，步骤参考 k8s/readme.md


# 参考文档
- [serviced 配置](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [k8s adm 安装脚本](http://sealyun.com/pro/products/?from=k8s)
- [k8s 带证书配置](http://blog.51cto.com/tryingstuff/2120374)
- [k8s 不带证书](https://blog.csdn.net/chen798213337/article/details/78501042)