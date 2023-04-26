### 简介
仓库（Repository ） 是集中存放镜像的地方。

一个容易混淆的概念是注册服务器（Registry ） 。实际上注册服务器是管理仓库的具体服务器，每个服务器上可以有多个仓库，而每个仓库下面有多个镜像。从这方面来说，仓库可以被认为是一个具体的项目或目录。例如对于仓库地址 dl.dockerpool.com/ubuntu 来说， dl.dockerpool.com 是注册服务器地址， ubuntu 是仓库名。
大部分时候，并不需要严格区分这两者的概念。


#### Docker Hub
目前 Docker 官方维护了一个公共仓库 Docker Hub，其中已经包括了数量超过 15,000 的镜像。大部分需求都可以通过在 Docker Hub 中直接下载镜像来实现。

你可以注册一个docker账号，使用以下命令登陆或者登出
```
docker login
docker logout
```

拉取镜像
```
docker search image_name   // 返回可以使用的镜像
docker pull image_name[:tag]
```

根据是否是官方提供，可将镜像资源分为两类。

一种是类似 centos 这样的镜像，被称为基础镜像或根镜像。这些基础镜像由 Docker 公司创建、验证、支持、提供。这样的镜像往往使用单个单词作为名字。

还有一种类型，比如 tianon/centos 镜像，它是由 Docker 的用户创建并维护的，往往带有用户名称前缀。可以通过前缀 username/ 来指定使用某个用户提供的镜像，比如 tianon 用户

### 推送镜像
```
docker push image[:tag]
```


### 自动创建


### 私有仓库
#### 创建一个私有仓库
```
docker run -d -p 5000:5000 --restart=always --name registry registry
```

这将使用官方的 registry 镜像来启动私有仓库。默认情况下，仓库会被创建在容器的/var/lib/registry 目录下。你可以通过 -v 参数来将镜像文件存放在本地的指定路径。例如下面的例子将上传的镜像放到本地的 /opt/data/registry 目录：
```
docker run -d \
	-p 5000:5000 \
	-v /opt/data/registry:/var/lib/registry \
	registry
```
这里面涉及到一些数据卷的操作，你后面会接触到。


#### 上传，下载，删除
```
docker push localhost:port/img[:tag]

curl localhost:port/v2/_catalog   //查看仓库里面有什么镜像

```
私有仓库的深入使用请自行查阅相关文档
