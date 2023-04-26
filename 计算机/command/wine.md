### 安装wine
```
// 先移除旧版的wine
sudo apt-get remove wine wine-mono wine-gecko winetricks
sudo apt-get autoremove
sudo apt-get update
sudo apt-get upgrade

// 安装wine
sudo dpkg --add-architecture i386
wget -nc https://dl.winehq.org/wine-builds/Release.key
sudo apt-key add Release.key
sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
sudo apt-get update

```

### 安装qq
```
// 下载wineQQ
百度云链接: https://pan.baidu.com/s/1i4XwtgD 密码: e8k8


tar xvf wineQQ8.9_19990.tar.xz -C ~/

// 解压好之后在applications里面就会有qq的图标,点击启动后可能要等一阵子才有反映，并且wine可能要你安装一些工具、插件，点击对话框的install按钮就好
```
也可以参考https://github.com/askme765cs/Wine-QQ-TIM/tree/master/Wine-QQ8.9.2
