---
title: 安装
pageTitle: 安装和环境配置
index: 1
cate: 基础
showToc: 0
desc: 本文目的是教会大家正确并顺利地安装wulaphp。
---

{$toc}

## 环境要求 {#reqs}

**wulaphp**的要求不高，基本上默认安装的`PHP`就可以。强烈推荐使用为**wulaphp**定制的[docker](docker.md)镜像或[Vagrant](vagrant.md)虚拟机做为你本地的开发环境。

如果你不使用[docker](docker.md)镜像或[Vagrant](vagrant.md)虚拟机，请确保你的`PHP`满足以下要求:

- PHP >= `7.1`
- JSON PHP Extension: `json`
- Regular Expressions: `pcre`
- Mbstring PHP Extension: `mbstring`

## 安装 {#install}

### 下载 {#download}

#### Windows {#windows}

1. 点击[此处下载](https://www.wulaphp.com/wulaphp-latest.zip)最新版本包。
2. 解压到相应的目录即完成安装。

#### Mac/Linux {#unix}

执行以下命令进行下载安装:

`wget https://www.wulaphp.com/wulaphp-latest.tar.gz`

`tar -zxf wulaphp-latest.tar.gz && cd wulaphp`

#### 更新 {#upgrade}

如果你能正常访问`composer`，执行一下`composer update -vvv`将所有依赖包升级到最新版本。

### Composer {#composer}

`composer require wula/wulaphp -vvv`

国内的小朋友请耐心的等待或多执行几次上边的代码。如果还是安装不成功，请通过[下载](#download)的方式进行安装。

#### 初始化 {#init}

安装完成后，执行以下代码进行项目初始化工作:

**Windows:** `vendor\bin\wulaphp int`

**Mac/Linux:**  `vendor/bin/wulaphp init`

## 目录权限 {#chmod}

如果你运行在`Mac or Linux`系统上，执行以下操作将目录变为可读写：

`chmod 777 storage storage/tmp storage/logs`

## 运行 {#run}

打开命令行，执行下边的命令(<small>使用内建服务器运行</small>)：

`php artisan serve`

通过浏览器访问`http://127.0.0.1:8080`，看到下边的输出:

<div class="demo-wrapper"> <div class="demo">
<h1>Hello wula !!</h1>
</div></div>

恭喜你，安装顺利完成。来个模块尝尝鲜吧，[立即开始编写第一个模块](start.md)。

> 如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。

## Web服务器配置 {#deploy}

**wulaphp**可以很方便的和[Nginx](nginx.md)或[Apache Httpd](httpd.md)集成在一起使用。
