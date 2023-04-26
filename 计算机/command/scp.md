远程传送
```
scp  -r /home/shaoxiaohu/test1  zhidao@192.168.0.1:/home/test2
#test1为源目录，test2为目标目录，zhidao@192.168.0.1为远程服务器的用户名和ip地址。
scp  -r zhidao@192.168.0.1:/home/test2 /home/shaoxiaohu/test1
#zhidao@192.168.0.1为远程服务器的用户名和ip地址，test1为源目录，test2为目标目录。
```
