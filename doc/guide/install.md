---
title: 安装
index: 1
cate: 基础
showToc: 0
desc: 本文目的是教会大家正确并顺利地安装wulaphp。
---

目前`wulaphp`可以通过[Composer](#Composer)方式或[下载](#download)预打包的空项目模板方式进行安装。

{$toc}

## 环境要求 {#requirements}

wulaphp的要求不高，基本上默认安装的php就可以运行啦，最小要求如下:

1. php >= 5.6.9
2. JSON PHP Extension
3. Mbstring PHP Extension
4. PDO PHP Extension
5. PDO_MYSQL Extension
6. Curl PHP Extension
7. Zip PHP Extension

## Composer 方式

我们推荐通过`Composer`方式安装`wulaphp`。

### 安装

`# composer require wula/wulaphp -vvvv`

> 国内的小朋友请耐心的等待或多执行几次上边的代码。如果还是安装不成功，请通过[下载](#download)的方式进行安装。

### 初始化

安装命令完成后，执行以下代码进行项目初始化工作:

`# php vendor/bin/wulaphp init`

如果你运行在`类Unix`系统上，还需要执行以下操作将目录变为可读写：

`# chmod 777 storage storage/tmp storage/logs`

## 下载安装 {#download}

按以下步骤下载并解压到相应目录即可完成安装:

### Windows 系统

1. 点击此处[下载](https://www.wulaphp.com/wulaphp-latest.zip)最新版本的wulaphp。
2. 解压到相应的目录即可。

### 类 Unix 系统

`# wget https://www.wulaphp.com/wulaphp-latest.tar.gz`

`# tar -zxf wulaphp-latest.tar.gz`

`# cd wulaphp-latest`

`# chmod 777 storage storage/tmp storage/logs`

> 如果你能正常访问`composer`，建议执行一下`# composer update -vvvv`看看有没有更新的版本。

## 配置

`wulaphp`配置分两部分: **目录配置**框架核心目录(<small>如果你修改了目录名</small>)；**应用配置**包括应用运行时所需要的配置。

### 目录配置

`bootstrap.php`是用户可修改的引导配置文件,通过修改此文件中的相关常量定义可以自定义项目目录结构:

* `PUBLIC_DIR`: 网站公共目录(DocumentRoot),默认为`wwwroot`
  * 同时修改`composer.json`中的`extra.wwwroot`
  * 同时修改web服务器（nginx或httpd）的配置文件
* `ASSETS_DIR`: 资源目录,默认为`assets`
  * 同时修改`composer.json`中的`extra.wula.assets-dir`
* `MODULE_DIR`: [模块](module.md)目录,默认为`modules`
  * 同时修改`composer.json`中的`extra.wula.modules-dir`
  * 同时修改web服务器中静态资源配置
* `THEME_DIR`: [主题](theme/index.md)目录,默认为`themes`
  * 同时修改`composer.json`中的`extra.wula.themes-dir`
  * 同时修改web服务器中静态资源配置
* `EXTENSION_DIR`: 扩展目录,默认为`extensions`
  * 同时修改`composer.json`中的`extra.wula.extensions-dir`
* `CONF_DIR`: 配置目录,默认为`conf`
* `LIBS_DIR`: 第三方库目录,默认为`includes`
* `STORAGE_DIR`: 存储目录,默认为`storage`
* `TMP_DIR`: 临时文件目录,默认为`tmp`
* `LOGS_DIR`: 日志文件,默认为`logs`

一般情况上述目录是不需要修改的，如无特殊说明，所有文档基于上述默认目录编写。

### 应用配置

应该配置文件位于`conf`目录中，可以有多个应用配置,通过配置，你可以配置:

1. [基础配置](config/base.md)
2. [缓存配置](config/cache.md)
3. [Redis](config/redis.md)
4. [数据库](config/db.md)

详见[配置](config/index.md)。

## 验证

打开命令行，进入应用根目录(<small>artisan脚本所在的目录</small>)并执行下边的命令(<small>使用内建服务器运行wulaphp</small>)：

`php -S 127.0.0.1:8090 -t wwwroot/ wwwroot/index.php`

通过浏览器访问`http://127.0.0.1:8090/`，看到下边的输出说明安装正确:

**Hello wula !!**

如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
