
# 配置文件
```sbt
// 定义一个依赖：groupID % artifactID % revision
val derby = "org.apache.derby" % "derby" % "10.4.1.3"

lazy val commonSettings = Seq(
  organization := "com.example",
  version := "0.1.0",
  scalaVersion := "2.11.4"
)

lazy val root = (project in file(".")).
  settings(commonSettings: _*).
  settings(
    // 项目名
    name := "hello",
    // 把依赖加到项目依赖列表中，provided表示不打入最终的jar包
    // 等价于libraryDependencies += "org.apache.derby" % "derby" % "10.4.1.3"
    // libraryDependencies+="org.apache.spark"%%"spark-core"%"2.2.0"%"provided"
    libraryDependencies += derby
    // 一次添加多个依赖
//     libraryDependencies ++= Seq(
//         groupID % artifactID % revision,
//         groupID % otherID % otherRevision
//     )
  )
```

如果你用是 groupID %% artifactID % revision 而不是 groupID % artifactID % revision（区别在于 groupID 后面是 %%），sbt 会在 工件名称中加上项目的 Scala 版本号。 这只是一种快捷方法。你可以这样写不用 %%：
```sbt
libraryDependencies += "org.scala-tools" % "scala-stm_2.11.1" % "0.3"
// 假设这个构建的 scalaVersion 是 2.11.1，下面这种方式是等效的
libraryDependencies += "org.scala-tools" %% "scala-stm" % "0.3"
```

不是所有的依赖包都放在同一台服务器上，sbt 默认使用标准的 Maven2 仓库。如果你的依赖不在默认的仓库中，你需要添加 resolver 来帮助 Ivy 找到它。
```sbt
// name at localtion，name是可以随意写的，主要给开发者阅读，不影响实际功能
resolvers += "Sonatype OSS Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"
// 将本地maven仓库添加到依赖搜索路径
// 等价于：resolvers += "Local Maven Repository" at "file://"+Path.userHome.absolutePath+"/.m2/repository"
resolvers += Resolver.mavenLocal
```

# command
- 运行：sbt run
- 编译：sbt compile
- 打包：sbt package，打出的包将位于target/scala-xxx下
- 其他：sbt clean/test

# 打包
sbt package不会将如下打包：
（1）项目的依赖包，即在 build.sbt 中定义的那些依赖包。
（2）用来在分布式环境中执行时所需要的 Scala 的 Jar 包
所以sbt package比较适合做spark练习，不适用于大型开发。举个例子：当你仅依赖spark库时，只使用sbt package就可以，因为在spark master和worker上面都有；但是如果依赖mysql的jdbc这些第三方库, 只使用sbt的 package 命令打包，是不会把这些第三方库打包进去的。这样在spark上面运行就会报错

可以使用assembly插件

# 项目间依赖
```
projectroot
    |_util
        |_build.sbt
        |_util.scala
    |_project_a
        |_main.scala
        |_build.sbt
```
假如你的项目间有依赖，比如project_a依赖util，那么你可以在project_a的sbt配置文件加上：
```sbt
// 定义一个依赖：groupID % artifactID % revision

lazy val commonSettings = Seq(
  organization := "com.example",
  version := "0.1.0",
  scalaVersion := "2.11.4"
)
lazy val util = project.in(file("util"))
lazy val root = (project in file(".")).
  aggregate(util).
  settings(
    // 项目名
    name := "hello",
  )
```



# refer
[sbt 入门](https://www.cnblogs.com/cbscan/articles/4194231.html)