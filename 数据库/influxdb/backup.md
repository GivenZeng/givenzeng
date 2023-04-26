doc https://docs.influxdata.com/enterprise_influxdb/v1.5/guides/backup-and-restore/

先从之前下载的压缩包中获取备份工具
```
ln -s influxdb-1.4.2/usr/bin/influxd /usr/local/bin/influxd
```
### 本地数据备份
```
//语法
influxd backup -database db_name [since 2018-07-02 12:00:00] path_to_back
//since可以指定备份某个时间点之后的数据

//例子
influxd backup payment ~/tmp/backup/payment
```

### 远程备份
```
influxd backup -database db_name -hosthost:port [since 2018-07-05 13:00:00]path_backup
```

### 数据恢复
```
influxd restore [ -metadir | -datadir ] <path-to-meta-or-data-directory> <path-to-backup>


//例子
influxd restore -database payment -metadir /var/lib/influxdb/meta -datadir /var/lib/influxdb/data ~/tmp/backup/payment
//注意，在restore之前需要把influxd stop，restore后重启influxd数据才会成功恢复
```
