## remastersys
先安装好remastersys

```
sudo remastersys  backup|clean|dist  [cdfs|iso]  [filename.iso]
```

两种打包方式：backup和dist
backup 是对整个系统完全打包，包含个人文件
dist 方式用做发行，不包含个人文件


example 
```
sudo remastersys dist/backup cdfs // dist/backup取决你要发布什么
sudo remastersys dist/backup iso filename.iso
mv /home/remastersys/remastersys/filename.iso /root/ #  将产生的iso文件移动到安全的位置(如果不移动会被清除掉)
// 清除由 remastersys产生的临时文件
sudo remastersys clean
```

## tar
### 备份
```
cd /
sudo su
tar cvpzf backup.tgz --exclude=/proc --exclude=/lost+found --exclude=/backup.tgz --exclude=/mnt --exclude=/sys --exclude=/media /
这一步可能会提示’tar: Error exit delayed from previous errors’，忽略即可
cp  backup.tgz   /media/u盘
```

### 重装干净的系统
安装完后将，重启进入，然后将/boot/grub/grub.cfg文件与/etc/fstab文件copy出来备用


### 解压备份系统覆盖当前系统
```
cd /
sudo su
cp backup.tgz ./
在解压的时候 -C 是解压到指定目录中
tar xvpfz backup.tgz -C /
创建打包系统时排除的文件
sudo mkdir proc lost+found mnt sys media
```

### 拷贝grub.cfg文件与fstab文件
```
注意文件权限
cp grub.cfg /boot/grub/
cp fstab /etc/
```
