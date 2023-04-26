Dockerfile是由一系列命令和参数构成的脚本，这些命令应用于基础镜像并最终创建一个新的镜像。

例子
```
FROM node:latest
MAINTAINER my_name
ADD ./my_project /code
VOLUME ["/data1", "/data2"]
WORKDIR /code
RUN apt-get install mysql
EXPOSE 6777
ENV SRC_URL www.xxxxxxxxxxx.com/xxxxxxx
RUN wget $SRC_URL
CMD ["node","bin/www"]
```

- FROM: 指定基础镜像，如果本地不存在基础镜像，会自动从远程仓库拉取。FROM必须是Dockerfile中除了注释外的第一行语句。
- MAINTAINER: 用于指定镜像的构建者，当发现坑的时候可以找他
- ADD： 将本机的文件或目录复制到镜像的某个目录下，在后续的构建命令和容器运行中可以在容器中访问该目录
- WORKDIR： 指定后续的构建命令的工作路径
- RUN: 在镜像中运行某条命令，如安装相关的依赖库
- CMD：用于指定镜像运行时的第一条命令。CMD只能出现一次，如果出现多次，前面的会被覆盖
```
    CMD ["executable","param1","param2"] 使用 exec 执行，推荐方式；

    CMD command param1 param2 在 /bin/sh 中执行，提供给需要交互的应用；

    CMD ["param1","param2"] 提供给 ENTRYPOINT 的默认参数；
```
- EXPOSE：暴露容器的端口，其他容器可以通过该端口访问本容器提供的服务，前提是这些容器在同一个网络中，例子中暴露了6777端口
- ENV: 设置环境变量。这些环境变量可以在后续的构建命令中使用，当运行容器时，也可以在容器中使用这些变量
- COPY: 将本机的文件或目录复制到镜像的某个目录下，在后续的构建命令和容器运行中可以在容器中访问该目录。该命令作用同ADD，只是ADD更加强大，如：当拷贝的是压缩包，ADD会自动解压
- ENTRYPOINT: 容器启动后执行的命令。每个 Dockerfile 中只能有一个ENTRYPOINT，当指定多个时，只有最后一个生效。(CMD指令指定的容器启动时命令可以被docker run指定的命令覆盖；而ENTRYPOINT指令指定的命令不能被覆盖，而是将docker run指定的参数当做ENTRYPOINT指定命令的参数。)
```    
    ENTRYPOINT ["executable", "param1", "param2"]

    ENTRYPOINT command param1 param2（shell中执行）
```
- VOLUME: 容器卷是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，将主机目录挂在到容器里面，可以提供很多有用的特性：
	- 数据卷 可以在容器之间共享和重用
	- 对 数据卷 的修改会立马生效
	- 对 数据卷 的更新，不会影响镜像
	- 数据卷 默认会一直存在，即使容器被删除，除非在删除容器的时候使用-v选项： docker rm -v container_id/container_name
	- 注意： 数据卷 的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会隐藏掉，能显示看的是挂载的 数据卷 。因此你的容器目录dir有一个文件为temp.data，如果你在dir挂载了一个数据卷
	- 在Dockerfile中，无法指定主机上对应的目录
，那么你就再也不能读取temp.data，除非你移除该数据卷。

## 构建
```
docker build . -t your_image --no-cache
```
