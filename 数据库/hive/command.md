
### 数据库操作
与sql基本相同

* 查看数据库
	```
	show databases;
	```

* 创建数据库
	```
	create database if not exists your_db_name;
	```

* 查看数据库信息
	```
	desc database your_db_name;
	```

* 删除数据库
	```
	drop database if exists your_db_name [cascade];
	```
	默认情况下，Hive不允许用户删除一个包含表的数据库。用户要么先删除数据库中的表，然后再删除数据库；要么在删除命令的最后加上关键字cascade，这样可以使Hive自行先删除数据库中表

* 使用数据库
	```
	use your_db_name;
	```

### 表操作
* 创建
	```
	CREATE TABLE IF NOT EXISTS arrival.employsalary (
	name STRING COMMENT 'Employee name',
	salary FLOAT COMMENT 'Employee salary',
	subordinates ARRAY<STRING> COMMENT 'Names of subordinates',
	deductions MAP<STRING, FLOAT>
	COMMENT 'Keys are deductions names, values are percentages',
	address STRUCT<street:STRING, city:STRING, state:STRING>
	COMMENT 'Home address')
	COMMENT 'Description of the table'
	PARTITIONED BY (year STRING, month STRING)
	ROW FORMAT
	DELIMITED FIELDS TERMINATED BY '|'
	COLLECTION ITEMS TERMINATED BY '\073'
	MAP KEYS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	STORED AS TEXTFILE
	LOCATION '/user/hive/warehouse/arrival.db/employsalary'
	TBLPROPERTIES ('creator'='me', 'created_at'='2017-01-01 10:00:00');
	```

首先，如果当前用户所处数据库并非是目标数据库，那么需要在表名前指定数据库，也就是例子中的arrival。 
* PARTITIONED BY是分区语句，这个后面详细讲。 
* ROW FORMAT后面的语句就是前面讲的文件中的内容如何分割。 
* STORED AS TEXTFILE意味着，所有字段都使用字母、数字、字符编码，包括那些国际字符集，而且每一行是一个单独的记录。 
* LOCATION '/user/hive/warehouse/arrival.db/employsalary'用来自定义表的位置，也可以不指明，此时就是默认位置/user/hive/warehouse/arrival.db/employsalary。 
* TBLPROPERTIES可以描述表的一些信息。

注意，我们此时创建的表是管理表，有时也称为内部表。因为这种表，Hive会控制着数据的生命周期，当删除一个管理表时，Hive也会删除表中的数据，而这往往是我们不愿意看到的，所以一般我们会创建外部表，就是在TABLE前面加上EXTERNAL关键字：
```
CREATE EXTERNAL TABLE IF NOT EXISTS arrival.employsalary
...
```

* 查看
	```
	desc [formatted] your_table_name;
	```

* 复制表
	```
	CREATE EXTERNAL TABLE IF NOT EXISTS arrival.employsalary_copy
	LIKE arrival.employsalary
	LOCATION '/user/hive/warehouse/arrival.db/employsalary_copy';
	```
问：是否仅复制表结构而不复制数据

* 删除
	```
	drop table if exists your_table_name;
	```

* 插入
Hive没有行级别的数据插入、更新和删除，那么如何往表中装载数据呢？一种方法是直接把文件放在表目录下面，另一种方式是查询一个已有表，将得到的结果数据插入一个新表，相当于从原有表提取数据到新表。
```
INSERT OVERWRITE TABLE employ
PARTITION(year='2017', month='03')
SELECT es.name, es.salary FROM employsalary es
WHERE es.year='2017' and es.month='03';
```
这里使用了OVERWRITE关键字，之前分区的内容将会被覆盖掉，如果不想被覆盖可以去掉该关键字或者使用INTO关键字。 
还有一个问题，如果表很大分区很多，那每一次执行这个语句都要对表employsalary扫描一次，带来的消耗很大。Hive提供了另一种INSERT语法，可以只扫描一次输入数据，然后按多种方式进行划分。如下例子显示如何向表employ导入三个月的数据并且只扫描一次原表employsalary：
```
M employsalary es
INSERT OVERWRITE TABLE employ
    PARTITION(year='2017', month='01')
    SELECT es.name, es.salary WHERE es.year='2017' and es.month='01'
INSERT OVERWRITE TABLE employ
    PARTITION(year='2017', month='02')
    SELECT es.name, es.salary WHERE es.year='2017' and es.month='02'
INSERT OVERWRITE TABLE employ
    PARTITION(year='2017', month='03')
    SELECT es.name, es.salary WHERE es.year='2017' and es.month='03';
```


### 分区操作
* 添加
	```
	ALTER TABLE employsalary ADD PARTITION(year='2017', month='03')
	LOCATION '/user/hive/warehouse/arrival.db/employsalary_copy/2017/03';
	```
* 查看
	```
	show partitions employsalary;
	```

* 修改
	```
	LTER TABLE employsalary PARTITION(year='2017', month='03')
	SET LOCATION '/user/hive/warehouse/arrival.db/employsalary_copy/2017/01';
	```

* 删除
	```
	ALTER TABLE employsalary DROP IF EXISTS PARTITION(year='2017', month='03');
	```
