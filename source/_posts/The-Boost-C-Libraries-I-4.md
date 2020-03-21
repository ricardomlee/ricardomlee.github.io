---
title: 'The Boost C++ Libraries: I.4 Boost.Pool'
date: 2019-08-27 11:07:33
tags:
- boost
- C++
categories:
- boost
---

Boost.Pool包含一系列用来加速内存管理的类。
使用new等方式申请内存后，外部来看内存被分配给程序，但是在程序内部，内存违背使用时就会交由Boost.Pool管理。
Boost.Pool将内存分为相等大小的段，当向Boost.Pool申请请求内存时，Boost.Pool会访问下一个空闲的段并将该段分配给你。你可能不会用到该段全部字节，但该段会被标记为已使用。
这种内存分段的概念成为simple segregated storage，Boost.Pool独有。当需要频繁对许多相同大小的对象进行创建和销毁时，这种方式可以加速内存分配和释放。

### 使用 boost::simple_segregated_storage
### 使用 boost::object_pool
### boost::object_pool 改变段大小
### 使用 boost::singleton_pool
### 使用 boost::pool_allocator
### 使用 boost::fast_pool_allocator