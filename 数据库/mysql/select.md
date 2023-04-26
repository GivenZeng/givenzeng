* SELECT * FROM t1 WHERE ROW(1,2) = (SELECT column1, column2 FROM t2);
这个查询是返回column1等于column2的结果行。Row函数中的1和2相当于构造参数。想必Blogjava上的同志对这些应该比较清楚，也不去详细介绍了。
