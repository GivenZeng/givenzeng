数据卷 是一个可供一个或多个容器使用的特殊目录，它绕过 UFS，可以提供很多有用的特性：
- 数据卷 可以在容器之间共享和重用
- 对 数据卷 的修改会立马生效
- 对 数据卷 的更新，不会影响镜像
- 数据卷 默认会一直存在，即使容器被删除

注意： 数据卷 的使用，类似于 Linux 下对目录或文件进行 mount，镜像中的被指定为挂载点的目录中的文件会隐藏掉，能显示看的是挂载的 数据卷 。因此你的容器目录dir有一个文件为temp.data，如果你在dir挂载了一个数据卷，那么你就再也不能读取temp.data，除非你移除该数据卷。

### 创建数据卷
```
docker volume create volume_name
```
### 查看数据卷
```
docker volume ls // 列出数据卷列表
docker volume inspect volume_name //查看指定的数据卷信息
--------------------------------------------------------------
输出:

[
	{
		"Driver": "local",
		"Labels": {},
		"Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
		"Name": "my-vol",
		"Options": {},
		"Scope": "local"
	}
]
```

### 挂载数据卷
```
docker run [options] --name container_name
	--mount source=volume_name,targe=path_in_container
	image_name_or_id
	[command]
```

查看挂载信息，在输出的信息的Mount字段包含了挂载信息
```
docker inspect container_name

result:
"Mounts": [
{
	"Type": "volume",
	"Name": "my-vol",
	"Source": "/var/lib/docker/volumes/my-vol/_data",
	"Destination": "/app",
	"Driver": "local",
	"Mode": "",
	"RW": true,
	"Propagation": ""
}
]
```
### 删除数据卷
```
docker volume rm volume_name
```

删除无主数据卷：即没有被容器使用的数据卷
```
docker volume prune
```

### 挂载主机目录作为数据卷
```
docker run [option]
	[--name container_name]
	-- mount type=bind,source=host_path,target=container_path
	image_name
	[command]
```
上面的命令加载主机的 /src/webapp 目录到容器的 /opt/webapp 目录。这个功能在进行测试的时候十分方便，比如用户可以放置一些程序到本地目录中，来查看容器是否正常工作。本地目录的路径必须是绝对路径，以前使用 -v 参数时如果本地目录不存在 Docker 会自动为你创建一个文件夹，现在使用 --mount 参数时如果本地目录不存在，Docker 会报错。

也可以为docker数据卷指定读写权限
```
-- mount type=bind,source=host_path,target=container_path,readonly
```
这样你就不能在容器中写container_path的目录了

也可以挂载文件
```
-- mount type=bind,source=host_path,target=container_path
```
这样就可以记录在容器输入过的命令了。
