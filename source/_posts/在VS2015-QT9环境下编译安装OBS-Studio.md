---
title: 在VS2015+QT9环境下编译安装OBS Studio
date: 2019-07-25 21:46:14
tags:
---
## 准备环境
- Visual Studio Enterprise 2015
- Qt 5.9.8 (MSVC2015_64)
- CMAKE 最新版

## 下载源码
````git
git clone --recursive https://github.com/obsproject/obs-studio.git
````
*记得添加 **--recursive**，用于下载所有子模块*

* 预编译依赖库下载：
    * VS2015: https://obsproject.com/downloads/dependencies2015.zip
    * VS2017: https://obsproject.com/downloads/dependencies2017.zip

## 编译


* obs-studio 文件夹下，同时新建 build, debug, release, obs-deps 文件夹，将  dependencies.zip 对应内容拷贝到  obs-deps 中。
![文件夹](/img/TIM20190725212203.png)

* 打开 CMAKE，选择对应的 sourse 和 build 文件夹，Add Entry 添加三项内容：
    * DepsPath PATH C:/obs-studio/obs-deps/win64 (对应自己的文件夹)
    * QTDIR PATH C:/Qt/Qt5.9.8/5.9.8/msvc2015_64 (对应自己的文件夹)
    * BUILD_TESTS BOOL 勾选 Value
![CMAKE](/img/TIM20190725215018.png)

* 点击 Configure，选择 VS2015 X64 (根据实际情况选择)，检查确认 COPY_DEPENDENCIES 已勾选。
* 再次点击 Configure，红色框变白，点击 Generate 生成工程。
* VS2015打开 sln 文件，启动项目为 ALL_BUILD，直接生成解决方案。
* OK了，可执行程序目录： ...\obs-studio\build\rundir\Debug\bin\64bit
![OBS](/img/TIM20190725215144.png)