---
title: 目录结构
index: 1
showToc: 0
cate: 基础
desc: wulaphp的默认目录结构
---

安装好`wulaphp`框架并初始化后,可以看到初始目录结构：

<img src="/doc/guide/img/dir.jpg" style="width:237px" alt="dir"/>

## 详细说明

<pre>
project
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
├─vendor                       # composer库目录,不可自定义
├─wwwroot                      # 网站根目录 (DocumentRoot)
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

## 目录权限

如果你使用`Mac OS`或`类Unix`系统,那么框架要求**Web服务器**能读写`storage`,`storage/logs`和`storage/logs`目录。
可以通过下边的命令将它们设为可读写:

`$ chmod 777 storage storage/tmp storage/logs`

## 公共目录 (DocumentRoot)

**wulaphp**是将`wwwroot`目录作为公共(`DocumentRoot`)目录对外提供web服务的,只有这个目录里的文件才可以被用户直接访问.

<p class="tip" markdown=1>可以通过配置web服务器来增加静态资源目录。
具体可以参考[Nginx 配置](nginx.md#static)与[Httpd 配置](httpd.md#static)</p>

## 自定义目录

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

## 主题目录

和其它框架不同，`wulaphp`有一个特殊的目录:`themes`主题目录。为你创建一个可更换主题的网站助力;为你开发一个CMS系统助力。
在`Controller`(控制器)的`Action`里可以通过以下代码渲染主题中的模板:

```php
class MyController extends Controller {
    public function abc(){
        $data = [];
        // 你的业务代码 ....
        return template('my_page.tpl',$data);
    }
}
```

更多参考[主题](theme/index.md)相关文档.
