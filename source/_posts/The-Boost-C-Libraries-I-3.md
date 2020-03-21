---
title: 'The Boost C++ Libraries: I.3 SCOPE_EXIT'
date: 2019-08-27 10:46:13
tags:
- boost
- C++
categories:
- boost
---

### 使用 BOOST_SCOPE_EXIT
```C++
#include <boost/scope_exit.hpp>
#include <iostream>

int *foo()
{
  int *i = new int{10};
  BOOST_SCOPE_EXIT(&i)
  {
    delete i;
    i = 0;
  } BOOST_SCOPE_EXIT_END
  std::cout << *i << '\n';
  return i;
}

int main()
{
  int *j = foo();
  std::cout << j << '\n';
}
```
- BOOST_SCOPE_EXIT块接收指针i的引用，块内的内容将在函数最后执行。
- cout<<*i 输出10，return返回的也是指针i被置0之前的内容，cout << j 输出随机的地址。


### ScopeExit 与 C++11 lambda 表达式
```C++
#include <iostream>
#include <utility>

template <typename T>
struct scope_exit
{
  scope_exit(T &&t) : t_{std::move(t)} {}
  ~scope_exit() { t_(); }
  T t_;
};

template <typename T>
scope_exit<T> make_scope_exit(T &&t) { return scope_exit<T>{
  std::move(t)}; }

int *foo()
{
  int *i = new int{10};
  auto cleanup = make_scope_exit([&i]() mutable { delete i; i = 0; });
  std::cout << *i << '\n';
  return i;
}

int main()
{
  int *j = foo();
  std::cout << j << '\n';
}
```


### BOOST_SCOPE_EXIT 特性 
```C++
#include <boost/scope_exit.hpp>
#include <iostream>

struct x
{
  int i;

  void foo()
  {
    i = 10;
    BOOST_SCOPE_EXIT(void)
    {
      std::cout << "last\n";
    } BOOST_SCOPE_EXIT_END
    BOOST_SCOPE_EXIT(this_)
    {
      this_->i = 20;
      std::cout << "first\n";
    } BOOST_SCOPE_EXIT_END
  }
};

int main()
{
  x obj;
  obj.foo();
  std::cout << obj.i << '\n';
}
```
- 当定义了多个BOOST_SCOPE_EXIT块时，这些块将被逆序执行。
- 参数不能为空，当没有参数传入时，使用void。
- 在成员函数中使用BOOST_SCOPE_EXIT，当要传入当前对象的指针时，使用this_。


### 练习
将unique_ptr和deleter改写成 SCOPE_EXIT
```C++
#include <string>
#include <memory>
#include <cstdio>

struct CloseFile
{
    void operator()(std::FILE *file)
    {
        std::fclose(file);
    }
};

void write_to_file(const std::string &s)
{
    std::unique_ptr<std::FILE, CloseFile> file{
      std::fopen("hello-world.txt", "a") };
    std::fprintf(file.get(), s.c_str());
}

int main()
{
    write_to_file("Hello, ");
    write_to_file("world!");
}
```

```C++
#include <string>
#include <boost/scope_exit.hpp>
#include <iostream>

void write_to_file(const std::string& s)
{
	std::FILE* file = std::fopen("hello-world.txt", "a");
	BOOST_SCOPE_EXIT(file)
	{
		std::fclose(file);
	} BOOST_SCOPE_EXIT_END
	std::fprintf(file, s.c_str());
}

int main()
{
	write_to_file("Hello, ");
	write_to_file("boost!");
}
```