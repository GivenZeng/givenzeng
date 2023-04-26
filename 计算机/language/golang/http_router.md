[路由的实现原理](https://github.com/astaxie/build-web-application-with-golang/blob/master/zh/13.2.md)

目前几乎所有的Web应用路由实现都是基于http默认的路由器，但是Go自带的路由器有几个限制：
* 不支持参数设定，例如/user/:uid 这种泛类型匹配
* 无法很好的支持REST模式，无法限制访问的方法，例如上面的例子中，用户访问/foo，可以用GET、POST、DELETE、HEAD等方式访问
一般网站的路由规则太多了，编写繁琐。我前面自己开发了一个API应用，路由规则有三十几条，这种路由多了之后其实可以进一步简化，通过struct的方法进行一种简化

beego框架的路由器基于上面的几点限制考虑设计了一种REST方式的路由实现，路由设计也是基于上面Go默认设计的两点来考虑：存储路由和转发路由


### 路由信息的存储
我们设计了两个数据类型controllerInfo(保存路径和对应的struct，这里是一个reflect.Type类型)和ControllerRegistor(routers是一个slice用来保存用户添加的路由信息，以及beego框架的应用信息)
```
type controllerInfo struct {
	regex          *regexp.Regexp
	params         map[int]string
	controllerType reflect.Type
}

type ControllerRegistor struct {
	routers     []*controllerInfo
	Application *App
}

func (p *ControllerRegistor) Add(pattern string, c ControllerInterface)
```

ControllerRegistor对外的接口函数:用于添加路由并且将路径中参数规则提取出来
```
func (p *ControllerRegistor) Add(pattern string, c ControllerInterface) {
	parts := strings.Split(pattern, "/")

	j := 0
	params := make(map[int]string)
	for i, part := range parts {
		if strings.HasPrefix(part, ":") {
			expr := "([^/]+)"

			//a user may choose to override the defult expression
			// similar to expressjs: ‘/user/:id([0-9]+)’

			if index := strings.Index(part, "("); index != -1 {
				expr = part[index:]
				part = part[:index]
			}
			params[j] = part
			parts[i] = expr
			j++
		}
	}

	//recreate the url pattern, with parameters replaced
	//by regular expressions. then compile the regex

	pattern = strings.Join(parts, "/")
	regex, regexErr := regexp.Compile(pattern)
	if regexErr != nil {

		//TODO add error handling here to avoid panic
		panic(regexErr)
		return
	}

	//now create the Route
	t := reflect.Indirect(reflect.ValueOf(c)).Type()
	route := &controllerInfo{}
	route.regex = regex
	route.params = params
	route.controllerType = t

	p.routers = append(p.routers, route)

}
```

### 静态路由
上面我们实现的动态路由的实现，Go的http包默认支持静态文件处理FileServer，由于我们实现了自定义的路由器，那么静态文件也需要自己设定，beego的静态文件夹路径保存在全局变量StaticDir中，StaticDir是一个map类型，实现如下：

```
func (app *App) SetStaticPath(url string, path string) *App {
	StaticDir[url] = path
	return app
}
```


### 转发路由
转发路由是基于ControllerRegistor里的路由信息来进行转发的，即将对应的请求交给对应的controller处理
```
// AutoRoute
func (p *ControllerRegistor) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer func() {
		if err := recover(); err != nil {
			if !RecoverPanic {
				// go back to panic
				panic(err)
			} else {
				Critical("Handler crashed with error", err)
				for i := 1; ; i += 1 {
					_, file, line, ok := runtime.Caller(i)
					if !ok {
						break
					}
					Critical(file, line)
				}
			}
		}
	}()
	var started bool
	for prefix, staticDir := range StaticDir {
		if strings.HasPrefix(r.URL.Path, prefix) {
			file := staticDir + r.URL.Path[len(prefix):]
			http.ServeFile(w, r, file)
			started = true
			return
		}
	}
	requestPath := r.URL.Path

	//find a matching Route
	for _, route := range p.routers {

		//check if Route pattern matches url
		if !route.regex.MatchString(requestPath) {
			continue
		}

		//get submatches (params)
		matches := route.regex.FindStringSubmatch(requestPath)

		//double check that the Route matches the URL pattern.
		if len(matches[0]) != len(requestPath) {
			continue
		}

		params := make(map[string]string)
		if len(route.params) > 0 {
			//add url parameters to the query param map
			values := r.URL.Query()
			for i, match := range matches[1:] {
				values.Add(route.params[i], match)
				params[route.params[i]] = match
			}

			//reassemble query params and add to RawQuery
			r.URL.RawQuery = url.Values(values).Encode() + "&" + r.URL.RawQuery
			//r.URL.RawQuery = url.Values(values).Encode()
		}
		//Invoke the request handler
		vc := reflect.New(route.controllerType)
		init := vc.MethodByName("Init")
		in := make([]reflect.Value, 2)
		ct := &Context{ResponseWriter: w, Request: r, Params: params}
		in[0] = reflect.ValueOf(ct)
		in[1] = reflect.ValueOf(route.controllerType.Name())
		init.Call(in)
		in = make([]reflect.Value, 0)
		method := vc.MethodByName("Prepare")
		method.Call(in)
		if r.Method == "GET" {
			method = vc.MethodByName("Get")
			method.Call(in)
		} else if r.Method == "POST" {
			method = vc.MethodByName("Post")
			method.Call(in)
		} else if r.Method == "HEAD" {
			method = vc.MethodByName("Head")
			method.Call(in)
		} else if r.Method == "DELETE" {
			method = vc.MethodByName("Delete")
			method.Call(in)
		} else if r.Method == "PUT" {
			method = vc.MethodByName("Put")
			method.Call(in)
		} else if r.Method == "PATCH" {
			method = vc.MethodByName("Patch")
			method.Call(in)
		} else if r.Method == "OPTIONS" {
			method = vc.MethodByName("Options")
			method.Call(in)
		}
		if AutoRender {
			method = vc.MethodByName("Render")
			method.Call(in)
		}
		method = vc.MethodByName("Finish")
		method.Call(in)
		started = true
		break
	}

	//if no matches to url, throw a not found exception
	if started == false {
		http.NotFound(w, r)
	}
}
```

### 使用
```
beego.BeeApp.RegisterController("/", &controllers.MainController{})
beego.BeeApp.RegisterController("/:param", &controllers.UserController{})
beego.BeeApp.RegisterController("/users/:uid([0-9]+)", &controllers.UserController{})
```
