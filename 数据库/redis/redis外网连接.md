### 外网访问
- 配置安全组(如腾讯云等)
- 关闭防火墙或开放需要的端口,见https://www.cnblogs.com/OnlyDreams/p/7210914.html
  - 开放需要的端口 sudo ufw allow 6379
  - 完全关闭防火墙 sudo service ufw stop
- 修改配置文件/etc/redis/redis.conf
  - 将bind 127.0.0.1 注释掉或者写入你的允许访问的ip
  - 新增一行:requirepass your_password   // 添加连接密码
- 重启redis
  - sudo service redis-server restart

访问
```
redis -h ip -p 6379 -a your_password
```
