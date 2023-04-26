### 创建用户并授权
https://www.cnblogs.com/codeAB/p/6391022.html
```
create user 'user_name@user_host' identified 'user_password'
//如果user_host为%，则所有主机都可访问，如果时localhost则只能本地访问

如 create user 'test_user'@'localhost' identified by 'test_user';

grant select,insert,update,delete,create on database_name.table_name to user_name
//table_name用*则代表所有表
//select,insert,update,delete,create：也可以all privileges
grant all privileges on *.* to 'test'@'%'identified by '123456' with grant option;



flush privileges ;
```
如果需要外地登陆，需要将mysql配置文件里面的bind-address = 127.0.0.1注释掉


### 更新权限

### 修改用户账号密码
```
update mysql.user set password=password('新密码') where User="test" and Host="localhost";
```

### 删除用户
```
delete from user where User='test' and Host='localhost';
```
