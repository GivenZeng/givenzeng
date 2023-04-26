查询某个字符串前后的n个字符

cat content.txt | grep -o -P '.{0,100}target_str.{0,5000}'|less
