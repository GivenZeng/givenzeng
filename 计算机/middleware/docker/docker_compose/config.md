一下介绍docker-compose文件的语法及相关配置。基本配置同docker的run命令中的参数，如CMD、EXPOSE、VOLUME、EVN等等。

一个docker—compose包含多个服务，每个服务都必须通过 image 指令指定镜像或 build 指令（ 需要 Dockerfile） 等来自动构建生成镜像。

如果使用 build 指令，在 Dockerfile 中设置的选项(例如： CMD , EXPOSE , VOLUME , ENV等) 将会自动被获取，无需在 docker-compose.yml 中再次设置。

#### build
指定 Dockerfile 所在文件夹的路径（ 可以是绝对路径，或者相对 docker-compose.yml 文件的路径） 。 Compose 将会利用它自动构建这个镜像，然后使用这个镜像。
```
version: '2.0'
services:
	app:
		build: .
```

- 你也可以使用 context 指令指定 Dockerfile 所在文件夹的路径。
- 使用 dockerfile 指令指定 Dockerfile 文件名。
- 使用 arg 指令指定构建镜像时的变量。
```
args:
	- version: 3.0 
```
在构建命令中使用: wget http://www.docker.com/some_software/$version, 构建参数和 ENV 的效果一样，都是设置环境变量。所不同的是，ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。但是不要因此就使用 ARG 保存密码之类的信息，因为 docker history 还是可以看到所有值的。

```
version: '2.0'
services:
	app:
		build: 
			context: ./dir
			dockerfile: your_docker_file_name
			args:
				arg_name: arg_value
```

使用 cache_from 指定构建镜像的缓存
```
build:
	context: ./dir
	cache_from:
		- img1:tag1
		- img2:tag2
```

#### command
覆盖容器启动后默认执行的命令
```
command: echo "hello world"
```

#### configs
见 swarm mode

#### cgroup_parent
制定父cgroup组，意味着将继承该组的资源限制
```
cgroup_parent: cgroups_1
```

#### container_name
制定容器名称

#### deploy
见swarm  mode

#### devices
指定设备映射关系。
```
devices:
	- "/dev/ttyUSB1:/dev/ttyUSB0"
```

#### depends_on
解决容器的依赖、启动先后的问题。以下例子中会先启动 redis db 再启动 web

```
version: '3'
services:
	web:
		build: .
		depends_on:
			- db
			- redis

	redis:
		image: redis

	db:
		image: postgres
```

注意： web 服务不会等待 redis db 「 完全启动」 之后才启动。

#### env_file
从文件中获取环境变量，可以为单独的文件路径或列表。
```
env_file: .env

env_file:
	- ./common.env
	- ./apps/web.env
	- /opt/secrets.env
```
文件中的内容为键值对：key=value，每行一条。 如果有变量名称与 environment 指令冲突，则以后者为准。这里所说的环境变量是对宿主机的 Compose 而言的，如果在配置文件中有 build 操作，这些变量并不会进入构建过程中，如果要在构建中使用变量还是首选前面刚讲的 arg 标签。

#### environment
设置环境变量。你可以使用数组或字典两种格式。
```
environment:
	key: value
	key: value

environment:
	- key=value
	- key=value
```

如果变量名称或者值中用到 true|false，yes|no 等表达 布尔 含义的词汇，最好放到引号里，避免 YAML 自动解析某些内容为对应的布尔语义。我们设置的这些环境变量，可以在后面的命令中用到，用法同shell变量，如设置了一个叫VERSION的环境变量，我们可以在entrypoint的命令中使用，如bash echo $VERSION$

#### expose
暴露端口
```
expose:
	- 4665
	- 8796
```

#### ports
映射端口，格式 宿主端口：容器端口。
```
ports:
	- 5421:5445
```

#### memory
我们可以限制容器的内存使用
```
mem_limit: 1G //限制容器的内存使用量最大为1G
```

#### extra_hosts
类似 Docker 中的 --add-host 参数，指定额外的 host 名称映射信息。
```
extra_hosts:
	- "googledns:8.8.8.8"
	- "dockerhub:52.1.157.61"
```

会在启动后的服务容器中 /etc/hosts 文件中添加如下两条条目。
```
8.8.8.8 googledns
52.1.157.61 dockerhub
```

#### healthcheck
通过命令检查容器是否健康运行
```
healthcheck:
	test: ["CMD", "curl", "-f", "http://localhost"]
	interval: 1m30s
	timeout: 10s
	retries: 3
```

#### image
制定基础镜像

#### links
连接其他容器，不推荐使用，但抵不住它方便啊
```
links:
	- container1:alias1
	- container2:alias2
```

#### external_links
在使用Docker过程中，我们会有许多单独使用docker run启动的容器，为了使Compose能够连接这些不在docker-compose.yml中定义的容器，我们需要一个特殊的标签，就是external_links，它可以让Compose项目里面的容器连接到那些项目配置外部的容器（前提是外部容器中必须至少有一个容器是连接到与项目内的服务的同一个网络里面）。 格式如下：
```
external_links:
 - redis_1
 - project_db_1:mysql
 - project_db_1:postgresql
```

#### loggins
配置日志选项
```
logging:
	driver: syslog
	options:
		syslog-address: "tcp://192.168.0.42:133"
```
目前支持的日志类型有：
- syslog
- json-file //默认，因此你使用docker inspect container_id 得到的输出是json格式的
- none

options的参数除了syslog-address,还有max-size  max-file
```
options:
	max-size: "200k"
	max-file: "10"
```

#### network_mode
设置网络模式。使用和 docker run 的 --network 参数一样的值。
```
network_mode: "bridge"
network_mode: "host"
network_mode: "none"
network_mode: "service:[service name]"
network_mode: "container:[container name/id]"
```

#### networks
配置容器连接的网络。
```
version: "3.0"
services:
	some-service:
		networks:
			- network1
			- network2
	networks:
		network1:
		network2
```

#### volumes
数据卷所挂载路径设置。可以设置宿主机路径 （HOST:CONTAINER ） 或加上访问模式（HOST:CONTAINER:ro ）
```
volumes:
	- host_dir:container_dir
```
之后，你在volume中的读写操作，本质上都是在host的文件系统进行读写的，因此哪怕你最后把容器删除，你也可以在主机目录中访问这些数据，除非你在删除容器的同时把volume也显式删除。我们一般用于存储需要保证安全性的数据，如数据库的data目录

#### tmp file
挂载临时目录到容器内部，与 run 的参数一样效果：
```
tmpfs: /run
tmpfs:
  - /run
  - /tmp
```

为了让容器能够访问数据而不需要永久地写入数据，可以使用 tmpfs 挂载，该挂载仅存储在主机的内存中（如果内存不足，则为 swap）。当容器停止时，tmpfs 挂载会被移除。如果提交容器，则不会保存 tmpfs 挂载。

#### label
```
labels:
	- key:value
```
为生成的镜像添加描述信息。可以使用inspect查看。


#### 其他
其他设置如omainname, entrypoint, hostname, ipc, mac_address, privileged,read_only, shm_size, restart, stdin_open, tty, user, working_dir ，基本同run命令中的格式与功能。如
```
restart:
	always
```
表示当遇到任意退出的时候，都会自动重启`

