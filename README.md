# prophet
部署kubernetes基础组件

#测试贡献

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

目前版本只支持多机部署

多节点kubernetes集群：H（表示远程安装控制节点）、M0（表示master节点）、M1（表示worker节点）

**H**
```
git clone https://github.com/ReyRen/prophet.git
可以免密登录到M和S的所有机器上,M/S的root密码设置根据config.yaml中指定的一致
```
**S/M0**
```
SSH服务正常启动
所有master和worker机器有同样的SSH用户名和密码，且该SSH用户有sudo权限
apt install ntp # NTP已被成功开启
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache madison docker-ce
apt install docker-ce=5:19.03.14~3-0~ubuntu-bionic
apt install docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic
```
**M1**
```
apt install nfs-common resolvconf
bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
reboot
apt install ntp # NTP已被成功开启
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache madison docker-ce
apt install docker-ce=5:19.03.14~3-0~ubuntu-bionic
apt install docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic
不要进行nvidia-docker/nvidia-driver/cuda的安装
```
**M0**
接下来，请编辑<prophet-code-dir>/contrib/kubespray/config目录下的layout.yaml和config.yaml文件,
这两个文件分别指定了集群的机器组成和自定义设置.
```
cd <prophet-code-dir>/contrib/kubespray
/bin/bash quick-start-kubespray.sh
```
