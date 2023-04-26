StartCoroutine 函数用于开始一个协同程序，但不是另外开启一个线程，协同程序与 StartCoroutine 函数在同一个线程之内；但是协同程序可以实现“线程切换”的效果，通过 yield 关键字，可以实现在某个事件发生时，线程的控制权回到协同程序。一个协同程序在执行过程中，会在使用了 yield 语句的位置暂停。yield 的返回值控制何时恢复协同程序向下执行。


```c#
void Start()
{
   print("Starting " +Time.time); // 1
   StartCoroutine(WaitAndPrint(2)); // 2
   print("Done " +Time.time); // 3
}

IEnumerator WaitAndPrint(float waitTime)
{
   yield return new WaitForSeconds(waitTime); // 4
   print("WaitAndPrint " + Time.time);// 5
}
```
代码的执行顺序是：12435。执行到 4 时，协程注册事件，控制权交出给外部线程；外部线程执行3；当协程注册的事件发生时，控制权将由外部线程回到协程，从上一次执行处继续执行。



## yield
yield 后面可以跟的表达式有：
- return null：下个 Update 之后恢复
- return new WaitForEndOfFrame：下个 OnGUI 之后恢复
- return new WaitForFixedUpdate()：下个 FixedUpdate 之后恢复，有可能一帧内多次执行
- return new WaitForSeconds(2)：2秒后，等下个Update之后恢复。WaitForSeconds 受 Time.timeScale 影响，当Time.timeScale = 0f 时，yield return new WaitForSecond(x) 将不会恢复
- return new WWW(url)：Web请求完成了，Update之后恢复
- return StartCorourtine()：新的协成完成了，Update之后恢复
- break：退出协程
- return Application.LoadLevelAsync(levelName)：load level 完成后恢复，用于异步加载场景
- return Resources.UnloadUnusedAssets()：unload 完成后恢复


## 规则
- 返回值必须是 IEnumerator
- 参数不能加 ref 或 out
- 函数 Update 和 FixedUpdate 中不能使用 yield 语句，但可以启动协程
- yield return 语句不能位于 try－catch 语句块中
- yield return 不能放在匿名方法中
- yield return 不能放在unsafe语句块中