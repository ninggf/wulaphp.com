---
title: 介绍
type: guide
order: 1
---

## wula.php为什么?

没有为什么，就是想弄一个安全、小巧、高效、灵活，没那么多概念，学习成本极低，可以快速上手，可以专注于业务的框架。我们正在努力...

## wula.php的原则

**约定大于配置**

1. 少写很多配置，多人合作时减少代码冲突。
2. 所见即所得的URL，不需要路由，多人合作时减少代码冲突。

**一切从简**

1. 不弄新名词
2. 不搞新概念
3. 开箱即用

**模块化**

1. 以模块为功能组织单元
2. 模块自恰以便共享

<p class="tip">以上是为了凑字数瞎写的，您看看就好^_^</p>

## 目录结构

<pre>
wula
|--conf
   |--cache_config.php 
   |--config.php 
   |--dbconfig.php
|--crontab
   |--cron.php
|--extensions
|--includes
   |-- common.php # 第三方库加载入口。
|--logs 
|--tmp
|--vendor
|--wwwroot
   |--modules
      |--home
         |--classes 
         |--controllers 
            |--HomeController.php
         |--views
            |--home
               |--index.tpl
         |--bootstrap.php
   |--themes
      |--default
         |--index.tpl
         |--404.tpl
         |--template.php
   |--index.php
   |--.htaccess
|--.env.example
|--bootstrap.php
|--composer.json
|--artisan
</pre>

### bootstrap.php 
框架引导脚本，抓着自己的鞋带将自己拉起来。框架的核心配置都在这个文件中，还是那句话，一班的人不改，二班的可以改：

1. `PUBLIC_DIR` 网站对外目录，默认是`wwwroot`。
2. `ASSETS_DIR` 静态资源目录，默认是`assets`，影响Smarty模板的`assets`修改器(modifier).
3. `VENDOR_DIR` 通过composer安装的静态资源，默认是`vendor`，影响Smarty模板的`vendor`修改器(modifier).
4. `MODULE_DIR` [模块](module.html)目录,默认是`modules`.
5. `THEME_DIR`  [主题模板](theme.html)目录,默认是`themes`.
6. `EXTENSION_DIR` [扩展](ext.html)目录,默认是`extensions`.
7. `CONF_DIR`  [配置](config.html)目录，默认是[conf](#conf)
8. `LIBS_DIR`  第三方函数库目录,默认是`includes`
9. `LOGS_DIR`  日志目录，默认为`logs`
10. `TMP_DIR`  运行临时目录，默认为`tmp`
11. `RUNTIME_MEMORY_LIMIT` 最大运行时内存, 默认是**128M**.
12. `EXTENSION_LOADER_CLASS` [扩展加载器](ext.html#加载器).
13. `CONFIG_LOADER_CLASS` [配置加载器](config.html#加载器).
14. `MODULE_LOADER_CLASS` [模块加载器](module.html#加载器).

### artisan
工具脚本，执行`php artisan`看一下有哪些命令可以用。

### conf
此目录由`CONF_DIR`配置。理论上应用的所有配置文件都存放于此. 框架默认提供了三个配置文件:
1. `cache_config.php`[缓存配置](config.html#缓存配置)文件.
2. `config.php`[应用配置](config.html#应用配置)文件，可通过.env(将.env.example复制到.env)文件进行配置
3. `dbconfig.php`[数据库配置](config.html#数据库配置)文件，可通过.env文件中的db段进行配置.

### crontab
定时任务运行目录，可随意命名，如果不需要定时任务可删除.`cron.php`为框架提供的默认定时任务脚本, 通过定时任务运行,一分钟运行一次:
- linux crontab.
- windows 定时计划.

### extensions
此目录由`EXTENSION_DIR`配置, 存放系统扩展，关于扩展点击查看[详细](ext.html)。

### includes
应用使用的第三方库（不可通过composer加载），可通过`LIBS_DIR`常量自定义。
1. `common.php`第三方库加载入口。

### logs
目录日志，可通过LOGS_DIR常量自定义. **此目录需要web server可读写**。

### tmp
运行临时目录，可通过TMP_DIR常量自定义, 模板缓存，运行期产生的文件都是可以存放在此目录.**此目录需要web server可读写**。

### vendor
composer库目录,不可自定义。

### wwwroot
网站根目录，如果网站根目录不是此目录，需要修改WWWROOT_DIR或PUBLIC_DIR常量值。

- modules [模块](module.html)目录, 可通过`MODULE_DIR`.
- themes 网站前台[主题目录](theme.html),可通过`THEME_DIR`常量自定义
- index.php 网站入口文件.
- .htaccess apache的指令文件

### .env.example 
环境配置示例文件，通过将它复制为`.env`可以实现开发时[配置隔离](config.html#环境配置).

### composer.json
[composer](https://getcomposer.org/doc/04-schema.md)项目文件。
