---
title: 'The Boost C++ Libraries: I.1 智能指针'
date: 2019-08-19 11:26:50
tags:
- boost
- C++
categories:
- boost
---
### 1. 独占所有权

#### scoped_ptr
- 初始化：`boost::scoped_ptr<int> p{new int{1}}`
- 不能转移对象所有权，一旦用一个地址来初始化，这个动态分配的对象将在析构阶段或调用 reset() 时释放。
- 重载操作符：* -> bool,是否指向内容为空。
- scoped_ptr析构时使用delete释放对象，因此不能用动态分配数组来初始化，数组需要delete[]释放。

#### scoped_array
- 初始化：`boost::scoped_array<int> p{new int[2]}`
- 重载操作符：[] bool
- 析构时使用 delete[]。

#### get()
返回地址

#### reset()
重置

### 2. 共享所有权

#### shared_ptr
- 初始化：`boost::shared_ptr<int> p1{new int{1}}`
- 多个shared_ptr可以共享对象，销毁shared_ptr时，如果还有其他指针指向对象，对象不释放。
- 重载操作符：* -> bool \[](1.53之后)
- 1.53之后的版本支持用数组对象初始化，析构时根据判断使用delete或delete[]。

#### shared_array
- 初始化：`boost::shared_array<int> p1{new int[1]}`
- 重载操作符：[] bool

#### make_shared
- 初始化：`auto p1 = boost::make_shared<int>(1)`
- 好处：不用调用两次new，效率更高。
- 也可用于数组。

#### BOOST_SP_USE_QUICK_ALLOCATOR
- 使用：`#define BOOST_SP_USE_QUICK_ALLOCATOR`
- 激活此分配器来管理内存块，以减少对引用计数器的new和delete的调用。

#### get()
返回地址

#### reset()
重置

### 3. 其他智能指针

#### weak_ptr
- 必须配合shared_ptr使用
- 初始化：
`boost::shared_ptr<int> sh{new int{99}};`
`boost::weak_ptr<int> w{sh};`
不会造成引用计数的增加
- 对象的生命周期取决于绑定的共享指针

#### lock()
返回一个指向共享对象的shared_ptr，会递增引用计数，延长对象的生命周期。

#### intrusive_ptr
- [boost::intrusive_ptr用法](https://blog.csdn.net/harbinzju/article/details/6754646)
- [intrusive_ptr源码分析](https://blog.csdn.net/FreeeLinux/article/details/54670196)

在以下情况时使用 intrusive_ptr ：
- 你需要把 this 当作智能指针来使用。
- 已有代码使用或提供了插入式的引用计数。
- 智能指针的大小必须与裸指针的大小相等。