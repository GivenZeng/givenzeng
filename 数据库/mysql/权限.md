云服务器mysql

### 外网访问
- 配置安全组(如腾讯云等)
- 关闭防火墙或开放需要的端口,见https://www.cnblogs.com/OnlyDreams/p/7210914.html
  - 开放需要的端口 sudo ufw allow 3306
  - 完全关闭防火墙 sudo service ufw stop
- 修改mysql配置文件/etc/mysql/mysql.conf.d/mysqld.cnf,将bind 127.0.0.1 注释掉或者写入你的允许访问的ip
- 重启mysql
- 在mysql中运行一下命令

```
// 新建一个用户,并赋予他远程访问某个数据库的权限
grant all privileges on db_name.* to 'user_name'@'%' identified by 'user_password' with grant option;
// 或者为已经存在的用户赋予远程访问的权限
update user set host = '%' where user = 'user_name' ;

// 刷新
flush privileges;
```
上述命令的 %  代表所有ip均可访问,你可以将其替换为特定的ip.

接着我们在外网访问:
```
mysql -h 公网ip或域名 -H 3306 -u  user_name -p
```
