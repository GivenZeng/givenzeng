1. 每个module都应该有__init__.py
2. 引用其他module应该将其导入到sys.path
```
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
```
