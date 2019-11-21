---
title: 如何工作
showToc: 0
index: 1
keywords: 生命周期 入口 引导 框架 bootstrap http
desc: 详细说明wulaphp处理请求的流程，知其然，知其所以然。
---

<p class="success" markdown=1>知其然，知其所以然！如果你知道`wulaphp`是如何工作的，那么你就能很轻松地驾驭它。</p>

{$toc}

## 生命周期 {#lifecycle}

**wulaphp**中有**HTTP 请求**与**Console 脚本**两种生命周期。

### HTTP 请求 {#req}

#### 入口 {#entry1}

所有HTTP请求都会被WEB服务器(`nginx`、`httpd`等)通过重写的方式转发到入口文件:`wwwroot/index.php`。
入口文件加载`bootstrap.php`文件对框架进行引导，框架引导完成后通过`App::run`启动**HTTP**请求分发。

#### 框架引导 {#bootstrap}

框架引导由`bootstrap.php`文件完成。通过以下步骤对系统进行引导，完成框架的初始化工作:

1. 定义目录，常量，公用函数，错误处理，缓冲区管理等等
   1. `include`核心类（配置，缓存，多语言相关)
   2. 注册类自动加载函数
2. 初始化插件机制
3. 加载公用类库
4. 启动App
   1. 加载语言库
   2. 创建配置加载器
   3. 创建扩展加载器
   4. 创建模块加载器
5. 加载默认配置
6. 加载扩展
7. 加载模块
   1. 模块绑定勾子处理器

#### 分发请求 {#despatch}

`App::run`函数创建路由器`Router`的实例并将请求交由其分发。路由器将请求分发给不同的分发器处理。系统默认提供了3个分发器:

1. `MVC`分发器(默认分发器)，将URL按**所见即所得**规则分发给模块的控制器处理。
2. 路由表分发器，根据用户定义的路由表分发请求。
3. 静态资源分发器，处理模块，主题等的静态资源。

如果上述分发器分发请求失败，则路由器会将请求分发给用户[自定义分发器](advance/route.md#dispacther)处理。

#### 绘制视图 {#render}

如果路由器分发成功，其会得到一个视图。路由器将视图交给`Response`响应实例绘制并输出给用户。

### Console 脚本 {#artisan}

所有**Console 脚本**直接加载`bootstrap.php`文件完成框架引导(同[HTTP请求分发中的框架引导](#bootstrap))，不必启动**HTTP**请求分发！

框架引导完成后，直接执行脚本文件。有一点需要注意：不管你的脚本文件在哪个目录请保证能正确`include`到`bootstrap.php`文件.

> 可以通过`wulaphp`提供的[artisan](artisan/index.md)命令更优雅的编写**Console 命令**

## 流程图 {#flow}

基于上文的描述，我们为你整理了一个大致的能描述`wulaphp`生命周期的流程图，如下:

![wulaphp流程图](/themes/imgs/flow.png)

## 接下来 {#next}

当你搞懂了以上内容之后，请开始享受**wulaphp**吧，立即从[模块]开始。

[模块]: module/index.md
