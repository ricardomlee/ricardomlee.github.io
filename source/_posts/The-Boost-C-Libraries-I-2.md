---
title: 'The Boost C++ Libraries: I.2 指针容器'
date: 2019-08-19 20:14:04
tags:
- boost
- C++
categories:
- boost
---

### boost::ptr_vector
- 初始化：
`boost::ptr_vector<int> v;`
`v.push_back(new int{1});`
- 基本功能与std::vector<std::unique_ptr<int>>相同
- 保存的是动态分配的对象，因此back()返回一个动态分配的对象而不是指针

### boost::ptr_set
```C++
#include <boost/ptr_container/ptr_set.hpp>
#include <boost/ptr_container/indirect_fun.hpp>
#include <set>
#include <memory>
#include <functional>
#include <iostream>

int main()
{
  boost::ptr_set<int> s;
  s.insert(new int{2});
  s.insert(new int{1});
  std::cout << *s.begin() << '\n';

  std::set<std::unique_ptr<int>, boost::indirect_fun<std::less<int>>> v;
  v.insert(std::unique_ptr<int>(new int{2}));
  v.insert(std::unique_ptr<int>(new int{1}));
  std::cout << **v.begin() << '\n';
}
```
- 使用boost::ptr_set时，元素的顺序取决于int值的大小。
- 使用std::set时，默认只比较指针，不比较int值的大小。
- boost::indirect_fun告诉set应该使用什么样的顺序。
- 其他容器与STL类似：boost::ptr_deque, boost::ptr_list, boost::ptr_map, boost::ptr_unordered_set, and boost::ptr_unordered_map。

### Inserters 
```C++
#include <boost/ptr_container/ptr_vector.hpp>
#include <boost/ptr_container/ptr_inserter.hpp>
#include <array>
#include <algorithm>
#include <iostream>

int main()
{
  boost::ptr_vector<int> v;
  std::array<int, 3> a{{0, 1, 2}};
  std::copy(a.begin(), a.end(), boost::ptr_container::ptr_back_inserter(v));
  std::cout << v.size() << '\n';
}
```
- ptr_back_inserter生成ptr_back_insert_iterator，传给std::copy然后将a的内容拷贝给v。
- v保存动态分配的int对象的地址，因此inserter会在堆上new一个int对象，然后将地址给v。
- 其他inserters：boost::ptr_container::ptr_front_inserter()，boost::ptr_container::ptr_inserter()