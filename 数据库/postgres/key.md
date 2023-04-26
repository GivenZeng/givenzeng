### 主键的创建
* 在设置列的时候指定
```
create table t_name(
  id integer primary key,
  ....
  )
```

* 以约束条件的形式创建
```
create table t_name(
  id integer,
  ...
  constraint my_key primary key(id)
  )
```

### 自增的主键
```
create table t_name(
  id serial primary key,
  ....
  )

create table t_name(
  id serial,
  ...
  constraint my_key primary key(id)
  )

create table t_name(
  id integer primary key,
  ...
  constraint my_key primary key(id)
  )  
```
* postgresql序列号（SERIAL）类型包括smallserial（smallint,short）,serial(int)和bigserial(bigint,long long int)，不管是smallserial,serial还是bigserial，其范围都是(1,9223372036854775807)，但是序列号类型其实不是真正的类型，当声明一个字段为序列号类型时其实是创建了一个序列，INSERT时如果没有给该字段赋值会默认获取对应序列的下一个值。
* 很明显从上面可以看出，方法一和方法二只是写法不同，实质上主键都通过使用 serial 类型来实现的，使用serial类型，PG会自动创建一个序列给主键用，当插入表数据时如果不指定ID，则ID会默认使用序列的NEXT值。    
* 方法三是先创建一张表，再创建一个序列，然后将表主键ID的默认值设置成这个序列的NEXT值。这种写法似乎更符合人们的思维习惯，也便于管理，如果系统遇到sequence 性能问题时，便于调整 sequence 属性；
* 三个表表结构一模一样， 三种方法如果要寻找差别，可能仅有以下一点，当 drop 表时，方法一和方法二会自动地将序列也 drop 掉, 而方法三不会。

### serial
可见 https://www.cnblogs.com/alianbog/p/5654604.html
* 创建语法
  ```
  CREATE [ TEMPORARY | TEMP ] SEQUENCE [ IF NOT EXISTS ] name [ INCREMENT [ BY ] increment ]
      [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
      [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
      [ OWNED BY { table_name.column_name | NONE } ]
  ```

* 解析
  ```
  其实和上面使用\d一个序列时对应的，

  INCREMENT BY ： 每次序列增加（或减少）的步长

  MINVALUE ： 序列最小值，NO MINVALUE表示没有最小值

  MAXVALUE ： 序列最大值，NO MAXVALUE表示没有最大值

  START WITH ：以什么序列值开始

  CYCLE ： 序列是否循环使用

  OWNED BY ： 可以直接指定一个表的字段，也可以不指定。
  ```

* 例子
  ```
  create sequence sql_tbl_serial2_a increment by 1 minvalue 1 no maxvalue start with 1;
  ```
* 使用
  ```
  create table tbl_serial2(a int not null default nextval('sql_tbl_serial2_a'),b varchar(2));
  ```
