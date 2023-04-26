用于解释命令行参数
```
import argparse
parser = argparse.ArgumentParser()
#注册参数
args=parser.parse_args()
```

### 注册参数
```
# 注册一个名字为a的参数，默认是必选
parser.add_argument("a")
    ....
print(args.a)

# 注册一个参数，并且提供help信息
parser.add_argument("echo", help="echo the string you use here")

#help信息可以通过--help查看：python main.py --help
```
注册的参数默认是str类型


### 可选参数
#### 值类型可选参数
```
parser.add_argument("--verbosity", help="increase output verbosity")

#python main.py --berbosity value
```
#### 行为类型可选参数
```
parser.add_argument("--verbose", help="increase output verbosity",action="store_true")
# 如果命令行提供了--verbose，则给他一个值True
#pytthon main.py --verbose
```

#### 参数名简写
```
parser.add_argument("-v", "--verbose", help="increase output verbosity",action="store_true")

#python main.py -v
#程序中访问：args.verbosity
```

#### 指定参数类型
```
parser.add_argument("square", type=int,help="display a square of a given number")
parser.add_argument("-v", "--verbose", action="store_true",help="increase output verbosity")

#python main.py 4 -v
```

#### 多值行为
```
parser.add_argument("-v", "--verbosity", type=int,help="increase output verbosity")
```

#### 指定可选值的参数
```
parser.add_argument("-v", "--verbosity", type=int, choices=[0, 1, 2],help="increase output verbosity")
```

#### 参数名计数
```
parser.add_argument("-v", "--verbosity", action="count",help="increase output verbosity")

#python main.py -vv
#args.verbose=2
```
