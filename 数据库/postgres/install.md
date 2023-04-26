### 安装和启动
* install
	```
	docker pull postgres
	```
* run 
	```
	docker run --name mypostgres -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
	```
	使用docker后台容器形式运行一个postgres，将本机532端口映射到容器5432端口，容器命名为mypostgres，密码为mysecretpassword。postgres默认的用户名为postgres

* install client
	```
	sudo apt-get install postgres-client
	```

### 连接
	```
	psql -U postgres -h 127.0.0.1 -p 5432
	```
