* https://dev.mysql.com/doc/refman/5.7/en/partitioning-types.html
* https://www.cnblogs.com/sandea/p/5723380.html

当一个表里面存储的数据特别多的时候，比如单个.myd数据都已经达到10G了的话，必然导致读取的效率很低，这个时候我们可以采用把数据分到几张表里面来解决问题。
* 方式一：通过业务逻辑根据数据的大小通过id%10这种来分成 user1,user2,user3等这样的，但是这样会有很多问题我们需要维护这样一个hash关系，
而且每次读取数据和写入数据的时候还要去判断取那张表，这个是我们通过程序去识别写表和读表的。
* 方式二：mysql可以通过partition进行分区，这种分区显示给我们的数据依然都是在一个数据表里面的，不影响我们读取查询数据，而是mysql内部的文件机制实现了将数据存储在不同的数据文件里，这样的好处是mysql自动将对应的数据分到的不同的.myd文件里面去了，大大降低了文件的大小，将数据分摊了，很好的提高了效率。

注意，分区应该是针对常用于查询条件的列进行

### 垂直分区
举个简单例子：一个包含了大text和BLOB列的表，这些text和BLOB列又不经常被访问，这时候就要把这些不经常使用的text和BLOB了划分到另一个分区，在保证它们数据相关性的同时还能提高访问速度。

### 水平分区

* Range（范围） – 这种模式允许DBA将数据划分不同范围。例如DBA可以将一个表通过年份划分成三个分区，80年代（1980's）的数据，90年代（1990's）的数据以及任何在2000年（包括2000年）后的数据。
* Hash（哈希） – 这中模式允许DBA通过对表的一个或多个列的Hash Key进行计算，最后通过这个Hash码不同数值对应的数据区域进行分区，。例如DBA可以建立一个对表主键进行分区的表。
* Key（键值） – 上面Hash模式的一种延伸，这里的Hash Key是MySQL系统产生的。
* List（预定义列表） – 这种模式允许系统通过DBA定义的列表的值所对应的行数据进行分割。例如：DBA建立了一个横跨三个分区的表，分别根据2004年2005年和2006年值所对应的数据。
* Composite（复合模式） - 很神秘吧，哈哈，其实是以上模式的组合使用而已，就不解释了。举例：在初始化已经进行了Range范围分区的表上，我们可以对其中一个分区再进行hash哈希分区。
* 分区字段必须是主键（PRIMARY KEY)的一部分
#### Range
* 字段值为某一范围的数据都记录到一个分区
将用户表分成4个分区，以每300万条记录为界限，每个分区都有自己独立的数据、索引文件的存放目录，与此同时，这些目录所在的物理磁盘分区可能也都是完全独立的，可以提高磁盘IO吞吐量。
```
CREATE TABLE users (
       uid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
       name VARCHAR(30) NOT NULL DEFAULT '',
       email VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY RANGE (uid) (
       PARTITION p0 VALUES LESS THAN (3000000)
       DATA DIRECTORY = '/data0/data'
       INDEX DIRECTORY = '/data1/idx',

       PARTITION p1 VALUES LESS THAN (6000000)
       DATA DIRECTORY = '/data2/data'
       INDEX DIRECTORY = '/data3/idx',

       PARTITION p2 VALUES LESS THAN (9000000)
       DATA DIRECTORY = '/data4/data'
       INDEX DIRECTORY = '/data5/idx',

       PARTITION p3 VALUES LESS THAN MAXVALUE     DATA DIRECTORY = '/data6/data'
       INDEX DIRECTORY = '/data7/idx'
);
```

#### List
* 字段值为某一集合的元素的记录都存储到一个分区
```
CREATE TABLE category (
     cid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY LIST (cid) (
     PARTITION p0 VALUES IN (0,4,8,12)
     DATA DIRECTORY = '/data0/data'
     INDEX DIRECTORY = '/data1/idx',

     PARTITION p1 VALUES IN (1,5,9,13)
     DATA DIRECTORY = '/data2/data'
     INDEX DIRECTORY = '/data3/idx',

     PARTITION p2 VALUES IN (2,6,10,14)
     DATA DIRECTORY = '/data4/data'
     INDEX DIRECTORY = '/data5/idx',

     PARTITION p3 VALUES IN (3,7,11,15)
     DATA DIRECTORY = '/data6/data'
     INDEX DIRECTORY = '/data7/idx'
);   
```

#### Hash 慎用
* 字段值的哈希结果一样的记录都存储到一个分区
```
CREATE TABLE users (
     uid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(30) NOT NULL DEFAULT '',
     email VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY HASH (uid) PARTITIONS 4 (   //以4作为hash
     PARTITION p0
     DATA DIRECTORY = '/data0/data'
     INDEX DIRECTORY = '/data1/idx',

     PARTITION p1
     DATA DIRECTORY = '/data2/data'
     INDEX DIRECTORY = '/data3/idx',

     PARTITION p2
     DATA DIRECTORY = '/data4/data'
     INDEX DIRECTORY = '/data5/idx',

     PARTITION p3
     DATA DIRECTORY = '/data6/data'
     INDEX DIRECTORY = '/data7/idx'
);
```

