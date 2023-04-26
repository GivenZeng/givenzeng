## 文档
- [grpc中文文档](http://doc.oschina.net/grpc?t=58008)
- [grpc-gateway,restful和grpc转换库](https://github.com/grpc-ecosystem/grpc-gateway)
- [protobuf 官网](https://developers.google.com/protocol-buffers/docs/proto3)

## protobuf 
　Google Protocol Buffer(简称 Protobuf)是一种轻便高效的结构化数据存储格式，平台无关、语言无关、可扩展，可用于通讯协议和数据存储等领域。

### 优点
- 平台无关，语言无关，可扩展；
- 提供了友好的动态库，使用简单；
- 解析速度快，比对应的XML快约20-100倍；
- 序列化数据非常简洁、紧凑，与XML相比，其序列化之后的数据量约为1/3到1/10。

### 安装
参考 [golang使用protobuf](https://segmentfault.com/a/1190000009277748)
```
// 安装编译器
https://github.com/google/protobuf/releases // 下载并编译、安装
tar -xvf protobuf_xxxx
cd protobuf_xxx
./configure
sudo make 
sudo make install

// 库
go get github.com/golang/protobuf/proto   // golang的protobuf库文件

// 插件
go get github.com/golang/protobuf/protoc-gen-go  // 用于根据protobuf生成golang代码，语法 protoc --go_out=. *.proto
```

### 语法
book/book.proto
```
syntax="proto3";
package book;

// import "xxx/xx.proto"

// 出版社
message Publisher{
	required string name = 1
}  
// 书籍信息
message Book {
 	required string name = 1;
	message Author {
		required string name = 1;
		required string address = 1;
	}
	required Author author = 2;

	enum BookType{
		SCIENCE = 1 ;
		LITERATURE = 2;
	}

	optional BookType type = 3;
	optional Publisher publisher = 4
}
```

- syntax="proto3":指定protobuf的版本
- package book:声明一个报名，一般与文件目录名相同
- import "xxx/xx.proto":导入其他的包，这样你就可以使用其他的包的数据结构
- required、optional、repeated:表示该字段是否必须填充；required表示必须指定且只能指定一个；当optional表示可选，可指定也可不指定，但不可超过一个不指定值的时候会采用空值，如string类型的字段会用字符串表示；repeated表示可以重复，类似与编程语言中的list
- message Author：在一个message体内定义一个message结构体
- enum：是枚举类型结构体
- 数字：字段的标识符，不可重复
- 数据类型： int32、int64、uint32、uint64、sint32、sint64、double、float、 string、bool、bytes、enum、message等等

### 在golang使用
protobuf采用以上的book.proto文件

并使用以下命令生成go文件
```
protoc --go_out=. *.proto
```

在代码中使用
```
package main

import (
    b "book"
    "github.com/golang/protobuf/proto"
)

func main(){
	...
	// 将实例转为proto编码
	var b = &b.Book{Name:"xxx", Author:b.Author{Name:"yyy"}}
	protoBook, err := proto.Marshal(b)
	...
	// 讲proto编码转化为实例
	var b2 b.Book
	err = proto.Unmarshal(protoBook, &b2)	
	...
}
```

## grpc
gRPC是由Google主导开发的RPC框架，使用HTTP/2协议并用ProtoBuf作为序列化工具。其客户端提供Objective-C、Java接口，服务器侧则有Java、Golang、C++等接口。使用grpc可以方便的调用其他进程的方法，调用需要传输的数据使用的是proto编码。这对于大型项目来说，可以有效的提高数据的解编码效率和数据传输率。

### proto service定义
一个RPC service就是一个能够通过参数和返回值进行远程调用的method，我们可以简单地将它理解成一个函数。因为gRPC是通过将数据编码成protocal buffer来实现传输的。因此，我们通过protocal buffers interface definitioin language(IDL)来定义service method，同时将参数和返回值也定义成protocal buffer message类型。具体实现如下所示，包含下面代码的文件叫helloworld.proto：
```
syntax = "proto3";
 
 package helloworld;
 
// The greeter service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}
 
// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}
 
// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```
接着，根据上述定义的service，我们可以利用protocal buffer compiler ，即protoc生成相应的服务器端和客户端的GoLang代码。生成的代码中包含了客户端能够进行RPC的方法以及服务器端需要进行实现的接口。

假设现在所在的目录是$GOPATH/src/helloworld/helloworld，我们将通过如下命令生成gRPC对应的GoLang代码：
```
protoc --go_out=plugins=grpc:. helloworld.proto
```
此时，将在目录下生成helloworld.pb.go文件

### server
server.go
```
package main
 
// server.go
 
import (
    "log"
    "net"
 
    "golang.org/x/net/context"
    "google.golang.org/grpc"
    pb "helloworld/helloworld"
)
 
const (
    port = ":50051"
)
 
type server struct {}

// 当接收到请求的时候回调用该方法
// 参数由grpc自己根据请求进行构造 
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
    return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}
 
func main() {
    lis, err := net.Listen("tcp", port)
    if err != nil {
        log.Fatal("failed to listen: %v", err)
    }
    s := grpc.NewServer()
    pb.RegisterGreeterServer(s, &server{})
    s.Serve(lis)
}
```
其中pb是我们刚才根据proto生成的go文件的包

### client
```
package main
 
//client.go
 
import (
    "log"
    "os"
 
    "golang.org/x/net/context"
    "google.golang.org/grpc"
    pb "helloworld/helloworld"
)
 
const (
    address     = "localhost:50051"
    defaultName = "world"
)
 
func main() {
	// 建立一个grpc连接
    conn, err := grpc.Dial(address, grpc.WithInsecure())
    if err != nil {
        log.Fatal("did not connect: %v", err)
    }
    defer conn.Close()
	// 新建一个客户端，方法为：NewXXXClinent(conn),XXX为你在proto定义的服务的名字
    c := pb.NewGreeterClient(conn)
 
    name := defaultName
    if len(os.Args) >1 {
        name = os.Args[1]
    }
	// 调用远程，并得到返回
    r, err := c.SayHello(context.Background(), &pb.HelloRequest{Name: name})
    if err != nil {
        log.Fatal("could not greet: %v", err)
    }
    log.Printf("Greeting: %s", r.Message)
}

```

## restful转grpc
使用grpc的优点很多，二进制的数据可以加快传输速度，基于http2的多路复用可以减少服务之间的连接次数，和函数一样的调用方式也有效的提升了开发效率。不过使用grpc也会面临一个问题，我们的微服务对外一定是要提供Restful接口的，如果内部调用使用grpc，在某些情况下要同时提供一个功能的两套API接口，这样就不仅降低了开发效率，也增加了调试的复杂度。于是就想着有没有一个转换机制，让Restful和gprc可以相互转化。

[grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway)应运而生

### 安装
首先你得要根据本文之前的步骤安装proto和grpc，然后如下安装一些库
```
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger
go get -u github.com/golang/protobuf/protoc-gen-go
```

### 用法
#### 定义service的proto文件
```
 syntax = "proto3";
 package example;

 import "google/api/annotations.proto";

 message StringMessage {
   string value = 1;
 }
 
 service YourService {
   rpc Echo(StringMessage) returns (StringMessage) {
     option (google.api.http) = {
       post: "/v1/example/echo"
       body: "*"
     };
   }
 }

```
option 表示处理哪些path的请求以及如何处理请求体（参数），见https://cloud.google.com/service-management/reference/rpc/google.api#http

生成go文件
```
protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
  --go_out=plugins=grpc:. \
  path/to/your_service.proto

protoc -I/usr/local/include -I. \
  -I$GOPATH/src \
  -I$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
  --grpc-gateway_out=logtostderr=true:. \
  path/to/your_service.proto
```
以上生成的两个文件，第一个是pb.go文件，给grpc server用的；第二个是pb.gw.go文件，给grpc-gateway用的，用于grpc和restful的相互转化

#### 服务器
```
package main

import (
  "flag"
  "net/http"

  "github.com/golang/glog"
  "golang.org/x/net/context"
  "github.com/grpc-ecosystem/grpc-gateway/runtime"
  "google.golang.org/grpc"
	
  gw "path/to/your_service_package"
)

var (
  echoEndpoint = flag.String("echo_endpoint", "localhost:9090", "endpoint of YourService")
)

func run() error {
  ctx := context.Background()
  ctx, cancel := context.WithCancel(ctx)
  defer cancel()

  mux := runtime.NewServeMux()
  opts := []grpc.DialOption{grpc.WithInsecure()}
  err := gw.RegisterYourServiceHandlerFromEndpoint(ctx, mux, *echoEndpoint, opts)
  if err != nil {
    return err
  }

  return http.ListenAndServe(":8080", mux)
}

func main() {
  flag.Parse()
  defer glog.Flush()

  if err := run(); err != nil {
    glog.Fatal(err)
  }
}
```

#### 测试
```
curl -X POST -k http://localhost:8080/v1/example/echo -d '{"name": " world"}

{"message":"Hello  world"}
```

流程如下：curl用post向gateway发送请求，gateway作为proxy将请求转化一下通过grpc转发给greeter_server，greeter_server通过grpc返回结果，gateway收到结果后，转化成json返回给前端。








