## 参考文档

- https://www.jianshu.com/p/3d96dbf3f764
- https://www.cnblogs.com/Finley/p/5946000.html
- http://www.ruanyifeng.com/blog/2017/07/neural-network.html

## BP神经网络

### 基本原理
利用输出后的误差来估计输出层的直接前导层的误差，再用这个误差估计更前一层的误差，如此一层一层的反传下去，就获得了所有其他各层的误差估计。


如果对每一层的调整都从输出层进行反向推导，那么工作量、计算量会十分大，难以推广到深层神经网络；而且误差可能再最后数层即被抵消，无法传递导之前的神经层。

