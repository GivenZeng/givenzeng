innodb和myisam对比

- myisam不支持事务
- myisam不支持低层次锁，只有表级别的锁
- innodb不支持全文索引，myisam支持
- mysiam的性能远优于innodb
- innodb插入、更新速度优于myisam（因为innodb的锁粒度更小）
- innodb支持acid
- innodb中，auto_increment的字段是索引（或者为索引的一部分）
- innodb不存储表级别的汇总数据，如"select count(1) from table_name" 会扫表。而myisam会存储汇总数据，如count等
- myisam不支持外键
