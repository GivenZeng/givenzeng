* 查看类命名
	```
	\q	 	//退出
	\h		//help
	?		//查看命令列表
	l		//列出所有数据库，相当于mysql中的 show databases;
	\c dbname	//切换数据库，相当于mysql中的 use dbname;
	\d		//相当于show tables;
	\d table_name	//相当于desc table table_name
	\du 	//显示所有用户。postgresql默认postgres是superuser
	\e	//打开文本编辑器，可以用来简单的写些sql脚本
	\conninfo	//列出当前数据库和连接的信息。
	```

* 数据库
	* 创建
	```
	create database db_name;
	```
	* 删除
	```
	drop database db_name;
	```
	* 使用数据库
	```
	\c db_name;
	```

* 表
	* 创建
	```
	create table [if not exists] t_name (
		c1 int,
		c2 varchar(32),
		c3 varchar(32)
	);
	```
	* 删除
	```
	drop table [if exists] t_name;
	```
	* 表重命名
	```
	alter table table_old_name rename to table_new_name;
	```
	* 增加列
	```
	alter table t_name add
	```
	* 列重命名
	```
	alter table t_name rename column column_old_name to column_new_name;
	```
	* 删除列
	```
	alter table t_name drop column column_name;
	```
	* 修改列类型、默认值等
	```
	alter table t_name alter column column_name type column_new_type;
	alter table t_name alter column column_name set not null;
	```

* 记录
	* 插入
	```
	insert into t_name(c1,c2,c3) values(v1,v2,v3);

	insert into t_name(c2,c3) values(v2,v3);

	insert into t_name values(v1,v2,v3)
	```
	* 更新
	```
	update t_name set c1 = x where c2 = y;
	```
	* 查询
	```
	select c2 as xxx, c3 from t_name where c1 = v1;
	```
	* 删除
	```
	delete from t_name where c1 = v1 and c2 > v2;
	```


* 终止查询
-  查询时长超过五分钟的正在运行的query
```
SELECT
  pid,
  now() - pg_stat_activity.query_start AS duration,
  query,
  state
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';
```
- 通过pid终止某query
```
SELECT pg_cancel_backend(__pid__);
```
