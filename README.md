# KVOPackage
KVO的封装

首先思考：为什么我们要封装KVO呢？直接使用不行吗？
在我们项目中KVO用的多，使用时有3个步骤：
1.addObserver
2.observerForKeypath
3.removeObserver
这3个步骤很分散，项目很大时遇到问题时不好排查
所以：把KVO使用封装起来方便使用。
希望达到的效果：调用一句话即可实现，如：
nnObserver: keypath: block
希望在所有地方可以使用
1.NSObject分类实现




