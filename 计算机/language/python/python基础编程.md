#### 错误
```
raise TypeError('bad operand type')

try:
    print('try...')
    r = 10 / 0
    print('result:', r)
except ZeroDivisionError as e:
    print('except:', e)
finally:
    print('finally...')
else:
    pass
print('END')
```
- 当没有错误的时候回执行else
- 所有的错误类型都继承自BaseException

自定以错误
```
# err_raise.py
class FooError(ValueError):
    pass

def foo(s):
    n = int(s)
    if n==0:
        raise FooError('invalid value: %s' % s)
    return 10 / n

foo('0')
```
#### 函数
```
def nop():
    body或pass
```

#### 循环
```
for i in list/tuple/range(10):
	do something or pass
```

#### 函数返回多个值
```
import math
def move(x, y, step, angle=0):
    nx = x + step * math.cos(angle)
    ny = y - step * math.sin(angle)
    return nx, ny
```

函数参数
1. 位置参数，调用函数时，传入的两个值按照位置顺序依次赋给参数
2. 默认参数：def power(x, n=2)，必选参数在前，默认参数在后，否则Python的解释器会报错，默认参数必须指向不变对象
3. 可变参数：就是传入的参数个数是可变的。def calc(\*numbers):for n in numbers:.....，仅仅在参数前面加了一个*号。可变参数在函数调用时自动组装为一个tuple
4. 关键字参数：可变参数允许你传入0个或任意个参数，这些可变参数在函数调用时自动组装为一个tuple。而关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict。请看示例：

```
def person(name, age, **kw):
    print('name:', name, 'age:', age, 'other:', kw)

person('Bob', 35, city='Beijing')

name: Bob age: 35 other: {'city': 'Beijing'}    
```
5. 命名关键字参数：命名关键字参数需要一个特殊分隔符\*，\* 后面的参数被视为命名关键字参数。如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊分隔符*了

```
def person(name, age, *, city, job):
    print(name, age, city, job)

person('Jack', 24, city='Beijing', job='Engineer')
```
6. 参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。


### 切片list
```
l= ['Michael', 'Sarah', 'Tracy', 'Bob', 'Jack']
// 切片
l2=l[:3]
// 元素
val = l[2]
// 往某个位置添加元素，后面的元素要后移以为
l.insert(1, 'given')
// 追加元素
l.append('zeng')
// 删除并返回某个位置的元素
l.pop(2)
// list里面的元素的数据类型也可以不同
l.insert(3, True)
// 获取长度
len(s)

// 遍历，可以先获取长度然后使用元素下标或者如下
for i in l:
	do something
for in range(len(l))
```
### 元组 tuple
一种有序列表叫元组：tuple。tuple和list非常类似，但是tuple一旦初始化就不能修改

uple所谓的“不变”是说，tuple的每个元素，指向永远不变。即指向'a'，就不能改成指向'b'，指向一个list，就不能改成指向其他对象，但指向的这个list本身是可变的
```
t=('zeng','given')
// 元素
val = t[2]

// 遍历可同list
```

### 字典
dict的key必须是不可变对象。这是因为dict根据key来计算value的存储位置，如果每次计算相同的key得出的结果不同，那dict内部就完全混乱了。这个通过key计算位置的算法称为哈希算法（Hash）。
```
d = {'a': 1, 'b': 2, 'c': 3}
// 添加
d['name'] = 'given'

// 遍历
for key in d:
   print(key)
或
for value in d.values()
或
for k, v in d.items():
     print(k, '=', v)

// 判断key是否在dict
if 'name' in dict:
	do something with dict['name']
// 当key不存在的时候返回默认值
name = d.get('name', 'unknown')

// 删除
d.pop('name')

```

### set
- 存储不重复的value
- set可以看成数学意义上的无序和无重复元素的集合，因此，两个set可以做数学意义上的交集、并集等操作

```
s1 = set([1,2,5])
// 删除
s2.remove(5)

// 交并集合
s2 = set([1,3,5])
s3 = s2 & s1
s4 = s2 | s1
```
###　索引迭代
```
for i, value in enumerate(['A', 'B', 'C']):
```


### 列表生成式
```
l=list(range(1, 11))
l=[x * x for x in range(1, 11)]
l=[x * x for x in range(1, 11) if x % 2 == 0]
```

### 生成器
生成器是一类特殊的迭代器。生成器是只能遍历一次的。
- 第一类：生成器函数：还是使用 def 定义函数，但是，使用yield而不是return语句返回结果。yield语句一次返回一个结果，在每个结果中间，挂起函数的状态，以便下次从它离开的地方继续执行。
- 第二类：生成器表达式：类似于列表推导，只不过是把一对大括号[]变换为一对小括号()。但是，生成器表达式是按需产生一个生成器结果对象，要想拿到每一个元素，就需要循环遍历。

