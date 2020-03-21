---
title: VS2019编译使用boost库
date: 2019-07-29 16:17:42
tags: 笔记
---
### 前言
准备尝试用Boost.Asio 编写Web服务器
Boost.Asio依赖于如下的库：
 - **Boost.System**：这个库为Boost库提供操作系统支持。
 - **Boost.Regex**：使用这个库（可选的）以便你重载read_until()或者async_read_until()时使用boost::regex参数。
 - **Boost.DateTime**：使用这个库（可选的）以便你使用Boost.Asio中的计时器。
 - **OpenSSL**：使用这个库（可选的）以便你使用Boost.Asio提供的SSL支持。

开始学习Boost库。

#### 坑
第一次使用NuGet包管理器安装了VS提供的boost包，结果程序报错LNK1104
![nuget](/img/20190729162137.png)
第二次选择了boost vc142的包，然后...
![nuget2](/img/20190729163122.png)
于是决定重新编译boost库
参考文章: [**vs2019无法打开文件“libboost_thread-vc141-mt-gd-1_69.lib”**](https://blog.csdn.net/qq_39187538/article/details/92767707)
参考文章中的命令，开始编译
`bjam stage --toolset=msvc-14.1 --without-python --stagedir="c:\Boost" link=static runtime-link=shared runtime-link=static threading=multi debug release `
编译过程顺利，将附加包含目录和附加库目录添加到项目属性中，运行test程序，再次显示  *错误    LNK1104    无法打开文件“libboost_date_time-vc142-mt-gd-x32-1_70.lib”*
#### 原因
分析错误信息，可能是找不到对应的 lib 文件。观察文件名可以发现以下信息：
- libboost_date_time 对应Boost.DateTime库
- vc142 对应VS2019的**VC 版本**
- mt-gd 多线程调试
- x32 程序运行位宽
- 1_70 boost库版本

前面编译的时候`--toolset=msvc-14.1`处使用了vc14.1，对应vs2017平台集
需要改成`--toolset=msvc-14.2`，此时生成的lib就可以在VS2019中使用了

### Boost库

> Boost provides free peer-reviewed portable C++ source libraries.

[Boost 官网](www.boost.org) 下载boost_1_70_0.zip(最新版本)并解压
开始菜单找到 vs 2019->Developer Command Prompt for VS 2019，右键以管理员身份打开
进入 boost_1_70_0 文件夹 `cd C:\boost\boost_1_70_0`
运行 `bootstrap.bat`

### 编译
![build](/img/20190729162510.png)
```PowerShell
bjam stage --toolset=msvc-14.2 --without-python --stagedir="c:\Boost" link=static runtime-link=shared runtime-link=static threading=multi debug release
```
每个文件生成了8个版本 shared static debug release x86 x64
可根据需要在命令中更改要编译的版本

### 配置
项目属性->C/C++->常规->附加包含目录 添加 `C:\boost\boost_1_70_0`
项目属性->链接器->常规->附加库目录 添加 `C:\boost\lib`
Run!
![run](/img/20190729172246.png)