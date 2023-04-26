## py.test

## pyenv pyenv-virtualenv
安装
pip install virtualenv
sudo apt-get install libpq-dev
sudo apt-get install libmysqlclient-dev

使用
cd project_path
vitrualenv env_name


## yapf
format your python code
```
 yapf -ir *
```

## black
需要在python3.6以上
```
black -l 120 dir_or_file
```

## isort
对import的packag进行排序
```
isort -w 120 -fss -sl file
```
