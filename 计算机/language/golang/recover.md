
1、Painc用法是：用于抛出错误。Recover()用法是：将Recover()写在defer中，并且在可能发生panic的地方之前，先调用此defer的东西（让系统方法域结束时，有代码要执行。）当程序遇到panic的时候（当然，也可以正常的调用出现的异常情况），系统将跳过后面的代码，进入defer，如果defer函数中recover()，则返回捕获到的panic的值。
```
package main

import "fmt"

func main() {
    fmt.Printf("hello world my name is %s, I'm %d\r\n", "songxingzhu", 26)
    defer func() {
        if err := recover(); err != nil {
            fmt.Println("出了错：", err)
        }
    }()
    myPainc()
    fmt.Printf("这里应该执行不到！")
}
func myPainc() {
    var x = 30
    var y = 0
    //panic("我就是一个大错误！")
    var c = x / y
    fmt.Println(c)
}
```
