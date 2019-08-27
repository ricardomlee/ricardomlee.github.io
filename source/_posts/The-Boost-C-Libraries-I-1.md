---
title: 'The Boost C++ Libraries: I.1 智能指针'
date: 2019-08-19 11:26:50
tags:
- boost
- C++
categories:
- boost
---
## 独占所有权

### scoped_ptr
```C++
#include <boost/scoped_ptr.hpp>
#include <iostream>

int main()
{
  boost::scoped_ptr<int> p{new int{1}};
  std::cout << *p << '\n';
  p.reset(new int{2});
  std::cout << *p.get() << '\n';
  p.reset();
  std::cout << std::boolalpha << static_cast<bool>(p) << '\n';
}
```
- 初始化：`boost::scoped_ptr<int> p{new int{1}}`
- 不能转移对象所有权，一旦用一个地址来初始化，这个动态分配的对象将在析构阶段或调用 reset() 时释放。
- 重载操作符：* -> bool,是否指向内容为空。
- scoped_ptr析构时使用delete释放对象，因此不能用动态分配数组来初始化，数组需要delete[]释放。

#### get()
返回地址

#### reset()
重置

### scoped_array
```C++
#include <boost/scoped_array.hpp>

int main()
{
  boost::scoped_array<int> p{new int[2]};
  *p.get() = 1;
  p[1] = 2;
  p.reset(new int[3]);
}
```
- 初始化：`boost::scoped_array<int> p{new int[2]}`
- 重载操作符：[] bool
- 析构时使用 delete[]。

## 共享所有权

### shared_ptr
```C++
#include <boost/shared_ptr.hpp>
#include <iostream>

int main()
{
  boost::shared_ptr<int> p1{new int{1}};
  std::cout << *p1 << '\n';
  boost::shared_ptr<int> p2{p1};
  p1.reset(new int{2});
  std::cout << *p1.get() << '\n';
  p1.reset();
  std::cout << std::boolalpha << static_cast<bool>(p2) << '\n';
}
```
- 初始化：`boost::shared_ptr<int> p1{new int{1}}`
- 多个shared_ptr可以共享对象，销毁shared_ptr时，如果还有其他指针指向对象，对象不释放。
- 重载操作符：* -> bool \[](1.53之后)
- 1.53之后的版本支持用数组对象初始化，析构时根据判断使用delete或delete[]。

#### get()
返回地址

#### reset()
重置

### shared_array
```C++
#include <boost/shared_array.hpp>
#include <iostream>

int main()
{
  boost::shared_array<int> p1{new int[1]};
  {
    boost::shared_array<int> p2{p1};
    p2[0] = 1;
  }
  std::cout << p1[0] << '\n';
}
```
- 初始化：`boost::shared_array<int> p1{new int[1]}`
- 重载操作符：[] bool

### make_shared
```C++
#include <boost/make_shared.hpp>
#include <typeinfo>
#include <iostream>

int main()
{
  auto p1 = boost::make_shared<int>(1);
  std::cout << typeid(p1).name() << '\n';
  auto p2 = boost::make_shared<int[]>(10);
  std::cout << typeid(p2).name() << '\n';
}
```
- 初始化：`auto p1 = boost::make_shared<int>(1)`
- 好处：不用调用两次new，效率更高。
- 也可用于数组。

### BOOST_SP_USE_QUICK_ALLOCATOR
```C++
#define BOOST_SP_USE_QUICK_ALLOCATOR
#include <boost/shared_ptr.hpp>
#include <iostream>
#include <ctime>

int main()
{
  boost::shared_ptr<int> p;
  std::time_t then = std::time(nullptr);
  for (int i = 0; i < 1000000; ++i)
    p.reset(new int{i});
  std::time_t now = std::time(nullptr);
  std::cout << now - then << '\n';
}
```
- 使用：`#define BOOST_SP_USE_QUICK_ALLOCATOR`
- 激活此分配器来管理内存块，以减少对引用计数器的new和delete的调用。

## 其他智能指针

### weak_ptr
- 必须配合shared_ptr使用
- 初始化：
`boost::shared_ptr<int> sh{new int{99}};`
`boost::weak_ptr<int> w{sh};`
不会造成引用计数的增加
- 对象的生命周期取决于绑定的共享指针

```C++
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>
#include <thread>
#include <functional>
#include <iostream>

void reset(boost::shared_ptr<int> &sh)
{
  sh.reset();
}

void print(boost::weak_ptr<int> &w)
{
  boost::shared_ptr<int> sh = w.lock();
  if (sh)
    std::cout << *sh << '\n';
}

int main()
{
  boost::shared_ptr<int> sh{new int{99}};
  boost::weak_ptr<int> w{sh};
  std::thread t1{reset, std::ref(sh)};
  std::thread t2{print, std::ref(w)};
  t1.join();
  t2.join();
}
```

#### lock()
返回一个指向共享对象的shared_ptr，会递增引用计数，延长对象的生命周期。

### intrusive_ptr
```C++
#include <boost/intrusive_ptr.hpp>
#include <atlbase.h>
#include <iostream>

void intrusive_ptr_add_ref(IDispatch *p) { p->AddRef(); }
void intrusive_ptr_release(IDispatch *p) { p->Release(); }

void check_windows_folder()
{
  CLSID clsid;
  CLSIDFromProgID(CComBSTR{"Scripting.FileSystemObject"}, &clsid);
  void *p;
  CoCreateInstance(clsid, 0, CLSCTX_INPROC_SERVER, __uuidof(IDispatch), &p);
  boost::intrusive_ptr<IDispatch> disp{static_cast<IDispatch*>(p), false};
  CComDispatchDriver dd{disp.get()};
  CComVariant arg{"C:\\Windows"};
  CComVariant ret{false};
  dd.Invoke1(CComBSTR{"FolderExists"}, &arg, &ret);
  std::cout << std::boolalpha << (ret.boolVal != 0) << '\n';
}

int main()
{
  CoInitialize(0);
  check_windows_folder();
  CoUninitialize();
}
```
- [boost::intrusive_ptr用法](https://blog.csdn.net/harbinzju/article/details/6754646)
- [intrusive_ptr源码分析](https://blog.csdn.net/FreeeLinux/article/details/54670196)

在以下情况时使用 intrusive_ptr ：
- 你需要把 this 当作智能指针来使用。
- 已有代码使用或提供了插入式的引用计数。
- 智能指针的大小必须与裸指针的大小相等。