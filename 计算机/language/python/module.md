### 模块
```
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

' a test module '

__author__ = 'Michael Liao'

import sys

def test():
    args = sys.argv
    if len(args)==1:
        print('Hello, world!')
    elif len(args)==2:
        print('Hello, %s!' % args[1])
    else:
        print('Too many arguments!')

if __name__=='__main__':
    test()
```

第1行和第2行是标准注释，第1行注释可以让这个hello.py文件直接在Unix/Linux/Mac上运行，第2行注释表示.py文件本身使用标准UTF-8编码；

第4行是一个字符串，表示模块的文档注释，任何模块代码的第一个字符串都被视为模块的文档注释；

第6行使用__author__变量把作者写进去，这样当你公开源代码后别人就可以瞻仰你的大名；    
有的函数和变量我们希望仅仅在模块内部使用。在Python中，是通过_前缀来实现的。
类似__xxx__这样的变量是特殊变量，可以被直接引用，类似_xxx和__xxx这样的函数或变量就是非公开的（private），不应该被直接引用


- 每一个包目录下面都会有一个__init__.py的文件，这个文件是必须存在的，否则，Python就把这个目录当成普通目录，而不是一个包。__init__.py可以是空文件，也可以有Python代码
- 有的函数和变量我们希望仅仅在模块内部使用。在Python中，是通过_前缀来实现的。
  - 正常的函数和变量名是公开的（public），可以被直接引用，比如：abc，x123，PI等；
  - 类似__xxx__这样的变量是特殊变量，可以被直接引用，但是有特殊用途，比如上面的__author__，__name__就是特殊变量，hello模块定义的文档注释也可以用特殊变量__doc__访问，我们自己的变量一般不要用这种变量名；
  - 类似_xxx和__xxx这样的函数或变量就是非公开的（private），不应该被直接引用，比如_abc，__abc等；

### 安装第三方模块
```
pip install Pillow
```

### 模块搜索
- 当我们试图加载一个模块时，Python会在指定的路径下搜索对应的.py文件，如果找不到，就会报错
- 默认情况下，Python解释器会搜索当前目录、所有已安装的内置模块和第三方模块
- 如果我们要添加自己的搜索目录，有两种方法
	- 直接修改sys.path，添加要搜索的目录
	```
	>>> import sys
	>>> sys.path
	['', '/Library/Python/2.7/site-packages/pycrypto-2.6.1-py2.7-macosx-10.9-intel.egg', '/Library/Python/2.7/site-packages/PIL-1.1.7-py2.7-macosx-10.9-intel.egg', ...]
	```
	- 第二种方法是设置环境变量PYTHONPATH，该环境变量的内容会被自动添加到模块搜索路径中。设置方式与设置Path环境变量类似。注意只需要添加你自己的搜索路径，Python自己本身的搜索路径不受影响。

### 推荐目录结构：
```
AdFetchExtractor                                                                                                                                                                                                   
├── AdFetchExtractor                                                                                                                                                                                               
│   ├── conf                                                                                                                                                                   │   │   ├── conf.py                                                                                                                                                                                                
│   │   ├── conf.sample.py                                                                                                                                                                                         
│   │   ├── __init__.py                                                                                                                                                                                        
│   ├── __init__.py                                 
│   ├── log                                         
│   │   ├── __init__.py                             
│   │   ├── log.py                                  
│   ├── main.py
|——other_file
```


### 运行
```
python -m xxx.py //当作模块来运行，会将pwd也加入模块搜索目录。推荐的运行方式
python xxx.py // 直接运行
```
