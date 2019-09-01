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

1. php >= 5.6.9 `建议 7.1+`
2. JSON PHP Extension: `json`
3. Mbstring PHP Extension: `mbstring`
4. PDO PHP Extension: `PDO`
5. PDO_MYSQL Extension: `pdo_mysql`
6. Curl PHP Extension: `curl`
7. Zip PHP Extension: `zip`

> 执行 `#php -m` 可以查看安装了哪些扩展。

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

> 如果你能正常访问`composer`，建议执行一下`#composer update -vvvv`将所有依赖包升级到最新版本。

## 验证

打开命令行，进入应用根目录(<small>artisan脚本所在的目录</small>)并执行下边的命令(<small>使用内建服务器运行wulaphp</small>)：

`php -S 127.0.0.1:8090 -t wwwroot/ wwwroot/index.php`

通过浏览器访问<a href="http://127.0.0.1:8090" target="_blank">http://127.0.0.1:8090</a>，看到下边的输出:

<p class="success" markdown=1>
**Hello wula !!**
</p>

恭喜你，安装完成。

> 如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
