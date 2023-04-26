```
aws s3 cp /tmp/foo/ s3://bucket/ --recursive --exclude "*" --include "*.jpg"
aws s3 mv s3://mybucket/ s3://mybucket2/ --recursive --exclude "mybucket/another/*"
aws s3 mv s3://mybucket/test.txt s3://mybucket/test2.txt --acl public-read-write
```

### CLI设置
https://docs.aws.amazon.com/zh_cn/AmazonS3/latest/dev/setup-aws-cli.html

### 使用CLI运行命令
```
aws s3 ls --profile adminuser
=======
## s3uri
s3://mybucket/myprefix/myobject
```
## 文件命令
作用于文件，除非添加 --recursive参数
```
//cp
aws s3 cp test.txt s3://mybucket/test2.txt
aws s3 cp s3://mybucket/logs/ s3://mybucket2/logs/ --recursive --exclude "*" --include "*.log"
//mv
aws s3 mv test.txt s3://mybucket/test2.txt
aws s3 mv s3://mybucket/test.txt test2.txt
aws s3 mv s3://mybucket/ s3://mybucket2/ --recursive --exclude "mybucket/another/*"
aws s3 mv s3://mybucket/test.txt s3://mybucket/test2.txt --acl public-read-write
aws s3 mv file.txt s3://mybucket/ --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=emailaddress=user@example.com
//rm
```
## 目录命令
```
//sync
//mb:创建一个新bucket
aws s3 mb s3://mybucket
aws s3 mb s3://mybucket --region us-west-1
//rb
aws s3 rb s3://mybucket
//ls
aws s3 ls s3://mybucket --recursive --human-readable --summarize
```

## 过滤器
exlude include 可以出现多次；后面出现的先执行
```
//包含*.txt
--exclude "*" --include "*.txt"
//排除所有文件
--include "*.txt" --exclude "*"
```
