关于commit和rollback的问题

表结构
```
CREATE TABLE `test` (
`f1`  int(11) NOT NULL ,
`f2`  int(11)  DEFAULT 0 ,
PRIMARY KEY (`f1`)
)
```
下面讨论的是在同一个事务中

## commit
哪怕没有commit，已经exec的数据仍可查询得到， 但无法被其他session查询得到，只有在commit之后，才对其他session可见
```
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into test values(1, 100);
Query OK, 1 row affected (0.00 sec)

mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.01 sec)

```

如果exec失败，之前exec成功的仍可查询得到， 但无法被其他session查询得到，只有在commit之后，才对其他session可见
```
mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.01 sec)

mysql> insert into test values(1, 200);
ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.00 sec)
```


rollback之后，该transaction的所有exec都会撤销
```
mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.00 sec)

mysql>
mysql>
mysql> rollback;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from test;
Empty set (0.00 sec)

```


### 整体截取
```
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into test values(1, 100);                                                         
Query OK, 1 row affected (0.00 sec)

mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.01 sec)

mysql> insert into test values(1, 200);
ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'
mysql> select * from test;
+----+------+
| f1 | f2   |
+----+------+
|  1 |  100 |
+----+------+
1 row in set (0.00 sec)

mysql>
mysql>
mysql> rollback;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from test;
Empty set (0.00 sec)

```

### 结论
如果有多条exec： A-B-C，但是B失败
- commit之前，A、C对其他session不可见
- commit之后A和C都会写到数据库，即commit不会帮我们自动回滚所有操作
- rollback之后，A、C都会被撤销

### 长时间持有行锁而不释放
client A 长时间不commit
```
mysql> delete  from test;
Query OK, 0 rows affected (0.00 sec)

mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into test values(1, 100);
Query OK, 1 row affected (0.00 sec)

mysql>
```

client B 使用同一个primary可以，造成超时
```
mysql> use test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into test values(1, 200);
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
mysql>
```

可见，A和B插入同一个primary key， 但是由于A持有了该key的锁，造成B一直等待，最后超时