https://www.jianshu.com/p/08c657bd34f1

### virtualenv

虚拟环境是在Python解释器上的一个私有复制，你可以在一个隔绝的环境下安装packages，不会影响到你系统中全局的Python解释器。

虚拟环境非常有用，因为它可以防止系统出现包管理混乱和版本冲突的问题。为每个应用程序创建一个虚拟环境可以确保应用程序只能访问它们自己使用的包，从而全局解释器只作为一个源且依然整洁干净去更多的虚拟环境。另一个好处是，虚拟环境不需要管理员权限。

#### 安装
```
pip install virtualenv
```

#### 创建虚拟环境
```
// 到某目录下创建虚拟环境
cd dir
// 创建一个名为myvenv的虚拟环境
// no-site-packages  表示不使用系统环境包
virtualenv --no-site-packages myvenv
等价于
virtualenv myvenv （目前新版默认不使用系统环境包）

// 指定虚拟环境的python版本，环境命名为ENV2.7
virtualenv -p /usr/bin/python2.7 ENV2.7  // 指定虚拟环境的python版本

// python3自带venv，不用安装virtualenv也能运行如下命令
// 创建一个名字为myvenv的虚拟环境
python -m venv myvenv
python -m venv --system-site-packages myvenv
也是默认全新干净的环境，相反可选的参数
使虚拟环境指向系统环境包目录（非复制），在系统环境pip新安装包，在虚拟环境就可以使用。
```

#### 激活虚拟环境
不同平台的激活命令不一样
```
Platform     Shell        Command to activate virtual environment

Posix        bash/zsh    $ source dir/bin/activate
             fish        $ . dir/bin/activate.fish
             csh/tcsh    $ source dir/bin/activate.csh


Windows      cmd.exe        C:> dir\Scripts\activate.bat
             PowerShell     C:> dir\Scripts\Activate.ps1
```

#### 关闭虚拟环境
```
deactivate
```

#### 删除虚拟环境
```
删除目录即可
rm dir_name
```

virtualenv 能够改变当前的python环境，但是还是无法针对特定的项目运行不同的python版本:
```
cd project1
python main.py    // 我想用python2 运行project1
cd ../project2
python main.py    // 用python3 运行project2
```
如何只使用上面的四条命令就让project1和project2运行在不同的python环境中呢？答案是pyenv

### pyenv
* https://www.jianshu.com/p/a349a17d4596
* https://github.com/pyenv/pyenv

初识pyenv：一个简单的Python版本管理工具。以前叫做Pythonbrew，Pyenv让你能够方便地切换全局Python版本，安装多个不同的Python版本，设置独立的某个文件夹或者工程目录特异的Python版本，同时创建Python虚拟环境（”virualenv's“）。所有这些操作均可以在类UNIX系统的机器上（Linux和OS X）不需要依赖Python本身执行，而且它工作在用户层，不需要任何sudo操作。那么我们开始吧！

安装
```
// 依赖安装
sudo apt-get install libbz2-dev
sudo apt-get install libssl-dev
sudo apt-get install libreadline6 libreadline6-dev
sudo apt-get install libsqlite3-dev

// pyenv安装
见https://github.com/pyenv/pyenv-installer
```


```
pyenv install -list // 显示所有能够安装的python版本
pyenv versions    // 显示本机器中pyenv已经安装的python版本，默认有system版本
pyenv install 3.4.0   // 安装某版本的python
pyenv global 3.4.0   // 使某版本成为全局python环境版本
pyenv global system  // 恢复至以前的版本

cd project1
pyenv local 3.4.0 //设置当前目录的python版本
python -V //显示3.4

cd ../project2
pyenv local system // project2 为系统版本

```
