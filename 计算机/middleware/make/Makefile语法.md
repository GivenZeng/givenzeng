http://www.ruanyifeng.com/blog/2015/02/make.html
# 注释
井号（#）在Makefile中表示注释：
```
# build a target
target:
  echo "hello"
```

# Echo
正常情况下，make会打印每条命令，然后再执行，这就叫做回声（echoing）。命令的前面加上@，就可以关闭回声:
```
# build a target
target:
  @echo "hello"
```
由于在构建过程中，需要了解当前在执行哪条命令，所以通常只在注释和纯显示的echo命令前面加上@。


# 通配符/正则
通配符（wildcard）用来指定一组符合条件的文件名。Makefile 的通配符与 Bash 一致，主要有星号（\*）、问号（？）和 [...] 。比如， \*.o 表示所有后缀名为o的文件。
```
clean:
        rm -f *.o
```

# 模式匹配


# 变量
Makefile 允许使用等号自定义变量。
```
txt = Hello World
test:
    @echo $(txt)
```
上面代码中，变量 txt 等于 Hello World。调用时，变量需要放在 $( ) 之中。

调用Shell变量，需要在美元符号前，再加一个美元符号，这是因为Make命令会对美元符号转义:
```
test:
    @echo $$HOME
```

有时，变量的值可能指向另一个变量:
```
v1 = $(v2)
```
Makefile一共提供了四个赋值运算符 （=、:=、？=、+=）[区别](https://stackoverflow.com/questions/448910/what-is-the-difference-between-the-gnu-makefile-variable-assignments-a)

```
VARIABLE = value
# 在执行时扩展，允许递归扩展。

VARIABLE := value
# 在定义时扩展。

VARIABLE ?= value
# 只有在该变量为空时才设置值。

VARIABLE += value
# 将值追加到变量的尾端。
```


# 内置变量
$@指代当前目标，就是Make命令当前构建的那个目标。
```
a.txt b.txt:
    touch $@     # equal to : touch a.txt;touch b.txt
```
$< 指代第一个前置条件。比如，规则为 t: p1 p2，那么$< 就指代p1。

```
a.txt: b.txt c.txt
    touch $<     # equal to : touch b.txt
```

* $? 指代比目标更新的所有前置条件，之间以空格分隔。比如，规则为 t: p1 p2，其中 p2 的时间戳比 t 新，$?就指代p2。
* $^ 指代所有前置条件，之间以空格分隔。比如，规则为 t: p1 p2，那么 $^ 就指代 p1 p2 。
* $* 指代匹配符 % 匹配的部分， 比如% 匹配 f1.txt 中的f1 ，$* 就表示 f1。
* $(@D) 和 $(@F) 分别指向 $@ 的目录名和文件名。比如，$@是 src/input.c，那么$(@D) 的值为 src ，$(@F) 的值* 为 input.c。
* $(<D) 和 $(<F) 分别指向 $< 的目录名和文件名。


# 循环与判断
Makefile使用 Bash 语法，完成判断和循环。

```
LIST = one two three
all:
    for i in $(LIST); do \
        echo $$i; \
    done
```

# 函数
Makefile 还可以使用函数，格式如下。
```
$(function arguments)
# 或者
${function arguments}
```

```
// shell 函数
srcfiles := $(shell echo src/{00..99}.txt)

// wildcard 函数用来在 Makefile 中，替换 Bash 的通配符。
srcfiles := $(wildcard src/*.txt)

// subst 函数用来文本替换，格式如下。
$(subst from,to,text)
$(subst ee,EE,feet on the street)



// patsubst 函数用于模式匹配的替换，格式如下：
$(patsubst pattern,replacement,text)
//下面的例子将文件名"x.c.c bar.c"，替换成"x.c.o bar.o"。
$(patsubst %.c,%.o,x.c.c bar.c)

//替换后缀名函数的写法是：变量名 + 冒号 + 后缀名替换规则。它实际上patsubst函数的一种简写形式。
min: $(OUTPUT:.js=.min.js)
```