通过列表生成式，我们可以直接创建一个列表。但是，受到内存限制，列表容量肯定是有限的。而且，创建一个包含100万个元素的列表，不仅占用很大的存储空间，如果我们仅仅需要访问前面几个元素，那后面绝大多数元素占用的空间都白白浪费了。

所以，如果列表元素可以按照某种算法推算出来，那我们是否可以在循环的过程中不断推算出后续的元素呢？这样就不必创建完整的list，从而节省大量的空间。在Python中，这种一边循环一边计算的机制，称为生成器（Generator）。
```
>>> L = [x * x for x in range(10)]
>>> L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> g = (x * x for x in range(10))
>>> g
<generator object <genexpr> at 0x104feab40>

```

创建L和g的区别仅在于最外层的[]和()，L是一个list，而g是一个generator。

我们可以直接打印出list的每一个元素，但我们怎么打印出generator的每一个元素呢？

如果要一个一个打印出来，可以通过generator的next()方法：
```
 g.next()
```

generator保存的是算法，每次调用next()，就计算出下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出StopIteration的错误。当然，上面这种不断调用next()方法实在是太变态了，正确的方法是使用for循环，因为generator也是可迭代对象，同slice。


如果要生成的元素过于复杂，可以使用函数和yield来生成元素。函数是顺序执行，遇到return语句或者最后一行函数语句就返回。而变成generator的函数，在每次调用next()的时候执行，遇到yield语句返回，再次执行时从上次返回的yield语句处继续执行。


### 迭代器
实现了迭代器协议对象。list、tuple、dict都是Iterable（可迭代对象），但不是Iterator（迭代器对象）。但可以使用内建函数iter()，把这些都变成Iterable（可迭代器对象）。

迭代器有两个基本的方法：iter() 和 next()。
```
ist=[1,2,3,4]
it = iter(list)    # 创建迭代器对象
for x in it:
    print (x, end=" ")
```

- 把一个类作为一个迭代器使- 用需要在类中实现两个方法 __iter__() 与 __next__() 。
- __iter__() 方法返回一个特殊的迭代器对象， 这个迭代器对象实现了 __next__() 方法并通过 StopIteration 异常标识迭代的完成。
- __next__() 方法（Python 2 里是 next()）会返回下一个迭代器对象。

```
class MyNumbers:
  def __iter__(self):
    self.a = 1
    return self

  def __next__(self):
    if self.a <= 20:
      x = self.a
      self.a += 1
      return x
    else:
      raise StopIteration

myclass = MyNumbers()
myiter = iter(myclass)

for x in myiter:
  print(x)
```


### 面向对象
1. 如果要让内部属性不被外部访问，可以把属性的名称前加上两个下划线__，在Python中，实例的变量名如果以__开头，就变成了一个私有变量（private），只有内部可以访问，外部不能访问

```
class Student(object):

    def __init__(self, name, score):
        self.name = name
        self.score = score

    def print_score(self):
        print('%s: %s' % (self.name, self.score))

bart = Student('Bart Simpson', 59)
lisa = Student('Lisa Simpson', 87)
bart.print_score()
lisa.print_score()        
```

实例
1. 可以自由地给一个实例变量绑定属性，比如，给实例bart绑定一个name属性
2. 由于类可以起到模板的作用，因此，可以在创建实例的时候，把一些我们认为必须绑定的属性强制填写进去。通过定义一个特殊的__init__方法，在创建实例的时候，就把name，score等属性绑上去。有了__init__方法，在创建实例的时候，就不能传入空的参数了，必须传入与__init__方法匹配的参数，但self不需要传
3. 如果要获得一个对象的所有属性和方法，可以使用dir()函数，它返回一个包含字符串的list
4. 双下划线开头的实例变量是不是一定不能从外部访问呢？其实也不是。不能直接访问__name是因为Python解释器对外把__name变量改成了_Student__name，所以，仍然可以通过_Student__name来访问__name变量
5. 类方法：
```
@classmethod
def class_method(cls, formal_parameter): #类方法,可以访问类变量和实例变量
```
6. 静态方法：不能访问类变量和实例变量或方法
```
@staticmethod
def static_method(formal_parameter):
```

7. 类变量：类定义内部定义的变量（愚见，可以认为类内部没有self开头定义的变量，可以认为是类变量）
8. 成员变量：　类定义内部__init__函数内以self开头定义的变量
9. 实例方法：类内部定义的没有装饰器且第一个参数为self的函数，类方法的调用关系可以通过print后的表述得知。
10. 普通函数：　类内部定义的既没有装饰器，也没有参数self的函数，类方法的调用关系可以通过print后的表述得知。

