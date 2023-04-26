A WaitGroup waits for a collection of goroutines to finish. The main goroutine calls Add to set the number of goroutines to wait for. Then each of the goroutines runs and calls Done when finished. At the same time, Wait can be used to block until all goroutines have finished.


一个 WaitGroup 会等待一系列 goroutine 直到它们全部运行完毕为止。 主 goroutine 通过调用 Add 方法来设置需要等待的 goroutine 数量， 而每个运行的 goroutine 则在它们运行完毕时调用 Done 方法。 与此同时， 调用 Wait 方法可以阻塞直到所有 goroutine 都运行完毕为止。
```
var wg sync.WaitGroup
var urls = []string{
        "http://www.golang.org/",
        "http://www.google.com/",
        "http://www.somestupidname.com/",
}
for _, url := range urls {
        // Increment the WaitGroup counter.
        wg.Add(1)
        // Launch a goroutine to fetch the URL.
        go func(url string) {
                // Decrement the counter when the goroutine completes.
                defer wg.Done()
                // Fetch the URL.
                http.Get(url)
        }(url)
}
// Wait for all HTTP fetches to complete.
wg.Wait()
```
