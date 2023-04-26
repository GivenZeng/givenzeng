### 查看某几行
linux 如何显示一个文件的某几行(中间几行)

【一】从第3000行开始，显示1000行。即显示3000~3999行
```
cat filename | tail -n +3000 | head -n 1000
```
【二】显示1000行到3000行
```
cat filename| head -n 3000 | tail -n +1000
```


* 注意两种方法的顺序
分解：
```
    tail -n 1000：显示最后1000行

    tail -n +1000：从1000行开始显示，显示1000行以后的

    head -n 1000：显示前面1000行
```


【三】用sed命令
```
 sed -n '5,10p' filename 这样你就可以只查看文件的第5行到第10行。
```

### vim中跳转到指定行
在命令模式中:n


### 查找文件、文件夹
```
查找目录：find /（查找范围） -name '查找关键字' -type d
查找文件：find /（查找范围） -name 查找关键字 -print
```


### truncate
修改文件大小
```
truncate 选项... 文件...
将文件缩减或扩展至指定大小。如果指定文件不存在则创建。

-c, --no-create	不创建文件
-o, --io-blocks	将SIZE 视为IO 块数而不使用字节数
-r, --reference=文件   使用此文件的大小
-s, --size=大小	使用此大小
    --help		显示此帮助信息并退出
    --version		显示版本信息并退出

truncate -s 0 filePate  //清空文件    
```
