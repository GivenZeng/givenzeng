此处主要记录一些ETCD的使用

### ETCD内存使用量过高
在baton的使用过程中，etcd的内存使用量不断增高，当etcd机器内存耗尽，旧版本的baton的几近所有节点都无法运行任务（common任务可以继续运行）。经过各种文档、blog、已经不断实践尝试，最终得到的结论是etcd的snapshoot耗费的过多内存。

etcd会将所有的更改写到日志文件。日志文件会随着操作数量增加而线性增长。为了避免日志文件过大，etcd会定期进行制作快照，这些快照可以用于压缩日志文件（记录当前的系统状态、移除快照前的日志文件）。

对于v2版本，创建快照的消耗是十分大的（其实对于v3来说也几近一样），因此etcd只会在操作次数达到一定数量之后才会进行快照制造。默认，etcd会每隔10000次操作进行一次快照制作（类似与RDBMS的增量备份）。因此，在内存中记录这10000次操作产生的变更的消耗是十分巨大的。为了降低etcd在快照内容的缓存，我们减少etcd快照间隔，使得每个快照尽可能的小：
```
# Command line arguments:
$ etcd --snapshot-count=5000

# Environment variables:
$ ETCD_SNAPSHOT_COUNT=5000 etcd
```
<p align="right">
Ref: [Document: ETCD Tuning](https://coreos.com/etcd/docs/latest/tuning.html#snapshots)
</p>


### ETCD 更新
当我们启动一个节点的时候，需要标记该节点是否已经在etcd集群登记过，如果已经登记过，那么启动的时候应该加上：
```
etcd \
other flags \
--initial-cluster-state existing
```
否则如下：
```
etcd \
other flags \
--initial-cluster-state new
```

<p align="right">Ref: [Document: ETCD Clustering](https://coreos.com/etcd/docs/latest/v2/runtime-configuration.html)</p>
