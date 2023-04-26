### introduce
* PostgreSQL提供了几种索引类型：B-tree，Hash，GiST，SP-GiST，GIN和BRIN。每个索引类型使用不同的算法，适合不同种类的查询。默认情况下，CREATE INDEX命令创建B-tree索引，这符合最常见的情况。
* B-tree可以处理对可以排序成某些顺序的数据的等式和范围查询。特别地，当索引列参与使用以下运算符之一的比较时， PostgreSQL查询计划器将考虑使用B-tree索引：
  ```
  <
  <=
  =
  >=
  >
  BETWEEN和IN
  IS NULL或IS NOT NULL
  模糊匹配: bar%
  ```
* 在大型表上创建索引可能需要很长时间。默认情况下，PostgreSQL允许读表（SELECT语句）与索引创建并行发生，但写入（INSERT，UPDATE，DELETE）将被阻止，直到索引生成完成。在生产环境中，这通常是不能接受的。可以设置允许写入与索引创建并行发生，但有几个需要注意的注意事项 - 有关更多信息

* 创建
  ```
  create index index_name on t_name(column_name);
  create index index_name on t_name using hash(column_name); //哈希索引
  create index index_name on t_name (column1_name,column2_name); //联合索引
  create unique index index_name on t_name(column_name);
  ```

* 表达式上的索引
  ```
  create index index_name on t_name(lower(column_name));
  ```
  利于与以下相似的查询、更新、删除
  ```
  select * from t_name where lower(column_name)='lower_value';
  ```
  又如
  ```
  create index index_name on people((first_name||' '||last_name));
  select * from people where (first_name||' '||last_name) = 'john smith';
  ```
  CREATE INDEX命令的语法通常需要在索引表达式周围写圆括号，如第二个示例所示。 当表达式只是一个函数调用时，可以省略括号，如第一个示例所示。

* 部分索引
    可以只对表中的部分行进行索引。
    ```
    create index index_name on t_name(column1_name) where column2 >10000;
    ```
使用部分索引的一个主要原因是避免索引常见值。 由于搜索公共值（一个占所有表行的百分之几）的查询将不会使用索引，所以根本没有必要在索引中保留这些行。 这减少了索引的大小，这将加快使用索引的查询。 它也将加快许多表更新操作，因为索引在所有情况下都不需要更新。
