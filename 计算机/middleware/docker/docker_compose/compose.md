多个容器之间相互连接可以使用Docker Compose

ompose 项目是 Docker 官方的开源项目，负责实现对 Docker 容器集群的快速编排。从功能上看，跟 OpenStack 中的 Heat 十分类似。其代码目前在 https://github.com/docker/compose 上开源。

通过第一部分中的介绍，我们知道使用一个 Dockerfile 模板文件，可以让用户很方便的定义一个单独的应用容器。然而，在日常工作中，经常会碰到需要多个容器相互配合来完成某项任务的情况。例如要实现一个 Web 项目，除了 Web 服务容器本身，往往还需要再加上后端的数据库服务容器，甚至还包括负载均衡容器等。

Compose 恰好满足了这样的需求。它允许用户通过一个单独的 docker-compose.yml 模板文件（ YAML 格式） 来定义一组相关联的应用容器为一个项目（ project）。

Compose 中有两个重要的概念：
- 服务 ( service )：一个应用的容器，实际上可以包括若干运行相同镜像的容器实例。
- 项目 ( project )：由一组关联的应用容器组成的一个完整业务单元，在 dockerc-ompose.yml 文件中定义。


### 安装与卸载
```
// 安装方法有两种
// 1. 二进制安装
sudo curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

// 2. pip安装
sudo pip install -U docker-compose

// 卸载
// 1. 针对二进制安装方法
sudo rm /usr/local/bin/docker-compose
// 2. 针对pip安装方法
sudo pip uninstall docker-compose

// for macOS
brew install  docker-compose
```


### 使用Example
app.py
```
from flask import Flask
from redis import Redis
app = Flask(__name__)
redis = Redis(host='redis', port=6379)
@app.route('/')
def hello():
count = redis.incr('hits')
return 'Hello World! 该页面已被访问 {} 次。\n'.format(count)
if __name__ == "__main__":
app.run(host="0.0.0.0", debug=True)   // flask默认监听的是127.0.0.1:5000
```

Dockerfile
```
FROM python:3.6-alpine
# 复制代码到镜像
ADD . /code   
# 设置后面的命令的pwd
WORKDIR /code
# 安装依赖
RUN pip install redis flask
# 运行服务的命令
CMD ["python", "app.py"]
```

docker-compose.yml
```
# docker版本
version: '2.0'
services:
	# 一个服务，名字为web
	web:
		# 指定从Dockerfile构建，并指定上下文
		build: .
		# 指定端口映射，host_port:container_port
		ports:
			- 5000:5000
	# 服务redis，基于镜像redis
	redis:
		image: "redis:latest"
```

运行
```
docker-compose up
```
docker-compose up:判断是否已经有目标镜像web和redis，如果有就启动；如果没有，就构建镜像并启动容器；如果已经构建但是Dockerfile或者docker-complse.yml发生变化，就重新构建并启动。“--build”选项表示无论如何都重新构建镜像。


- --build:强制重新构建（比如代码发生了更改）
