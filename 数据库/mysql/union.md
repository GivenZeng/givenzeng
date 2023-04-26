https://www.cnblogs.com/yinzhenzhixin/archive/2009/01/07/1371064.html

UNION、order联合使用

### union
```
SELECT [Id],[Name],[Comment] FROM [Product1]
UNION
SELECT [Id],[Name],[Comment] FROM [Product2]
```

合并前n条
```
SELECT TOP N [Id],[Name],[Comment] FROM [Product1]
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product2]

或

SELECT [Id],[Name],[Comment] FROM [Product1] WHERE LEN([Name]) > 5
UNION
SELECT [Id],[Name],[Comment] FROM [Product2] WHERE [Id] IN (11,20) AND [Comment] IS NOT NULL
```


### union and order by
```
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE1' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE2' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE3' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE4' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE5' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE6' ORDER BY NEWID()
UNION
SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE7' ORDER BY NEWID()
```
在查询分析器中执行如上语句会报错,这个问题起初会令您觉得UNION在这方面似乎有点软弱，难道UNION和ORDER BY就不能共存吗？当然可以，下面的代码或许能实现与上面代码希望实现的相同功能

```
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE1' ORDER BY NEWID()) AS [Product1]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE2' ORDER BY NEWID()) AS [Product2]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE3' ORDER BY NEWID()) AS [Product3]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE4' ORDER BY NEWID()) AS [Product4]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE5' ORDER BY NEWID()) AS [Product5]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE6' ORDER BY NEWID()) AS [Product6]
UNION
SELECT * FROM
(SELECT TOP N [Id],[Name],[Comment] FROM [Product] WHERE [Type]='TYPE7' ORDER BY NEWID()) AS [Product7]
```

