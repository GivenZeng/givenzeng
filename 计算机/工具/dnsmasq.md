可参考https://www.cnblogs.com/demonxian3/p/7472300.html


- install
	sudo apt-get install dnsmasq

- vim /etc/dnsmasq.conf
```
resolv-file=/etc/resolv.conf

strict-order // 表示严格按照resolv-file文件中的顺序从上到下进行DNS解析，直到第一个解析成功为止。

listen-address=192.168.153.128 // 定义dnsmasq监听的地址，默认是监控本机的所有网卡上。局域网内主机若要使用dnsmasq服务时，指定本机的IP地址。 一般设置为127.0.0.1即可

address=/demon.com/192.168.153.128 // 将demon.com解析为192.168.153.128

server=114.114.114.114 //dns服务器，可以用于解析未知的域名 114.114.114.114是国内运营商通用的dns服务器

bogus-nxdomain=114.114.114.114 //为防止DNS污染，使用参数定义的DNS解析的服务器。注意：如果是阿里云服务器上配置dnsmasq要启用此项。
```
可在该文件配置多个address解析

- vim reslov.conf
```
nameserver      //定义DNS服务器的IP地址,同dnsmasq的listen-address即可
domain          //定义本地域名，可省略（会将该domain解析为本机器）
search          //定义域名的搜索列表
sortlist        //对返回的域名进行排序
```
domain和search不能共存；如果同时存在，后面出现的将会被使用。当程序寻找不到主机域名时，会对 search 后面的参数一一查找主机域名
