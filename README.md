# prophet
部署kubernetes基础组件

prophet所安装的组件为支撑起最基本的分布式训练的最精简组件：

- gpu-operator
- calico
- coredns
- dns-autoscaler
- kube-apiserver
- kube-controller-manager
- kube-proxy
- kube-scheduler
- nginx-proxy
- nfs-client-provisioner

使用prophet可以解决国内防火墙的问题，以及使用kubespray下载到的组件繁多复杂的问题。功能性很强
的相关组件，也会陆续加入。


### 安装要求

单节点kubernetes集群: H（表示远程安装控制节点）、S（表示主机名称）
多节点kubernetes集群：H（表示远程安装控制节点）、M0（表示master节点）、M1（表示worker节点）
