---
title: 目录结构
index: 1
showToc: 1
cate: 基础
desc: wulaphp的默认目录结构
---

<img src="/doc/guide/img/dir.jpg" style="width:300px" alt="dir"/>

## 目录明细 {#preview}

<pre>
project                        # 项目部署目录
├─conf                         # 配置目录
│  ├─.env                      # 开发环境配置
│  ├─.env.example              # 环境配置示例文件
│  ├─cache_config.php          # 缓存配置文件
│  ├─config.php                # 默认应用配置文件
│  ├─dbconfig.php              # 默认数据库配置文件
│  ├─cluster_config.php        # 基于Redis的分布式运行时缓存
│  ├─redis_config.php          # redis配置文件
│  └─site.conf                 # docker中nginx的网站配置文件
├─crontab                      # 定时任务运行目录
│  └─cron.php                  # 定时任务脚本
├─extensions                   # 扩展目录
├─includes                     # 应用使用的第三方库
│  └─ common.php               # 第三方库加载入口。
├─modules                      # 模块目录，大部分时间你将在这个目录里工作
│  ├─home                      # home模块
│  │ ├─classes                 # 模块类目录
│  │ ├─controllers             # 模块控制器目录
│  │ │  └─IndexController.php  # 默认控制器，首页请求由此控制器处理
│  │ ├─views                   # 视图目录
│  │ │  └─index                # IndexController的视图目录
│  │ │    └─index.tpl          # 基于Smarty模板文件
│  │ ├─hooks                   # Hooks处理器目录
│  │ └─bootstrap.php           # 模块引导文件
│  ├─...                       # 其它模块
│  └─ alias.php                # URL别名配置文件
├─storage                      # 存储目录
│  ├─logs                      # 目录日志
│  └─tmp                       # 运行临时目录
├─tests                        # 测试目录（基于phpunit)
├─themes                       # 网站前台主题目录
│  └─default                   # 默认主题
│    ├─index.tpl               # 网站首页模板
│    ├─404.tpl                 # 404页面模板
│    ├─403.tpl                 # 403页面模板
│    ├─500.tpl                 # 500页面模板
│    ├─503.tpl                 # 503页面模板
│    └─template.php            # 主题数据处理器定义文件
├─vendor                       # composer 库目录,不可自定义
├─wwwroot                      # WEB目录 (对外访问目录)
│  ├─.htaccess                 # 用于 apache 的重写
│  ├─assets                    # 公共资源目录
│  ├─index.php                 # 网站入口
│  ├─robots.txt                # 蜘蛛抓取规则文件
│  ├─favicon.ico               # 网站图标（可自定义,可删除）
│  └─crossdomain.xml           # flash跨域文件（可删除）
├─artisan                      # 命令行工具
├─bootstrap.php                # 引导配置文件
└─docker-compose.sample.yml    # docker-compose样例文件
</pre>

## 目录权限 {#acl}

在`Mac OS`或类`Unix`系统中,框架要求能读写`storage`,`storage/logs`和`storage/logs`目录。
可以通过下边的命令将它们设为可读写:

`chmod 777 storage storage/tmp storage/logs`

## 框架引导文件 {#bootstrap}

`bootstrap.php`是框架的引导文件，负责初始化并拉起框架。可通过该文件对框架进行一定的自定义定制。

## 公共目录 (DocumentRoot) {#wwwroot}

