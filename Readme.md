k8s集群安装脚本
===============

1. k8s集群二进制安装方法，不使用kubeamin，官方对kubeadmin的解释是不适用于大规模集群，仅用于快速搭建测试集群(截止目前v1.10，不清楚未来是什么态度)。
2. 各组建的安装需要下载二进制文件，更改download.sh中的版本号，下载当前最新的版本。

# 使用方法

1. 更改 `node_ip.sh` 脚本中的网卡名字，该脚本用于识别本机IP，你的集群使用内网或外网IP需要改为对应的网卡名称
2. 安装Etcd集群，步骤参考 etcd/readme.md
3. 安装Docker，步骤参考 docker/readme.md
4. 安装k8s集群，步骤参考 k8s/readme.md

# 常用命令

1.Create a cluster
minikube version
minikube start
kubectl version
kubectl cluster-info
kubectl get nodes

2.Deploy an App
kubectl get nodes --help
kubectl run DEPLOYMENT_NAME --image=mysql:5.7 --port=8080
kubectl get deployments
kubectl get pods

3.Explore your App
* kubectl get - list resources
* kubectl describe - show detailed information about a resource
* kubectl logs - print the logs from a container in a pod
* kubectl exec - execute a command on a container in a pod
kubectl proxy

4.Expose your App publicly
kubectl get services
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl describe services/kubernetes-bootcamp
kubectl get pods -l run=kubernetes-bootcamp
kubectl get services -l run=kubernetes-bootcamp
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
kubectl label pod $POD_NAME app=v1
kubectl describe pods $POD_NAME
kubectl get pods -l app=v1
kubectl delete service -l run=kubernetes-bootcamp
kubectl exec -ti $POD_NAME curl localhost:8080

5.Scale your App
kubectl scale deployments/kubernetes-bootcamp --replicas=4
kubectl get pods -o wide
kubectl describe deployments/kubernetes-bootcamp
kubectl describe services/kubernetes-bootcamp

6.Update your App
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
kubectl rollout status deployments/kubernetes-bootcamp //验证是否更新完成
kubectl rollout undo deployments/kubernetes-bootcamp //取消更新/回退



# 参考文档
- [serviced 配置](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [k8s adm 安装脚本](http://sealyun.com/pro/products/?from=k8s)
- [k8s 带证书配置](http://blog.51cto.com/tryingstuff/2120374)
- [k8s 不带证书](https://blog.csdn.net/chen798213337/article/details/78501042)
