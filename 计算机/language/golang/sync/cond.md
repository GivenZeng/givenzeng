Cond实现了一个条件变量，用于表示各goroutine可能产生等待的交汇点，或者用于通知某一时间的发生

每一个Cond都与Locker L（可以是Mutex或者RWMutex）联系起来；更改条件的时候必须持有锁L。

```
// 新建一个cond
func NewCond(l Locker) *Cond
// 唤醒所有等待该cond的goroutine
func (c *Cond) Broadcast()
// 唤醒一个等待该cond的goroutine
func (c *Cond) Signal()
// 等待该cond
func (c *Cond) Wait()
```

Wait操作会自动将L解锁，并且使得调用Wait的goroutine阻塞。在恢复执行（即被其他goroutine唤醒）后，会在返回前锁定L。不像其他系统，Wait在被Broadcast或者Signal唤醒之前是不会返回的

由于Wait一开始恢复执行的时候L不是锁定状态（其他goroutine可能在Wait刚恢复的时候又修改了condition），因此，当Wait返回的时候，调用者不能假定conditon已经是true。调用者应该在一个循环中使用Wait
```
c.L.Lock()
for !condition() {
    c.Wait()
}
... make use of condition ...
c.L.Unlock()
```
