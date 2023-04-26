## 文档
- [中文文档](http://docs.jinkan.org/docs/celery/getting-started/first-steps-with-celery.html)
- [官方文档](http://docs.celeryproject.org/en/latest/userguide/workers.html)
- [celery定时服务、celery与django结合使用](https://www.cnblogs.com/jonathan1314/p/7649249.html#3000)

## 简介
Celery 是一个“自带电池”的的任务队列。它易于使用，所以你可以无视其所解决问题的复杂程度而轻松入门。它遵照最佳实践设计，所以你的产品可以扩展，或与其他语言集成，并且它自带了在生产环境中运行这样一个系统所需的工具和支持。

Celery 的最基础部分。包括：
* 选择和安装消息传输方式（中间人）----broker，如RabbitMQ，redis等。
  - RabbitMQ的安装：sudo apt-get install rabbitmq-server
  - 本文使用redis
  - 官方推荐RabbitMQ
  - 当然部分nosql也可以
* 安装 Celery 并创建第一个任务
* 运行职程并调用任务。
* 追踪任务在不同状态间的迁移，并检视返回值。

## 安装
```
pip install celery
```
## 简单使用
### 定义任务
tasks.py
```
from celery import Celery
#第一个参数是你的celery名称
#backen 用于存储结果
#broker 用于存储消息队列
app = Celery('tasks',backend='redis://:password@host:port/db', broker='redis://:password@host:port/db')

@app.task
def add(x, y):
    return x + y
```
Celery 的第一个参数是当前模块的名称，这个参数是必须的，这样的话名称可以自动生成。第二个参数是中间人关键字参数，指定你所使用的消息中间人的 URL，此处使用了 RabbitMQ，也是默认的选项。更多可选的中间人见上面的 选择中间人 一节。例如，对于 RabbitMQ 你可以写 amqp://localhost ，而对于 Redis 你可以写 redis://localhost .

你定义了一个单一任务，称为 add ，返回两个数字的和。

### 启动celery服务
步骤：
- 启动任务工作者worker
- 讲任务放入celery队列
- worker读取队列，并执行任务

启动一个工作者，创建一个任务队列
```
// -A 指定celery名称，loglevel制定log级别，只有大于或等于该级别才会输出到日志文件
celery -A tasks worker --loglevel=info
```
如果你没有安装redis库，请先pip install redis

### 使用celery
现在我们已经有一个celery队列了，我门只需要将工作所需的参数放入队列即可
```
from tasks import add
#调用任务会返回一个 AsyncResult 实例，可用于检查任务的状态，等待任务完成或获取返回值（如果任务失败，则为异常和回溯）。
#但这个功能默认是不开启的，你需要设置一个 Celery 的结果后端(即backen，我们在tasks.py中已经设置了，backen就是用来存储我们的计算结果)
result=add.delay(4, 4)
#如果任务已经完成
if(result.ready()):
  #获取任务执行结果
  print(result.get(timeout=1))
```
常用接口
- tasks.add(4,6) ---> 本地执行
- tasks.add.delay(3,4) --> worker执行
- t=tasks.add.delay(3,4)  --> t.get()  获取结果，或卡住，阻塞
- t.ready()---> False：未执行完，True：已执行完
- t.get(propagate=False) 抛出简单异常，但程序不会停止
- t.traceback 追踪完整异常


## 使用配置
* 使用配置来运行，对于正式项目来说可维护性更好。配置可以使用app.config.XXXXX_XXX='XXX'的形式如app.conf.CELERY_TASK_SERIALIZER = 'json'来进行配置
* [配置资料](http://docs.jinkan.org/docs/celery/configuration.html#broker-settings)

### 配置文件
config.py
```
#broker
BROKER_URL = 'redis://:password@host:port/db'
#backen
CELERY_RESULT_BACKEND = 'redis://:password@host:port/db'
#导入任务，如tasks.py
CELERY_IMPORTS = ('tasks', )
#列化任务载荷的默认的序列化方式
CELERY_TASK_SERIALIZER = 'json'
#结果序列化方式
CELERY_RESULT_SERIALIZER = 'json'

CELERY_ACCEPT_CONTENT=['json']
#时间地区与形式
CELERY_TIMEZONE = 'Europe/Oslo'
#时间是否使用utc形式
CELERY_ENABLE_UTC = True

#设置任务的优先级或任务每分钟最多执行次数
CELERY_ROUTES = {
    # 如果设置了低优先级，则可能很久都没结果
    #'tasks.add': 'low-priority',
    #'tasks.add': {'rate_limit': '10/m'}，
    #'tasks.add': {'rate_limit': '10/s'}，
    #'*': {'rate_limit': '10/s'}
}
#borker池，默认是10
BROKER_POOL_LIMIT = 10
#任务过期时间，单位为s，默认为一天
CELERY_TASK_RESULT_EXPIRES = 3600
#backen缓存结果的数目，默认5000
CELERY_MAX_CACHED_RESULTS = 10000
```

### 开启服务
celery.py

```
from celery import Celery
#指定名称
app = Celery('mycelery')
#加载配置模块
app.config_from_object('config')

if __name__=='__main__':
      app.start()
```

### 任务定义
tasks.py
```
from .celery import app
@app.task
def add(a, b):
  return a + b
```

### 启动
```
// -l 是 --loglevel的简写
celery -A mycelery worker -l info
```
### 执行/调用服务
```
from tasks import add
#调用任务会返回一个 AsyncResult 实例，可用于检查任务的状态，等待任务完成或获取返回值（如果任务失败，则为异常和回溯）。
#但这个功能默认是不开启的，你需要设置一个 Celery 的结果后端(即backen，我们在tasks.py中已经设置了，backen就是用来存储我们的计算结果)
result=add.delay(4, 4)
#如果任务已经完成
if(result.ready()):
  #获取任务执行结果
  print(result.get(timeout = 1))
```

## 分布式
- 启动多个celery worker，这样即使一个worker挂掉了其他worker也能继续提供服务
  - 方法一
  ```
  // 启动三个worker：w1,w2,w3
  celery multi start w1 -A project -l info
  celery multi start w2 -A project -l info
  celery multi start w3 -A project -l info
  // 立即停止w1,w2，即便现在有正在处理的任务
  celery multi stop w1 w2
  // 重启w1
  celery multi restart w1 -A project -l info
  // celery multi stopwait w1 w2 w3    # 待任务执行完，停止
  ```
  - 方法二
  ```
  // 启动多个worker，但是不指定worker名字
  // 你可以在同一台机器上运行多个worker，但要为每个worker指定一个节点名字，使用--hostname或-n选项
  // concurrency指定处理进程数，默认与cpu数量相同，因此一般无需指定
  $ celery -A proj worker --loglevel=INFO --concurrency=10 -n worker1@%h
  $ celery -A proj worker --loglevel=INFO --concurrency=10 -n worker2@%h
  $ celery -A proj worker --loglevel=INFO --concurrency=10 -n worker3@%h
  ```

## 错误处理
celery可以指定在发生错误的情况下进行自定义的处理
config.py
```
def my_on_failure(self, exc, task_id, args, kwargs, einfo):
    print('Oh no! Task failed: {0!r}'.format(exc))

// 对所有类型的任务，当发生执行失败的时候所执行的操作
CELERY_ANNOTATIONS = {'*': {'on_failure': my_on_failure}}    
```
