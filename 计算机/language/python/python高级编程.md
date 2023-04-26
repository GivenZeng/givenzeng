### __slots__
给实例、类动态绑定属性和方法
```
s.name = 'Michael' # 动态给实例绑定一个属性

def set_age(self, age): # 定义一个函数作为实例方法
     self.age = age

from types import MethodType
s.set_age = MethodType(set_age, s) # 给实例绑定一个方法，但是，给一个实例绑定的方法，对另一个实例是不起作用的
s.set_age(25) # 调用实例方法

给class绑定方法
def set_score(self, score):
     self.score = score

Student.set_score = set_score
```
通常情况下，上面的set_score方法可以直接定义在class中，但动态绑定允许我们在程序运行的过程中动态给class加上功能，这在静态语言中很难实现。

限制实例的属性怎么办？比如，只允许对Student实例添加name和age属性。定义一个特殊的__slots__变量，来限制该class实例能添加的属性。使用__slots__要注意，\__slots__定义的属性仅对当前类实例起作用，对继承的子类是不起作用的

```
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称

s = Student() # 创建新的实例
s.name = 'Michael' # 绑定属性'name'
s.age = 25 # 绑定属性'age'
//非法操作：s.score = 99 # 绑定属性'score'    
```

### @property
Python内置的@property装饰器就是负责把一个方法变成属性调用的

```
class Student(object):
    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
```
还可以定义只读属性，只定义getter方法，不定义setter方法就是一个只读属性


### 多重继承
```
class Dog(Mammal, Runnable):
    pass
```

## 定制类
我们可以定制一个类的特定行为，而不是采用默认行为
### __str__
复写类的该方法（该方法return一个string），可以在print(your_class_obj)时自动将其字符串化
### __repr__
可以将该方法等同于__str__,在类结构体中 __repr__=__str__
### __iter__
如果一个类想被用于for ... in循环，类似list或tuple那样，就必须实现一个__iter__()方法，该方法返回一个迭代对象，然后，Python的for循环就会不断调用该迭代对象的__next__()方法拿到循环的下一个值，直到遇到StopIteration错误时退出循环。
```
class Fib(object):
    def __init__(self):
        self.a, self.b = 0, 1 # 初始化两个计数器a，b

    def __iter__(self):
        return self # 实例本身就是迭代对象，故返回自己

    def __next__(self):
        self.a, self.b = self.b, self.a + self.b # 计算下一个值
        if self.a > 100000: # 退出循环的条件
            raise StopIteration()
        return self.a # 返回下一个值

for n in Fib():
    print(n)

```
### __getitem__
表现得像list那样按照下标取出元素或者切片，需要实现__getitem__()方法
```
def __getitem__(self, n):
       a, b = 1, 1
       for x in range(n):
           a, b = b, a + b
       return a
       if isinstance(n, slice): # n是切片
            start = n.start
            stop = n.stop
            if start is None:
                start = 0
            a, b = 1, 1
            L = []
            for x in range(stop):
                if x >= start:
                    L.append(a)
                a, b = b, a + b
            return L

your_class_obj[5]
your_class_obj[3:9]
```
### __getattr__
your_class_obj.attr,当attr不存在的时候，会使用__getattr__的返回值，而不是抛出错误。
```
def __getattr__(self, attr):
    if attr=='age':
        return lambda: 25
    raise AttributeError('\'Student\' object has no attribute \'%s\'' % attr)
```


### 枚举
```
from enum import Enum

Month = Enum('Month', ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
# name 是枚举名，member是Enumclass.枚举名，member.value是枚举值，默认从1开始
for name, member in Month.__members__.items():
    print(name, member , member.value)
```
输出
```
jan Month.jan 1
feb Month.feb 2
mar Month.mar 3
```
也可以从Enum派生出自定义
```
from enum import Enum, unique

@unique
class Weekday(Enum):
    Sun = 0 # Sun的value被设定为0
    Mon = 1
    Tue = 2
    Wed = 3
    Thu = 4
    Fri = 5
    Sat = 6
```
