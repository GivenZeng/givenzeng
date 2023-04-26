Docker 允许通过外部访问容器或容器互联的方式来提供网络服务。

### 建立网络
建立一个名字为my-net的网络
```
docker network create -d bridge my-net
```

-d 参数指定 Docker 网络类型，有 bridge overlay 。其中 overlay 网络类型用于Swarm mode


### 往网络添加容器
```
docker run -it --rm --name busybox1 --network my-net busybox sh
docker run -it --rm --name busybox2 --network my-net busybox sh
```

### 连接
在busybox1中ping一下busybox2即可
```
ping bysybox2
```

docker在容器添加到网络的时候，会将网络中的其他容器的domain、host注册到容器的网络配置里面。一般默认domain为容器名字，因此可以使用容器名来连接其他容器

### 配置dns
在容器中使用mount命令可以看见
```
/dev/disk/by-uuid/1fec...ebdf on /etc/hostname type ext4 ...
/dev/disk/by-uuid/1fec...ebdf on /etc/hosts type ext4 ...
tmpfs on /etc/resolv.conf type tmpfs ...
```
这种机制可以让宿主主机 DNS 信息发生更新后，所有 Docker 容器的 DNS 配置通过/etc/resolv.conf 文件立刻得到更新。

配置全部容器的 DNS ，也可以在 /etc/docker/daemon.json 文件中增加以下内容来设置。
```
{
	"dns" : [
		"114.114.114.114",
		"8.8.8.8"
	]
}
```
这样每次启动的容器 DNS 自动配置为 114.114.114.114 和 8.8.8.8 。使用以下命令来证明其已经生效

--dns=IP_ADDRESS 添加 DNS 服务器到容器的 /etc/resolv.conf 中，让容器用这个服务器来解析所有不在 /etc/hosts 中的主机名。

-dns-search=DOMAIN 设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的主机时，DNS 不仅搜索 host，还会搜索 host.example.com 。

### 使用--link


```
docker run -it --link container1_name:container1_alias --name my_container image
```
你可以在my_container中ping container1_alias
