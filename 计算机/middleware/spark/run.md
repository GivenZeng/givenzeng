document:
- https://spark.apache.org/docs/latest/quick-start.html
- build cluster: https://www.cnblogs.com/ivictor/p/5135792.html
- 单机集群：https://www.cnblogs.com/ivictor/p/5135792.html

- example: https://github.com/GivenZeng/java/spark_quick

## submit
```sh
mvn package

./bin/spark-submit \
  --class <main-class> \
  --master <master-url> \
  --deploy-mode <deploy-mode> \
  --supervise \
  --conf <key>=<value> \
  ... # other options
  <application-jar> \
  [application-arguments]
```
- class：程序入口
- master：集群url
- deploy-mode：是否将driver部署到worker或者部署在外部client，可选值：cluster、client
- supervise：用于dirver自动重启，仅当deploy-mod=cluster可用
- conf：spark配置，key=value的形式，如："--conf k1=v1 --conf=k2=v2"
- application-jar: 需要执行的jar文件，可以通过“mvn package”得到，如target/xxx.jar
- executor-memory：占用内存值，如“20G”
- total-executor-cores：可用核数，如：100
- num-executors：executor数量50
- application-arguments：运行jar文件所需的命令行参数

# 运行模式/TODO
- local
- standalone
- spark on yarn
  - client
  - cluster