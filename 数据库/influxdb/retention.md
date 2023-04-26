InfluxDB本身不提供数据的删除操作，因此用来控制数据量的方式就是定义数据保留策略。

### 查看现有策略
```
show retention policies on db_name

--------------------------output---------------------------
name    duration    shardGroupDuration    replicaN    default
default    0        168h0m0s        1        true
```
- 每个db都有一个默认的策略，每个策略都有shardGroupDuration时间，检测的时间窗口，默认为7d
- duration--持续时间，0代表无限制，如duration 1h，即只保留一小时内的数据
- replicaN--全称是REPLICATION，副本个数

### 新建策略
```
create retention policy "policy_name" on "db_name" duration <time> replication n [default]

//例子
create retention policy "3_hour" on "test" duration 3h default
```

### 修改策略
```
alter retention policy "3_hour" on "test" duration 4h default
```

### 删除策略
```
drop retention policy "3_hour" on "test"
```
