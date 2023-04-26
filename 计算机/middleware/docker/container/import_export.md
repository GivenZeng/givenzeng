有时候我们会需要将自己机器的容器定期保存下来或者分享给其他人，那么就可以使用导入/导出的功能

### export
```
docker export container_id > your_container_file
example:
	docker export fe3 > ubuntu
```
这样将导出容器快照到本地文件。

### import

```
cat you_container_file > docker import - yourlibrary/your_image:tag
```
可以使用 docker import 从容器快照文件中再导入为镜像

此外，也可以通过指定 URL 或者某个目录来导入，例如
```
// 导入一个镜像
docker import http://example.com/exampleimage.tgz example/imagerepo
```

用户既可以使用 docker load 来导入镜像存储文件到本地镜像库，也可以使用 docker import 来导入一个容器快照到本地镜像库。这两者的区别在于容器快照文件将丢弃所有的历史记录和元数据信息（ 即仅保存容器当时的快照状态） ，而镜像存储文件将保存完整记录，体积也要大。此外，从容器快照文件导入时可以重新指定标签等元数据信息


