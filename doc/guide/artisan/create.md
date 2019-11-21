---
title: create 脚手架
showToc: 0
index: admin artisan
keywords: admin artisan 命令行工具 脚手架
desc: 脚本架，通过此命令可以快速创建模块，控制器等
---

{$toc}

简单的脚本架，通过此命令可以快速创建模块、扩展、控制器、模型和处理器。

运行`php artisan create`

<pre>
create module,extension,controller,model and handler

Usage: #php artisan create <command>

Options:
  -h, --help     display this help message
  -v             display wulaphp version

Commands:
  controller     Create a Controller
  extension      Create an extension
  hook           Create a Hook Handler Class
  model          Create a Model Class
  module         Create a module

Run '#php artisan create <command> --help' for more information on a command
</pre>

## 模块 {#module}

<pre>
Usage: #php artisan create module [options] <module>

Options:
  -c             create composer.json for module
  -n             the name of module
  --name         the name of module
</pre>

## 扩展 {#ext}

<pre>
Usage: #php artisan create extension [options] <name>

Options:
  -b             create the bootstrap file for the extension
  -c             create composer.json for extension
</pre>

## 控制器 {#controller}

<pre>
Usage: #php artisan create controller [options] <module> <name>

Options:
  -t             create tpl with specified view engine
</pre>

## 数据模型 {#model}

<pre>
Usage: #php artisan create model <module> <tableName>
</pre>

## 处理器 {#handler}

<pre>
Usage: #php artisan create hook [options] <module> <hook>

Options:
  -a             alter
</pre>

> 如果你创建的是修改器类型的处理器，请提供`-a`参数。