### KEY
```
CREATE TABLE users (
     uid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(30) NOT NULL DEFAULT '',
     email VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY KEY (uid) PARTITIONS 4 (
     PARTITION p0
     DATA DIRECTORY = '/data0/data'
     INDEX DIRECTORY = '/data1/idx',

     PARTITION p1
     DATA DIRECTORY = '/data2/data'
     INDEX DIRECTORY = '/data3/idx',

     PARTITION p2
     DATA DIRECTORY = '/data4/data'
     INDEX DIRECTORY = '/data5/idx',

     PARTITION p3
     DATA DIRECTORY = '/data6/data'
     INDEX DIRECTORY = '/data7/idx'
);
```


### 子分区
* 子分区是针对 RANGE/LIST 类型的分区表中每个分区的再次分割。再次分割可以是 HASH/KEY 等类型
```
CREATE TABLE users (
     uid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(30) NOT NULL DEFAULT '',
     email VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY RANGE (uid) SUBPARTITION BY HASH (uid % 4) SUBPARTITIONS 2(
     PARTITION p0 VALUES LESS THAN (3000000)
     DATA DIRECTORY = '/data0/data'
     INDEX DIRECTORY = '/data1/idx',

     PARTITION p1 VALUES LESS THAN (6000000)
     DATA DIRECTORY = '/data2/data'
     INDEX DIRECTORY = '/data3/idx'
);
```

```
CREATE TABLE users (
     uid INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
     name VARCHAR(30) NOT NULL DEFAULT '',
     email VARCHAR(30) NOT NULL DEFAULT ''
)
PARTITION BY RANGE (uid) SUBPARTITION BY KEY(uid) SUBPARTITIONS 2(
     PARTITION p0 VALUES LESS THAN (3000000)
     DATA DIRECTORY = '/data0/data'
     INDEX DIRECTORY = '/data1/idx',

     PARTITION p1 VALUES LESS THAN (6000000)
     DATA DIRECTORY = '/data2/data'
     INDEX DIRECTORY = '/data3/idx'
);

```

### 分区管理
```
//删除分区  
ALERT TABLE users DROP PARTITION p0;
//RANGE 分区重建
// 将原来的 p0,p1 分区合并起来，放到新的 p0 分区中。
ALTER TABLE users REORGANIZE PARTITION p0,p1 INTO (PARTITION p0 VALUES LESS THAN (6000000));
// LIST 分区重建
// 将原来的 p0,p1 分区合并起来，放到新的 p0 分区中。
ALTER TABLE users REORGANIZE PARTITION p0,p1 INTO (PARTITION p0 VALUES IN(0,1,4,5,8,9,12,13));
// 新增Range分区
ALTER TABLE category ADD PARTITION (PARTITION p4 VALUES IN (16,17,18,19)
           DATA DIRECTORY = '/data8/data'
           INDEX DIRECTORY = '/data9/idx');
// 新增Hash分区
ALTER TABLE users ADD PARTITION PARTITIONS 8;

//给已有表加上分区
alter table results partition by RANGE (month(ttime))
(PARTITION p0 VALUES LESS THAN (1),
PARTITION p1 VALUES LESS THAN (2) , PARTITION p2 VALUES LESS THAN (3) ,
PARTITION p3 VALUES LESS THAN (4) , PARTITION p4 VALUES LESS THAN (5) ,
PARTITION p5 VALUES LESS THAN (6) , PARTITION p6 VALUES LESS THAN (7) ,
PARTITION p7 VALUES LESS THAN (8) , PARTITION p8 VALUES LESS THAN (9) ,
PARTITION p9 VALUES LESS THAN (10) , PARTITION p10 VALUES LESS THAN (11),
PARTITION p11 VALUES LESS THAN (12),
PARTITION P12 VALUES LESS THAN (13) );
```

### 注意
使用hash 或者liner key进行分区，在范围查询中是无法使用分区修剪的

### 日期hash分区
```
drop table game_role_profile;
create table if not exists game_role_profile(
    `date` date not null,
    game_open_id varchar(32) not null default '' comment '游戏账号id',
    attack varchar(64) not null default '' comment '攻击力',
    life varchar(64) not null default '' comment '生命力',
    `defence` varchar(64) NOT NULL DEFAULT '0' COMMENT '防御力',
    `challenge_history` varchar(64) NOT NULL DEFAULT '' COMMENT '总闯关记录，格式:cnt=7&rank=503500',
    scene_history text not null comment '各关卡记录:scene_id=5&min_reduce_num=1215...',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted_at` timestamp NULL DEFAULT NULL COMMENT '删除时间',
    key idx_game_open_id(`date`, game_open_id)
    -- primary key(`date`, game_open_id)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏角色信息表'
--  partition by hash (TO_DAYS(`date`)) PARTITIONS 1024;
```
