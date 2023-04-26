格式：
- HEALTHCHECK [选项] CMD <命令> ：设置检查容器健康状况的命令
- HEALTHCHECK NONE ：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令


HEALTHCHECK 支持下列选项：
* --interval=<间隔> ：两次健康检查的间隔，默认为 30 秒；
* --timeout=<时长> ：健康检查命令运行超时时间，如果超过这个时间，本次健康检查就被视为失败，默认 30 秒；
* --retries=<次数> ：当连续失败指定次数后，则将容器状态视为 unhealthy ，默认 3
次。

和 CMD , ENTRYPOINT 一样， HEALTHCHECK 只可以出现一次，如果写了多个，只有最后一个生
效。

```
FROM nginx
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -fs http://localhost/ || exit 1
```


这里我们设置了每 5 秒检查一次（ 这里为了试验所以间隔非常短，实际应该相对较长） ，如果健康检查命令超过 3 秒没响应就视为失败，并且使用 curl -fs http://localhost/ || exit1 作为健康检查命令。
