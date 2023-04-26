## Ref
- [document](https://golang.org/pkg/net/http/pprof/)
- [golang pprof 性能分析工具](http://www.hatlonely.com/2018/01/29/golang-pprof-%E6%80%A7%E8%83%BD%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7/index.html)
- [golang 内存分析/动态追踪](https://lrita.github.io/2017/05/26/golang-memory-pprof/)

```
import (
	_ "net/http/pprof"
)
```

go tool pprof http://localhost:port/debug/pprof/profile
go tool pprof http://localhost:port/debug/pprof/heap
go tool pprof http://localhost:port/debug/pprof/goroutine > profile.svg
wget http://localhost:xxx/debug/pprof/goroutine?debug=1
go tool pprof -svg http://localhost:port/debug/pprof/profile > profile.svg
go tool pprof http://localhost:port/debug/pprof/heap > heap.svp

https://segmentfaultain.com/a/1190000019222661
