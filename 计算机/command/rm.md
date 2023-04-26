rm 到垃圾桶
```
$ git clone https://github.com/lagerspetz/linux-stuff
$ sudo mv linux-stuff/scripts/saferm.sh /bin
$ rm -Rf linux-stuff
```

.bashrc添加
```
alias rm=saferm.sh
```
