```
curl url --progress
```
- -o filename:输出到file，默认为屏幕
- -C int:偏移量
- --cookie "user=root;pass=123456"：设置cookie
- --cookie-jar cookie_file：将cookie另存为文件
- --user-agent "Mozilla/5.0"
- -H "accept-language:zh-cn" ：设置头部
- --limit-rate 50k：限制速度
- curl -u user:pwd http://man.linuxde.net 使用curl选项 -u 可以完成HTTP或者FTP的认证，可以指定密码，也可以不指定密码在后续操作中输入密码
- -X PUT：使用put方式请求


post 添加参数
```
curl -X POST -F 'username=davidwalsh' -F 'password=something' http://domain.tld/post-to-me.php
// 上传图片
curl -X POST -F 'image=@/path/to/pictures/picture.jpg' http://domain.tld/upload


```
