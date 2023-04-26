## docker安装
```
见 https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
```

检查是否安装成功
```
// 需要root权限
sudo docker version
```

## 非sudo运行docker
docker用户组的用户可以已普通形式操作docker，因此我们可以创建一个docker用户组，并将需要用到docker的用户加入docker用户组
```
sudo groupadd docker
sudo usermod -aG docker ${USER}
sudo systemctl restart docker // 重启docker
```
之后就不同sudo了
