
* [资料一](http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/crontab.html)
* [资料二](https://www.cnblogs.com/longjshz/p/5779215.html)



## crontab
通过crontab 命令，我们可以在固定的间隔时间执行指定的系统指令或 shell script脚本。时间间隔的单位可以是分钟、小时、日、月、周及以上的任意组合。这个命令非常适合周期性的日志分析或数据备份等工作。

### 命令格式
crontab [-u user] file crontab [-u user] [ -e | -l | -r ]

* -u user：用来设定某个用户的crontab服务；
* file：file是命令文件的名字,表示将file做为crontab的任务列表文件并载入crontab。如果在命令行中没有指定这个文件，crontab命令将接受标准输入（键盘）上键入的命令，并将它们载入crontab。
* -e：编辑某个用户的crontab文件内容。如果不指定用户，则表示编辑当前用户的crontab文件。
* -l：显示某个用户的crontab文件内容，如果不指定用户，则表示显示当前用户的crontab文件内容。
* -r：从/var/spool/cron目录中删除某个用户的crontab文件，如果不指定用户，则默认删除当前用户的crontab文件。
* -i：在删除用户的crontab文件时给确认提示。

### 例子
以下例子为当前用户添加定时任务
* 添加定时任务：运行crontab -e，并输入以下内容（如果你是第一次运行，会提示你选择一个编辑器）
```
#你的命令要在哪运行
SHELL=/bin/bash
#为这个shell添加环境变量,如你的命令需要java环境
PATH=$PATH:/your_jdk_path
#当运行出错将邮件发送给谁
MAILTO=user_name或者你的qq邮箱
#每两个小时输出
0 *2 * * * echo "Have a break now." >> /tmp/test.txt  
#每分钟运行一遍
* * * * * python myProjectPath/main.py
#每三分钟执行
*/3 * * * * your_command
```
* 删除任务
```
crontab -r
```
