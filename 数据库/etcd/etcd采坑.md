coreos 开发的分布式服务系统，内部采用 raft 协议作为一致性算法。作为服务发现系统，有以下的特点：
- 简单：安装配置简单，而且提供了 HTTP API 进行交互，使用也很简单
- 安全：支持 SSL 证书验证
- 快速：根据官方提供的 benchmark 数据，单实例支持每秒 2k+ 读操作
- 可靠：采用 raft 算法，实现分布式系统数据的可用性和一致性

## 常用的命令
常用的有put、delete等，如etcdctl put name given，其他命令如下：
```
// 设置客户端协议版本
export ETCDCTL_API=3
// 获取所有k-v
etcdctl get --prefix=true ""
etcdctl --endpoints=host:port get --prefix=true ""


// 碎片整理
etcdctl defrag
etcdctl --endpoints=http:// .0.0.1:2379 defrag
```

## 内存使用优化
在baton的使用过程中，etcd的内存使用量不断增高，当etcd机器内存耗尽，旧版本的baton的几近所有节点都无法运行任务（common任务可以继续运行）。经过各种文档、blog、已经不断实践尝试，最终得到的结论是etcd的snapshoot耗费的过多内存。（etcd 3.2之前的版本存在内存泄露）。

etcd会把所有操作都记录到log里面。为防止内存内的log太多，当操作数达到一定值，etcd会把log写入到文件（snapshot），并移除旧的log和snapshot。默认是每1w（默认为1w，可能是因为当前大部分机器的内存都是4G以上？）次操作写一次snapshot。对于etcd v2，创建snapshot的代价是昂贵的。当etcd内存使用量过高，可以考虑减少这个阈值，从而减少缓存数量。当然，如果该值过小，则snapshot则会更为频繁。对于类似baton这种较低频的读写应用，设置为1000的话，snapshot为基本每3分钟一次，每次耗时小于0.1s。
```
// 启动时设置日志数量
etcd --snapshot-count=1000
// 或者设置环境变量
ETCD_SNAPSHOT_COUNT=5000 etcd
```

在设置snapshot-count 之后，最好还是整理一下碎片。碎片整理见前文。

<p align="right">
Ref: [Document: ETCD Tuning](https://coreos.com/etcd/docs/latest/tuning.html#snapshots)
</p>

## etcd节点更新
当我们启动一个节点的时候，需要标记该节点是否已经在etcd集群登记过，如果已经登记过，那么启动的时候应该加上：
```
etcd \
other flags \
--initial-cluster-state existing
```

新增节点则如下：
```
etcd \
other flags \
--initial-cluster-state new
```

<p align="right">Ref: [Document: ETCD Clustering](https://coreos.com/etcd/docs/latest/v2/runtime-configuration.html)</p>
