### set
* set 是一种新的字段类型，可选的值用逗号分隔
* 插入的值必须是set的子集
* 查询可以使用like+通配符、find_in_set
```
create table test (name varchar(255), city set('guangzhou','hangzhou'));

insert into test value('given','beijing')  //错误，因为beijign不在集合中

//插入第一条记录
insert into test value('given','guangzhou'); //正确

//第二条记录
insert into test value('given','guangzhou,hangzhou'); //正确

//返回第一条记录
select * from test where city='guangzhou'   

//返回第二条记录
select * from test where city='guangzhou,hangzhou';

//返回两条记录
select * from test where city like '%zhou';

//返回两条记录
//find_in_set(v , set ) 返回v在set中出现的次数。 SELECT FIND_IN_SET('b','a,b,c,d') 返回2
select * from test where find_in_set('guangzhou',city)>0;
```


https://dev.mysql.com/doc/refman/5.7/en/set.html
