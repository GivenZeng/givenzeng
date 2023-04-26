## Server

https://www.jianshu.com/p/be3d9cdc680b

### example
```
package main

import (
    "fmt"
    "net/http"
)

func IndexHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "hello world")
}

func main() {
    http.HandleFunc("/", IndexHandler)
    http.ListenAndServe("127.0.0.0:8000", nil)
}
```

### http
网络发展，很多网络应用都是构建再 HTTP 服务基础之上。HTTP 协议从诞生到现在，发展从1.0，1.1到2.0也不断再进步。除去细节，理解 HTTP 构建的网络应用只要关注两个端---客户端（clinet）和服务端（server），两个端的交互来自 clinet 的 request，以及server端的response。所谓的http服务器，主要在于如何接受 clinet 的 request，并向client返回response。

接收request的过程中，最重要的莫过于路由（router），即实现一个Multiplexer器。Go中既可以使用内置的mutilplexer --- DefautServeMux，也可以自定义。Multiplexer路由的目的就是为了找到处理器函数（handler），后者将对request进行处理，同时构建response。

因此，理解go中的http服务，最重要就是要理解Multiplexer和handler，Golang中的Multiplexer基于ServeMux结构，同时也实现了Handler接口。


* hander函数： 具有func(w http.ResponseWriter, r \*http.Requests)签名的函数
* handler处理器(函数): 经过HandlerFunc结构包装的handler函数，它实现了ServeHTTP接口方法的函数。调用handler处理器的ServeHTTP方法时，即调用handler函数本身。
* handler对象：实现了Handler接口ServeHTTP方法的结构。


> handler处理器和handler对象的差别在于，一个是函数，另外一个是结构，它们都有实现了ServeHTTP方法。很多情况下它们的功能类似，下文就使用统称为handler。这算是Golang通过接口实现的类动态类型吧。

![](./img/handler.jpeg)

handler 和 HandleFunc
```
type HandlerFunc func(ResponseWriter, *Request)

// ServeHTTP calls f(w, r).
func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
	f(w, r)
}
```

Golang的http处理流程:

![](./img/http_flow.png)


### Handler
Golang没有继承，类多态的方式可以通过接口实现。所谓接口则是定义声明了函数签名，任何结构只要实现了与接口函数签名相同的方法，就等同于实现了接口。go的http服务都是基于handler进行处理。
```
type Handler interface {
    ServeHTTP(ResponseWriter, *Request)
}
```

任何结构体，只要实现了ServeHTTP方法，这个结构就可以称之为handler对象。ServeMux会使用handler并调用其ServeHTTP方法处理请求并返回响应。


### ServeMux
```
type ServeMux struct {
	mu    sync.RWMutex
	m     map[string]muxEntry
	hosts bool // whether any patterns contain hostnames
}

type muxEntry struct {
	explicit bool
	h        Handler
	pattern  string
}
```
ServeMux结构中最重要的字段为m，这是一个map，key是一些url模式，value是一个muxEntry结构，后者里定义存储了具体的url模式和handler。

> 当然，所谓的ServeMux也实现了ServeHTTP接口，也算是一个handler，不过ServeMux的ServeHTTP方法不是用来处理request和respone，而是用来找到路由注册的handler。ServeMux的match方法，后面再做解释。


### Server
 除了ServeMux和Handler，还有一个结构Server需要了解。从http.ListenAndServe的源码可以看出，它创建了一个server对象，并调用server对象的ListenAndServe方法：
```
package http

func (srv *Server) ListenAndServe() error {
	addr := srv.Addr
	if addr == "" {
		addr = ":http"
	}
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		return err
	}
	return srv.Serve(tcpKeepAliveListener{ln.(*net.TCPListener)})
}

....
func ListenAndServe(addr string, handler Handler) error {
	server := &Server{Addr: addr, Handler: handler}
	return server.ListenAndServe()
}
...

```

Server 结构
```
type Server struct {
    Addr         string        
    Handler      Handler       
    ReadTimeout  time.Duration
    WriteTimeout time.Duration
    TLSConfig    *tls.Config   

    MaxHeaderBytes int

    TLSNextProto map[string]func(*Server, *tls.Conn, Handler)

    ConnState func(net.Conn, ConnState)
    ErrorLog *log.Logger
    disableKeepAlives int32     nextProtoOnce     sync.Once
    nextProtoErr      error     
}
```
server结构存储了服务器处理请求常见的字段。其中Handler字段也保留Handler接口。如果Server结构没有提供Handler结构对象，那么会使用DefautServeMux做multiplexer，后面再做分析。

## Client

### Send
```
resp, err := http.Get("http://example.com/")
...
resp, err := http.Post("http://example.com/upload", "image/jpeg", &buf)
...
resp, err := http.PostForm("http://example.com/form",
	url.Values{"key": {"Value"}, "id": {"123"}})

def resp.Body.Close()
body,err:=ioutil.ReadAll(resp.Body)
```

### Client
```
client := &http.Client{
	CheckRedirect: redirectPolicyFunc,
}
	
resp, err := client.Get("http://example.com")

// 控制请求头
req, err := http.NewRequest("GET", "http://example.com", nil)
// ...
req.Header.Add("If-None-Match", `W/"wyzzy"`)
resp, err := client.Do(req)
```