默认情况下**wulaphp**将`wwwroot`目录作为公共(`DocumentRoot`)目录对外提供web服务,只有这个目录里的文件才可以被用户直接访问。
可以通过下文的[自定义目录](#custom)方法修改公共目录。

### assets

公共资源目录，建议将静态资源如图片、CSS、JS等放在此目录。

## 模块目录 {#module}

**wulaphp**通过模块来组织代码，可以将实现相关业务单元的代码组织在一起形成一个模块(<small>通过合理的模块设计，可以很好的重用代码</small>)。**一个模块就是`modules`目录下的一个目录**。
该目录的**名字**同时也是模块的[命名空间](https://www.php.net/manual/zh/language.namespaces.php)。一个模块里包括：

1. 引导文件: bootstrap.php (`必须`)
2. 控制器
3. 视图
4. 模型
5. Hooks处理器
6. 其它类、脚本、业务相关的其它文件等

以`hello`做为模块**HelloWorld**的目录，其结构大致如下:

<img src="/doc/guide/img/mdir.jpg" width="239px" alt="module dir"/>。

<p class="tip" markdown=1>上述目录结构可以通过`php artisan create module hello`创建。</p>

### 命名空间 {#ns}

**wulaphp**对**模块命名空间**有着严格的规定:

1. 模块类(<small markdown=1>在引导文件`bootstrap.php`中定义</small>)的**命名空间**必须与模块**目录名**相同。
2. 在模块里定义的类（包括控制器类）的**命名空间**是基于其**目录层级**所形成**子命名空间**。
3. 在模块里定义的类（包括控制器类）的类名与文件名同名(注意大小写)。
4. 符合命名空间约定的类都可以按需自动加载(autoload)。

### 控制器目录 {#ctrl}

控制器只能放在`controllers`目录里。

### 视图目录 {#views}

视图只能放在`views`目录里。

### 类目录 {#cls}

默认是放在`classes`目录。除了`controllers`与`views`目录，大家可以便宜行事。

<p class="tip" markdown=1>推荐大家把模型类放到`model`目录中</p>

### Hooks

勾子类存放目录，此目录内的勾子类通过懒加载的方式在勾子事件触发时才被加载调用。

### 模块引导文件 {#mbootstrap}

模块的`bootstrap.php`文件是模块的引导文件也是模块必不可少的一个文件(注意:不是[框架引导文件](#bootstrap)哦)，我们需要在这个文件中定义模块类并将其实例注册到框架，内容大致如下:

```php
namespace hello; # 模块类的命名空间必须与模块目录相同

use wulaphp\app\App;
use wulaphp\app\Module;

class HelloWorldModule extends Module {
    public function getName() {
        return 'HelloWorld';
    }
}

App::register(new HelloWorldModule()); # 注册模块
```

## 主题目录 {#theme}

和其它框架不同，`wulaphp`有一个特殊的目录:`themes`主题目录。为你创建一个可更换主题的网站助力;为你开发一个CMS系统助力。
更多参考[主题](theme/index.md)相关文档。

## 配置目录 {#conf}

默认为`conf`，应用配置文件放在此目录。

## 存储目录 {#storage}

默认为`storage`，日志、模板编译文件等运行时产生文件都可以存储在该目录。

### tmp

临时文件存放目录

### logs

日志文件存放目录

## 自定义目录名 {#custom}

**bootstrap.php**是用户可修改的引导配置文件,通过修改此文件中的相关常量定义可以自定义项目目录结构:

* `PUBLIC_DIR`: 网站公共目录(DocumentRoot),默认为`wwwroot`
  * 同时修改`composer.json`中的`extra.wwwroot`
  * 同时修改web服务器（nginx或httpd）的配置文件
* `ASSETS_DIR`: 资源目录,默认为`assets`
  * 同时修改`composer.json`中的`extra.wula.assets-dir`
* `MODULE_DIR`: 模块目录,默认为`modules`
  * 同时修改`composer.json`中的`extra.wula.modules-dir`
  * 同时修改web服务器中静态资源配置
* `THEME_DIR`: 主题目录,默认为`themes`
  * 同时修改`composer.json`中的`extra.wula.themes-dir`
  * 同时修改web服务器中静态资源配置
* `EXTENSION_DIR`: 扩展目录,默认为`extensions`
  * 同时修改`composer.json`中的`extra.wula.extensions-dir`
* `CONF_DIR`: 配置目录,默认为`conf`
* `LIBS_DIR`: 第三方库目录,默认为`includes`
* `STORAGE_DIR`: 存储目录,默认为`storage`
* `TMP_DIR`: 临时文件目录,默认为`tmp`
* `LOGS_DIR`: 日志文件,默认为`logs`

## 接下来 {#next}

接下来去看一下**wulaphp**的[约定与规范](convention.md)，以便更好的理解与使用它。
