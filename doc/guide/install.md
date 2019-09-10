---
title: 安装
index: 1
cate: 基础
showToc: 0
desc: 本文目的是教会大家正确并顺利地安装wulaphp。
---

{$toc}

## 环境要求 {#reqs}

`wulaphp`的要求不高，基本上默认安装的`php`就可以运行啦，最小要求如下:

1. PHP >= `7.1`
2. JSON PHP Extension: `json`
3. Regular Expressions: `pcre`
4. Mbstring PHP Extension: `mbstring`
5. PDO PHP Extension: `PDO`
6. PDO_MYSQL Extension: `pdo_mysql`

## Composer 方式

### 安装

`composer require wula/wulaphp -vvv`

> 国内的小朋友请耐心的等待或多执行几次上边的代码。如果还是安装不成功，请通过[下载](#download)的方式进行安装。

### 初始化

安装命令完成后，执行以下代码进行项目初始化工作:

* Windows: `vendor\bin\wulaphp int`
* 类Unix:  `vendor/bin/wulaphp init`

如果你运行在`类Unix`系统上，还需要执行以下操作将目录变为可读写：

`# chmod 777 storage storage/tmp storage/logs`

## 下载安装 {#download}

### Windows 系统

1. 点击此处[下载](http://down.wulaphp.com/wulaphp-latest.zip)最新版本包。
2. 解压到相应的目录即完成安装。

### 类Unix 系统

执行以下命令进行下载安装:

`wget http://down.wulaphp.com/wulaphp-latest.tar.gz`

`tar -zxf wulaphp-latest.tar.gz`

`cd wulaphp`

`chmod 777 storage storage/tmp storage/logs`

<p class="tip" markdown=1>如果你能正常访问`composer`，建议执行一下`composer update -vvv`将所有依赖包升级到最新版本。</p>

## 验证

打开命令行，进入应用根目录(<small markdown=1>`artisan`脚本所在的目录</small>)并执行下边的命令(<small>使用内建服务器运行</small>)：

* Windows: `php -S 127.0.0.1:8090 -t wwwroot\ wwwroot\index.php`
* 类Unix: `php -S 127.0.0.1:8090 -t wwwroot/ wwwroot/index.php`

通过浏览器访问<a href="http://127.0.0.1:8090" target="_blank">http://127.0.0.1:8090</a>，看到下边的输出:

<p class="success" markdown=1>
**Hello wula !!**
</p>

恭喜你，安装顺利完成。来个模块尝尝鲜吧，[立即开始编写第一个模块](start.md)。

> 如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。

## Web服务器配置 {#deploy}

有需要时，[Nginx](nginx.md) 或 [Apache Httpd](httpd.md)任君挑选。

## 开发环境

可以使用[docker](docker.md)或[Vagrant](vagrant.md)免去你配置PHP开发环境的痛苦哦。
