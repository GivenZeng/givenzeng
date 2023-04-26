```
create procedure myproc()
begin
    declare num int;
    set num=1;
    while num <= 10000000 do
        insert into test_user(username,email,password) values(CONCAT('username_',num), CONCAT(num ,'@qq.com'), MD5(num));
        set num=num+1;
    end while;
end

```
