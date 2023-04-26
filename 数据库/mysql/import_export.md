### 导出
导出为txt，分隔符为空格
```
SELECT * FROM runoob_tbl  INTO OUTFILE '/tmp/tutorials.txt';
```

导出为csv，分隔符为","
```
SELECT * FROM passwd INTO OUTFILE '/tmp/tutorials.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
```

导出表为sql
```
mysqldump -u root -p db_name table_name > dump.sql
```

导出数据库
```
mysqldump -u root -p db_name > dump.sql
```

导出所有数据库
```
mysqldump -u root -p --all-databases > database_dump.sql
```


### 导入
```
 mysql -u root -p database_name < dump.sql

 或者在终端里面
 source "the path of sql file"
```

你也可以使用以下命令将导出的数据直接导入到远程的服务器上，但请确保两台服务器是相通的，是可以相互访问的:
```
$ mysqldump -u root -p database_name \
       | mysql -h other-host.com database_name
```       
