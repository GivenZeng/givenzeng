### 文件
```
with open('dir1/dir2/file','r',encoding='gbk',errors='ignore') as f:
	print(f.read())
```

- open方法：
	- 参数：文件路径，模式mode，编码方式，错误处理
	- mode：r-只读，w-读写，rb-读二进制，wb-写二进制，a-追加append
	- encoding：默认为utf-8
	- errors：默认不忽略
- read：
	- content = f.read()  //读取整个文件
	- f.write('xxx')  //覆盖性写

### StringIO、BytesIO
stringIO顾名思义就是在内存中读写str。
```
from io import StringIO

f = StringIO()
f.write('xxx')
content = f.getvalue()

while True:
	s = f.readline()
	if s == '':
		braek
	print(s.strp())	
```


StringIO操作的只能是str，如果要操作二进制数据，就需要使用BytesIO。

BytesIO实现了在内存中读写bytes，我们创建一个BytesIO，然后写入一些bytes

```
from io import BytesIO

f = ByteIO
f.write('hello'.encode('utf-8'))
b = f.read()
```

### 操纵文件和目录

