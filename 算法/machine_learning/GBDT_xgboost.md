https://plushunter.github.io/2017/01/22/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E7%AE%97%E6%B3%95%E7%B3%BB%E5%88%97%EF%BC%887%EF%BC%89%EF%BC%9AGBDT/

分类样本T：
- 输入: xi=[v1,v2,...,vk], 每个样本为长度为k的向量
- 输出：yi, 为xi对应的类别
设样本数为n

第c颗树的训练数据为T0c
```
x1, y1 = y1==c?1:0
x2, y2 = y2==c?1:0
...
xn, yn = yn==c?1:0
```

```
for m range M: // M为训练轮数
	for c range C.length: //C为类别集合，该次循环训练处C颗树
		1. 对于Tmc寻找一颗决策树Jmc，已某个维度的某个值为划分阈值
		   使得该树对于Tmc集合的误差最小，一般使用方差
		2. 将Tc使用该树划分为两类（因为y只能是0或者1），Tmc因此被划分为两个集合C1=[{x,y}|y=1]，C2
		3. avg_mc=sum(yi|xi belong to C1)/C1.length
	for xi,yi in T:
	for c range C.length:
		pc = Jmc对xi的
	4. Tm+1c = [{xi, yi-ri}|xi belonged to Ci]

```

xgboost
- https://plushunter.github.io/2017/01/26/%E6%9C%BA%E5%99%A8%E5%AD%A6%E4%B9%A0%E7%AE%97%E6%B3%95%E7%B3%BB%E5%88%97%EF%BC%888%EF%BC%89%EF%BC%9AXgBoost/
- https://www.jianshu.com/p/5418125caf80
- https://zhuanlan.zhihu.com/p/38297689




基尼指数，如果样本集合D含有K个类别，Ck为D中第k类的数量，则D的基尼指数为：
Gini(D)=1-sum(Ck/D)

如果样本集合D根据特征A是否大于某一划分值a被划分为D1，D2，集合D划分后的基尼指数为：
Gini(D,A)=(D1/D)Gini(D1) + (D2/D)Gini(D2)，可以理解为D1和D2的不确定程度的加权和。
