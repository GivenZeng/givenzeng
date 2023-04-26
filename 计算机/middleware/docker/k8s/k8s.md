开始master节点的初始化工作，注意这边的--pod-network-cidr=10.244.0.0/16，是k8的网络插件所需要用到的配置信息，用来给node分配子网段，我这边用到的网络插件是flannel，就是这么配，其他的插件也有相应的配法，官网上都有详细的说明，具体参考这个网页

# 安装
```
sudo apt install kubeadm
# 设置镜像仓库，不然kubeadm会拉取google自己的仓库
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers
```


启动完成会输出 以下内容，即表示本地节点已经启动完成。如果需要
```sh
Your Kubernetes control-plane has initialized successfully!
```

如果需要当前及其用户通过kubectl访问，需要进行以下设置
```sh
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

如果需要部署一个pod，可以通过以下命令。配置文件可参考 https://kubernetes.io/docs/concepts/cluster-administration/addons/
```sh
kubectl apply -f [podnetwork].yaml
```

如果需要将新节点加入到本集群，需要运行以下命令。（下述密钥仅是样例）
```sh
kubeadm join 10.227.74.4:6443 --token vsv3eq.wbdf2dvnfg4rbi17 \
    --discovery-token-ca-cert-hash sha256:01585d0bd640cbaf3b608a060d8ec0e95add1a2bf7be32ca45320c076cadbe62
```

如果使用kubectl get pods -n kube-system 发现服务coredns未ready，则使用以下命令，其中kube-system为命名空间

```
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sudo kubectl apply -f ./kube-flannel.yml
```

 获取核心组件的状态(该命令已经被废弃，不应使用)
 ```sh
  kubectl get componentstatus
 ```


获取pod 状态
```
zengjiwen at n227-074-004 in /etc/kubernetes/manifests
$ kubectl get pods -n kube-system
NAME                                   READY   STATUS             RESTARTS   AGE
coredns-54d67798b7-7mwq9               1/1     Running            0          34d
coredns-54d67798b7-b6626               1/1     Running            0          34d
etcd-n227-074-004                      1/1     Running            0          34d
kube-apiserver-n227-074-004            1/1     Running            0          34d
kube-controller-manager-n227-074-004   1/1     Running            0          34d
kube-flannel-ds-4gpkf                  1/1     Running            0          30d
kube-proxy-bdskk                       1/1     Running            0          34d
kube-scheduler-n227-074-004            1/1     Running            0          34d
metrics-server-774b56d589-ccp4w        0/1     ImagePullBackOff   0          30d
```

# 使用
默认的master节点是不能调度应用pod的，所以我们还需要给master节点打一个污点标记
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

```
sudo kubectl apply -f your_service_.yaml -v=8 // -v=8输出具体细节
```

# UI
```
wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl apply -f recommended.yaml
```
# 核心组件
kudeadm的思路，是通过把k8主要的组件容器化，来简化安装过程。这时候你可能就有一个疑问，这时候k8集群还没起来，如何来部署pod？难道直接执行docker run？当然是没有那么low，其实在kubelet的运行规则中，有一种特殊的启动方法叫做“静态pod”（static pod），只要把pod定义的yaml文件放在指定目录下，当这个节点的kubelet启动时，就会自动启动yaml文件中定义的pod。从这个机制你也可以发现，为什么叫做static pod，因为这些pod是不能调度的，只能在这个节点上启动，并且pod的ip地址直接就是宿主机的地址。在k8中，放这些预先定义yaml文件的位置是/etc/kubernetes/manifests，我们来看一下
```sh
zengjiwen at n227-074-004 in /etc/kubernetes/manifests
$ ll
total 16K
-rw------- 1 root root 2.2K Dec 27 17:12 etcd.yaml
-rw------- 1 root root 3.8K Dec 27 17:12 kube-apiserver.yaml
-rw------- 1 root root 3.3K Dec 27 17:12 kube-controller-manager.yaml
-rw------- 1 root root 1.4K Dec 27 17:12 kube-scheduler.yaml
```

- etcd：k8s的数据库，所有的集群配置信息、密钥、证书等等都是放在这个里面，所以生产上面一般都会做集群
- kube-apiserver: k8的restful api入口，所有其他的组件都是通过api-server来操作kubernetes的各类资源，可以说是k8最底层的组件
- kube-controller-manager: 负责管理容器pod的生命周期
- kube-scheduler: 负责pod在集群中的调度

# 其他
- 输出node细节
```
kubectl describe node
Name:               n227-074-004
Roles:              control-plane,master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=n227-074-004
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/control-plane=
                    node-role.kubernetes.io/master=
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"62:d9:d5:20:5e:34"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.227.74.4
                    kubeadm.alpha.kubernetes.io/cri-socket: /var/run/dockershim.sock
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
...
```
# 污点
见 https://www.cnblogs.com/baozexu/p/13705680.html
```
# 给节点n227-074-004添加污点node-type=production:NoSchedule(污点是一个键值对k=v)
kubectl taint nodes n227-074-004 node-type=production:NoSchedule
# 给所有节点添加污点
kubectl taint nodes --all node-type=production:NoSchedule
# 给所有节点移除污点（在污点后增加-）
kubectl taint nodes --all node-type=production:NoSchedule-
# 给所有节点移除某键名污点（在污点键增加-）
kubectl taint nodes --all node-type=production-
```

# 端口
1. nodePort
　外部机器可访问的端口。
比如一个Web应用需要被其他用户访问，那么需要配置type=NodePort，而且配置nodePort=30001，那么其他机器就可以通过浏览器访问scheme://node:30001访问到该服务，例如http://node:30001。
　例如MySQL数据库可能不需要被外界访问，只需被内部服务访问，那么不必设置NodePort

2. targetPort
　容器的端口（最根本的端口入口），与制作容器时暴露的端口一致（DockerFile中EXPOSE），例如docker.io官方的nginx暴露的是80端口。
　docker.io官方的nginx容器的DockerFile参考https://github.com/nginxinc/docker-nginx

3. port
　kubernetes中的服务之间访问的端口，尽管mysql容器暴露了3306端口（参考https://github.com/docker-library/mysql/的DockerFile），但是集群内其他容器需要通过33306端口访问该服务，外部机器不能访问mysql服务，因为他没有配置NodePort类型

# refer
- kubeadm https://www.jianshu.com/p/70efa1b853f5
- taint https://www.cnblogs.com/baozexu/p/13705680.html