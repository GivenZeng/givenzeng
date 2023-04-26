## docker安装
```
见 https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
```

检查是否安装成功
```
sudo docker version
```


## docker-compose安装
```
//详细链接见官网
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## docker-compose.yml介绍
http://www.cnblogs.com/freefei/p/5311294.html

## Dockerfile介绍
http://www.jianshu.com/p/93a678d1bde6



## example:在docker中运行node.js+redis

###  redis 连接使用
```
var redis = require('redis');
var config = require('../config/config');

var client;
if (config.run_in_docker) {
    console.log("redis:",process.env.REDIS_PORT_6379_TCP_ADDR + ':' + process.env.REDIS_PORT_6379_TCP_PORT);
    // client= redis.createClient(config.redis_docker_port, config.redis_docker_container_name);
    // APPROACH 1: Using environment variables created by Docker
    client = redis.createClient(
        process.env.REDIS_PORT_6379_TCP_PORT,
        process.env.REDIS_PORT_6379_TCP_ADDR
    );
}
else {
    client = redis.createClient(config.redis_port, config.redis_ip);
}

client.on('error', function (err) {
    console.log('redis error=', err);
});

client.on('connect', function (res) {
    console.log('redis connect');
});

client.on('ready', function (res) {
    console.log('redis ready');
});

module.exports = client;
```

### docker-compose.yml
```
version: '0.1'
services:
    web:
      build: .
      ports:
         - "6789:6789"
      volumes:
         - ./your_project_dir:/code
      links:
         - redis
    redis:
      image: redis:latest
      expose:
            - "6379"
      ports:
            - "6565:6379"
```

### Dockerfile
```
FROM node:latest
ADD ./node_wechat /code
WORKDIR /code
CMD ["node","bin/www"]
```

### 运行
```
docker-compose up --build
```


## 参考命令

### 导出镜像
```
sudo docker save -o you_image_name.tar image_name或image_code
```

### 导入镜像
```
docker load -i you_image_name.tar
```

### 运行镜像
```
docker run image_name  -d   //d代表后台运行
```

### 停止一个容器
```
docker stop container_code
```

### 删除镜像
```
docker rmi image_name或image_code
```

### 移除所有空悬镜像（即名为<none>的镜像）
```
docker rmi $(docker images -f "dangling=true" -q)
```

### 删除容器
```
docker rm container_code
```
### 列出所有容器
```
docker ps -as
```

### 列出正在运行的容器
```
docker ps
```

### 删除所有已经停止的容器
```
 docker rm $(docker ps -a -q)
```

推荐资料：
官网
简果网http://www.simapple.com/
docker从入门到实践
[docker中国][1]


  [1]: https://www.docker-cn.com/registry-mirror