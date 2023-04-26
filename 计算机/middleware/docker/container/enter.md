在使用 -d 参数时，容器启动后会进入后台模式运行。

某些时候需要进入容器进行操作，包括使用 docker attach 命令或 docker exec 命令，推荐大家使用 docker exec 命令，原因会在下面说明。


### attach
```
docker attach container_id
```
注意： 如果从这个 stdin 中 exit，会导致容器的停止。

### exec
```
docker exec [options] container_id command
options:
-i： 输出
-t： 终端
如：
docker exec -it 69d1 bash
```
stdin 中 exit，不会导致容器的停止。这就是为什么推荐大家使用 docker exec 的原因。

更多参数说明请使用 docker exec --help 查看。
