### 介绍
- mysql Query Cache 默认为打开。从某种程度可以提高查询的效果，但是未必是最优的解决方案，如果有的大量的修改和查询时，由于修改造的cache失效，会给服务器造成很大的开销，可以通过query_cache_type【0(OFF)1(ON)2(DEMAND)】来控制缓存的开关.

- 需要注意的是mysql query cache 是对大小写敏感的，因为Query Cache 在内存中是以 HASH 结构来进行映射，HASH 算法基础就是组成 SQL 语句的字符，所以 任何sql语句的改变重新cache,这也是项目开发中要建立sql语句书写规范的原因吧


### 何时cache
  * mysql query cache内容为 select 的结果集, cache 使用完整的 sql 字符串做 key, 并区分大小写，空格等。即两个sql必须完全一致才会导致cache命中。
  * prepared statement永远不会cache到结果，即使参数完全一样。在 5.1 之后会得到改善。
  * where条件中如包含了某些函数永远不会被cache, 比如current_date, now等。
  * date 之类的函数如果返回是以小时或天级别的，最好先算出来再传进去。
  ```
  select * from foo where date1=current_date -- 不会被 cache
  select * from foo where date1='2008-12-30' -- 被cache, 正确的做法
  ```
  * 太大的result set不会被cache (< query_cache_limit)

### 何时更新
  * 一旦表数据进行任何一行的修改，基于该表相关cache立即全部失效。
  * 为什么不做聪明一点判断修改的是否cache的内容？因为分析cache内容太复杂，服务器需要追求最大的性能。

### 性能
  * ache 未必所有场合总是会改善性能
    * 当有大量的查询和大量的修改时，cache机制可能会造成性能下降。因为每次修改会导致系统去做cache失效操作，造成不小开销。
    * 另外系统cache的访问由一个单一的全局锁来控制，这时候大量>的查询将被阻塞，直至锁释放。所以不要简单认为设置cache必定会带来性能提升。
  * 大result set不会被cache的开销
     * 太大的result set不会被cache, 但mysql预先不知道result set的长度，所以只能等到reset set在cache添加到临界值 query_cache_limit 之后才会简单的把这个cache 丢弃。这并不是一个高效的操作。如果mysql status中Qcache_not_cached太大的话, 则可对潜在的大结果集的sql显式添加 SQL_NO_CACHE 的控制。
     * query_cache_min_res_unit = (query_cache_size – Qcache_free_memory) / Qcache_queries_in_cache

### 缓存机制的内存使用
  * mysql query cache 使用内存池技术，自己管理内存释放和分配，而不是通过操作系统。内存池使用的基本单位是变长的block, 一个result set的cache通过链表把这些block串起来。因为存放result set的时候并不知道这个resultset最终有多大。block最短长度为query_cache_min_res_unit, resultset 的最后一个block会执行trim操作。

### 使用步骤
1. 修改配置文件，设置query_cache_type和query_cache \_size，以及query_cache_min_res_unit（可以采用默认值）
  ```
  query_cache_type 0 代表不使用缓冲， 1 代表使用缓冲，2 代表根据需要使用。
  ```
2. 如果query_cache_type=1，如果不需要缓冲，则query如下
  ```
  SELECT SQL_NO_CACHE * FROM my_table WHERE ...
  ```
3.  如果query_cache_type=2，如果需要缓冲，则query如下
  ```
  SELECT SQL_CACHE * FROM my_table WHERE ...
  ```

### 总结
* Query Cache 在提高数据库性能方面具有非常重要的作用。
* 其设定也非常简单，仅需要在配置文件写入两行： query_cache_type 和 query_cache \_size，而且 MySQL 的 query cache 非常快！而且一旦命中，就直接发送给客户端，节约大量的 CPU 时间。
* 当然，非 SELECT 语句对缓冲是有影响的，它们可能使缓冲中的数据过期。一个 UPDATE 语句引起的部分表修改，将导致对该表所有的缓冲数据失效，这是 MySQL 为了平衡性能而没有采取的措施。因为，如果每次 UPDATE 需要检查修改的数据，然后撤出部分缓冲将导致代码的复杂度增加。
* 使用场景
  * 写操作少于读操作；数据实时性要求较强（即不允许缓存中存在过期数据）
  * 如果允许缓存中存在过期数据，可以自己使用Redis等工具进行缓存

原文：https://www.cnblogs.com/lpfuture/p/5751853.html
