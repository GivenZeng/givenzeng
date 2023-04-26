### 简介
Amazon Redshift 是一种快速且完全托管的数据仓库，让您可以使用标准 SQL 和现有的商业智能 (BI) 工具经济高效地轻松分析您的所有数据。利用 Amazon Redshift，您可以使用高性能本地磁盘上的列式存储通过复杂的查询优化对 PB 级结构化数据运行复杂的分析查询，并能大规模执行并行查询。大多数结果在几秒内返回。使用 Amazon Redshift 时，您可以从小规模开始，费用只有每小时 0.25 USD，并且无需承诺；然后将数据量扩展到 PB 级，费用为每年每 TB 1000 USD，不到传统解决方案的十分之一。

Amazon Redshift 还包含 Redshift Spectrum，让您可以对 Amazon S3 中的 EB 级非结构化数据直接运行 SQL 查询。不需要加载或转换，并且您可以使用 Avro、CSV、Grok、ORC、Parquet、RCFile、RegexSerDe、SequenceFile、TextFile 和 TSV 等开源数据格式。Redshift Spectrum 可以根据检索的数据自动扩展查询计算容量，因此对 Amazon S3 的查询速度非常快，不受数据集大小的影响。


### 查看磁盘使用量
```
select
  sum(capacity)/1024 as capacity_gbytes, 
  sum(used)/1024 as used_gbytes, 
  (sum(capacity) - sum(used))/1024 as free_gbytes 
from 
  stv_partitions where part_begin=0;
```


or
```
select
    trim(pgdb.datname) as Database,
    trim(pgn.nspname) as Schema,
    trim(a.name) as Table,
    b.mbytes,
    a.rows
from (
    select db_id, id, name, sum(rows) as rows
    from stv_tbl_perm a
    group by db_id, id, name
) as a
join pg_class as pgc on pgc.oid = a.id
join pg_namespace as pgn on pgn.oid = pgc.relnamespace
join pg_database as pgdb on pgdb.oid = a.db_id
join (
    select tbl, count(*) as mbytes
    from stv_blocklist
    group by tbl
) b on a.id = b.tbl
order by mbytes desc, a.db_id, a.name; 
```
