### avro
一种可以存储对象的工具、格式

user.avsc //格式文件
```
{"namespace": "example.avro",
 "type": "record",
 "name": "User",
 "fields": [
     {"name": "name", "type": "string"},
     {"name": "favorite_number",  "type": ["int", "null"]},
     {"name": "favorite_color", "type": ["string", "null"]}
 ]
}
```

code.py
```
import avro.schema
from avro.datafile import DataFileReader, DataFileWriter
from avro.io import DatumReader, DatumWriter

//从文件读取模式
schema = avro.schema.parse(open("user.avsc").read())
//打开存储
writer = DataFileWriter(open("users.avro", "w"), DatumWriter(), schema)
//追加一条记录
writer.append({"name": "Alyssa", "favorite_number": 256})
writer.append({"name": "Ben", "favorite_number": 7, "favorite_color": "red"})
writer.close()
//读取
reader = DataFileReader(open("users.avro", "r"), DatumReader())
for user in reader:
    print user
reader.close()
```