#### 继承
class Dog(Animal)
1. 继承的好处：子类获得了父类的全部功能。由于Animial实现了run()方法，因此，Dog和Cat作为它的子类，什么事也没干，就自动拥有了run()方法
2. 当子类和父类都存在相同的run()方法时，我们说，子类的run()覆盖了父类的run()，在代码运行的时候，总是会调用子类的run()。这样，我们就获得了继承的另一个好处：多态
3. 判断一个变量是否是某个类型可以用isinstance()判断。在继承关系中，如果一个实例的数据类型是某个子类，那它的数据类型也可以被看做是父类
```
isinstance(cat, Cat) //True
isinstance(cat,Animal) //True
```

实例属性和类属性
可以直接在class中定义属性，这种属性是类属性
```
class Student(object):
    name = 'Student'
```
#### 获取对象信息
```
>>> type(123)
<class 'int'>
>>> type('str')
<class 'str'>
>>> type(None)
<type(None) 'NoneType'>
```
type()函数返回的是什么类型呢？它返回对应的Class类型。如果我们要在if语句中判断，就需要比较两个变量的type类型是否相同:
```
>>> type(123)==type(456)
True
>>> type(123)==int
True
>>> type('abc')==type('123')
True
>>> type('abc')==str
True
>>> type('abc')==type(123)
False

>>> import types
>>> def fn():
...     pass
...
>>> type(fn)==types.FunctionType // 判断一个函数的类型
True
>>> type(abs)==types.BuiltinFunctionType
True
>>> type(lambda x: x)==types.LambdaType
True
>>> type((x for x in range(10)))==types.GeneratorType
True

//判断一个变量是否是某些类型中的一种，比如下面的代码就可以判断是否是list或者tuple：
>>> isinstance([1, 2, 3], (list, tuple))
True
>>> isinstance((1, 2, 3), (list, tuple))
True
```

获取一个对象的所有属性和方法,dir()函数，它返回一个包含字符串的list，比如，获得一个str对象的所有属性和方法
```
dir(dog)

// 其他
>>> hasattr(obj, 'x') # 有属性'x'吗？
True
>>> obj.x
9
>>> hasattr(obj, 'y') # 有属性'y'吗？
False
>>> setattr(obj, 'y', 19) # 设置一个属性'y'
>>> hasattr(obj, 'y') # 有属性'y'吗？
True
>>> getattr(obj, 'y') # 获取属性'y'
19
>>> obj.y # 获取属性'y'
19
>>> getattr(obj,'y',404) # 如果属性y不存在就返回默认值
```




### 面向对象高级编程

#### 错误处理
Python的错误其实也是class，所有的错误类型都继承自BaseException，所以在使用except时需要注意的是，它不但捕获该类型的错误，还把其子类也“一网打尽。如果错误没有被捕获，它就会一直往上抛，最后被Python解释器捕获，打印一个错误信息，然后程序退出。

- 打印错误 logging.exception(e)
- 抛出错误
```
class FooError(ValueError):
    pass
raise FooError('invalid value: %s' % s)
```

```
try:
    print('try...')
    r = 10 / 0
    print('result:', r)
except ZeroDivisionError as e:
    print('except:', e)
finally:
    print('finally...')
print('END')
```

### 调试
```
assert n != 0, 'n is zero!'  //如果断言失败，assert语句本身就会抛出AssertionError

import logging
logging.basicConfig(level=logging.INFO)
logging.info('n = %d' % n) //和assert比，logging不会抛出错误，而且可以输出到文件
```

单元测试

mydict.py
```
class Dict(dict):

    def __init__(self, **kw):
        super().__init__(**kw)

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Dict' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value
```

mydict_test.py
```
import unittest

from mydict import Dict

class TestDict(unittest.TestCase):

    def test_init(self):
        d = Dict(a=1, b='test')
        self.assertEqual(d.a, 1)
        self.assertEqual(d.b, 'test')
        self.assertTrue(isinstance(d, dict))

    def test_key(self):
        d = Dict()
        d['key'] = 'value'
        self.assertEqual(d.key, 'value')

    def test_attr(self):
        d = Dict()
        d.key = 'value'
        self.assertTrue('key' in d)
        self.assertEqual(d['key'], 'value')

    def test_keyerror(self):
        d = Dict()
        with self.assertRaises(KeyError):
            value = d['empty']

    def test_attrerror(self):
        d = Dict()
        with self.assertRaises(AttributeError):
            value = d.empty

//运行单元测试。最简单的运行方式是在mydict_test.py的最后加上两行代码：

if __name__ == '__main__':
    unittest.main()     

另一种方法是在命令行通过参数-m unittest直接运行单元测试：

$ python -m unittest mydict_test           
```
可以在单元测试中编写两个特殊的setUp()和tearDown()方法。这两个方法会分别在每调用一个测试方法的前后分别被执行。
```
class TestDict(unittest.TestCase):

    def setUp(self):
        print('setUp...')

    def tearDown(self):
        print('tearDown...')
```
