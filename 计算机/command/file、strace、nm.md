# file
file命令用来探测给定文件的类型。file命令对文件的检查分为文件系统、魔法幻数检查和语言检查3个过程。

```
[root@localhost ~]# file /usr/local/executalbe_file
minikube: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, not stripped

[root@localhost ~]# file install.log
install.log: UTF-8 Unicode text

[root@localhost ~]# file -b install.log      <== 不显示文件名称
UTF-8 Unicode text

[root@localhost ~]# file -i install.log      <== 显示MIME类别。
install.log: text/plain; charset=utf-8

[root@localhost ~]# file -b -i install.log
text/plain; charset=utf-8
```

# strace
strace常用来跟踪进程执行时的系统调用和所接收的信号。 在Linux世界，进程不能直接访问硬件设备，当进程需要访问硬件设备(比如读取磁盘文件，接收网络数据等等)时，必须由用户态模式切换至内核态模式，通 过系统调用访问硬件设备。strace可以跟踪到一个进程产生的系统调用,包括参数，返回值，执行消耗的时间。

```
// 执行文件，并跟踪系统调用
strace [optional arg] executable_file

// 执行文件，并跟踪系统调用
// -c 统计每一系统调用的所执行的时间,次数和出错的次数等.
// -t 为时间占比
// -o 输入到文件
strace -c -t -o log.txt executable_file

// 跟踪和网络相关的系统调用
// -p跟踪指定的进程pid; -f 跟踪由fork调用所产生的子进程.
// -s 指定输出的字符串的最大长度.默认为32.文件名一直全部输出.
strace -f -s -e trace=network -p $pid_value 
```

# nm
nm 命令显示关于指定 File 中符号的信息，文件可以是对象文件、可执行文件或对象文件库。如果文件没有包含符号信息，nm 命令报告该情况，但不把它解释为出错条件。 nm 命令缺省情况下报告十进制符号表示法下的数字值。

```
zengjiwen at n227-074-004 in ~/go/src/gitlabhost/ad/cloud_backend/output/bin (hotfix/tos_filetype)
$ nm ad.game.oahyoo_cloud |grep accept
0000000000f78ab0 T github.com/magiconair/properties.(*lexer).accept
0000000000f78b40 T github.com/magiconair/properties.(*lexer).acceptRun
00000000004ab8a0 T internal/poll.accept
00000000005c6c00 T net.(*netFD).accept
00000000005e4700 T net.(*TCPListener).accept
00000000005eb820 T net.(*UnixListener).accept
0000000000490b90 T syscall.accept
0000000000490ca0 T syscall.accept4
00000000015f34c0 R syscall.accept4.stkobj
00000000015f3480 R syscall.accept.stkobj
0000000000b1a4c0 T text/template/parse.(*lexer).accept
0000000000b1a580 T text/template/parse.(*lexer).acceptRun
0000000001f776c0 D unicode/utf8.acceptRanges
```

可用于：
- 查找undefile符号
```
// -u或–undefined-only：仅显示没有定义的符号(那些外部符号)。
// -C或–demangle：将低级符号名解析(demangle)成用户级名字。这样可以使得C++函数名具有可读性。
nm -uCA *.o | grep foo
```
- 列出静态符号、外部符号
```
nm -e a.out
```