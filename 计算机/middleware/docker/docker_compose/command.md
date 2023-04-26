统一命令格式
```
docker-compose [-f=<arg>...] [options] [command] [args]

-f 指定compose文件，默认为docker-compose.yml
-p, --project-name 指定项目名字，默认为所在目录的名字

```

- -f, --file FILE 指定使用的 Compose 模板文件，默认为 docker-compose.yml ，可以多次指定。

- -p, --project-name NAME 指定项目名称，默认将使用所在目录名称作为项目名。

- --x-networking 使用 Docker 的可拔插网络后端特性

- --x-network-driver DRIVER 指定网络后端的驱动，默认为 bridge

- --verbose 输出更多调试信息。

- -v, --version 打印版本并退出



### build
构建/重新构建项目中的容器
```
docker-compose build [options] [service]
```
服务容器一旦构建后，将会带上一个标记名，例如对于 web 项目中的一个 db 容器，可能是web_db。

- --force-rm 删除构建过程中的临时容器。
- --no-cache 构建镜像过程中不使用 cache（ 这将加长构建过程） 。 
- --pull 始终尝试通过 pull 来获取更新版本的镜像。

### config
检查compose文件格式是否正确
```
docker-compose config
```

### down
停止up命令启动的容器，并移除网络
```
docker-compose down container_name
```

### exec
进入容器
```
docker-compose exec container-name
```

### help
帮助

### images
列出compose文件中包含的镜像
```
docker-compose images
```

### kill
通过发送 SIGKILL 信号来强制停止服务容器。
```
docker-compose kill [options] [SERVICE...]
```

### logs
查看容器输出
```
docker-compose logs [options] [service...]
```
默认情况下，docker-compose 将对不同的服务输出使用不同的颜色来区分。可以通过 --no-color 来关闭颜色。


### pause
暂停容器
```
docker-compose pause [service...]
```

### port
查看容器端口所映射的公共端口
```
docker-compose port [options] SERVICE PRIVATE_PORT 
```

### ps
列出当前多有容器
```
docker-compose ps [optios] [service...]
```
-q:只显示id

### pull
拉取服务以来的镜像
```
docker-compose pull [options] [service...]
```

### push
将服务以来的镜像推送到仓库

### restart
```
docker-compose rstart [options] [service...]
```
-t:制定重启前停止容器的超时，默认10s

### rm
停止所有处于停止状态的容器。推荐先执行docker-compose stop 来停止容器
```
docker-compose rm [options] [service...]
```
-f, --force 强制直接删除，包括非停止状态的容器。一般尽量不要使用该选项。

-v 删除容器所挂载的数据卷。

### run 
```
docker-compose run [options] [-p PORT...] [-e KEY=VAL...] SERVICE [COMMAND] [ARGS...] 
```

默认情况下，如果存在关联，则所有关联的服务将会自动被启动，除非这些服务已经在运行中。

该命令类似启动容器后运行指定的命令，相关卷、链接等等都将会按照配置自动创建。但是：
- 给定命令将会覆盖原有的自动运行命令；
- 不会自动创建端口，以避免冲突.

- -d 后台运行容器。
- --name NAME 为容器指定一个名字。
- --entrypoint CMD 覆盖默认的容器启动指令。
- -e KEY=VAL 设置环境变量值，可多次使用选项来设置多个环境变量。
- -u, --user="" 指定运行容器的用户名或者 uid。
- --no-deps 不自动启动关联的服务容器。
- --rm 运行命令后自动删除容器， d 模式下将忽略。
- -p, --publish=[] 映射容器端口到本地主机。
- --service-ports 配置服务端口并映射到本地主机。
- -T 不分配伪 tty，意味着依赖 tty 的指令将无法运行。

### scale
设置指定服务运行的容器个数。
```
docker-compose scale [options] [SERVICE=NUM...]
```

### start
启动已经存在的服务容器。
```
docker-compose start [SERVICE...]
```

### stop
停止已经处于运行状态的容器，但不删除它。通过 docker-compose start 可以再次启动这些容器
```
docker-compose stop [options] [SERVICE...] stop
```


### top
查看各个服务容器内运行的进程

### unpause
恢复处于暂停状态中的服务

### up
```
docker-compose up [options] [SERVICE...]
```
该命令十分强大，它将尝试自动完成包括构建镜像，（ 重新） 创建服务，启动服务，并关联服务相关容器的一系列操作。

默认在前台运行，可以使用-d以在后天运行。

```
-d 在后台运行服务容器。
--no-color 不使用颜色来区分不同的服务的控制台输出。
--no-deps 不启动服务所链接的容器。
--force-recreate 强制重新创建容器，不能与 --no-recreate 同时使用。
--no-recreate 如果容器已经存在了，则不重新创建，不能与 --force-recreate 同时使用。
--no-build 不自动构建缺失的服务镜像。
-t, --timeout TIMEOUT 停止容器时候的超时（ 默认为 10 秒） 。
```
