---
title: 目录结构
type: guide
order: 3
---

## 初始目录

安装好wulaphp版框架后,可以看到初始的目录结构如下：

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
│  └─ext1                      # 扩展
│     ├─classes                # 扩展类
│     └─ext1.php               # 扩展引导文件
├─includes                     # 应用使用的第三方库
│  └─ common.php               # 第三方库加载入口。
├─storage                      # 存储目录
│  ├─logs                      # 目录日志
│  └─tmp                       # 运行临时目录
├─vendor                       # composer库目录,不可自定义
├─modules                      # 模块目录
│  ├─home                      # home模块
|  │ ├─subxy                   # 子模块
|  │ │  ├─controllers          # 子模块控制器目录
|  │ │  └─views                # 子模块视图目录
│  │ ├─classes                 # 模块类目录
│  │ ├─controllers             # 模块控制器目录
│  │ │  ├─IndexController.php  # 默认控制器，首页请求由此控制器处理
│  │ │  └─OtherController.php  # 其它控制器
│  │ ├─views                   # 视图目录
│  │ │  ├─index                # IndexController的视图目录
│  │ │  │ ├─index.tpl          # 基于Smarty模板文件
│  │ │  │ ├─index.php          # 基于PHP模板文件
│  │ │  └─other                # OtherController的视图目录
│  │ │    └─xxx.tpl            # 模板文件
│  │ ├─Router.php              # 子模块路由器
│  │ └─bootstrap.php           # 模块引导文件
│  ├─...                       # 其它模块
│  └─ alias.php                # URL别名配置文件
├─themes                       # 网站前台主题目录
│  ├─default                   # 默认主题
│  │ ├─index.tpl               # 网站首页模板
│  │ ├─404.tpl                 # 404页面模板
│  │ ├─403.tpl                 # 403页面模板
│  │ ├─500.tpl                 # 500页面模板
│  │ ├─503.tpl                 # 503页面模板
│  │ └─template.php            # 主题数据处理器定义文件
│  └─theme1                    # 其它主题
│    └─...                     # 主题模板,资源等文件
├─wwwroot                      # 网站根目录
│  ├─.htaccess                 # 用于 apache 的重写
│  ├─assets                    # 公共资源目录
│  ├─index.php                 # 网站入口
│  ├─robots.txt                # 蜘蛛抓取规则文件
│  ├─favicon.ico               # 网站图标（可自定义,可删除）
│  └─crossdomain.xml           # flash跨域文件（可删除）
├─artisan                      # 命令行工具
├─bootstrap.php                # 引导配置文件
├─composer.json                # composer配置文件
└─docker-compose.sample.yml    # docker-compose样例文件
</pre>

### 目录权限

如果你使用`Mac OS`或`类Unix`系统,那么框架要求**Web服务器**能读写`storage`,`storage/logs`和`storage/logs`目录:

`$ chmod 777 storage storage/tmp storage/logs`

### 公共目录

**wulaphp**是将`wwwroot`目录作为公共(`public`)目录对外提供web服务的,只有这个目录里的文件才可以被用户直接访问.

## 自定义目录

`bootstrap.php`是用户可修改的引导配置文件,通过修改此文件中的相关常量定义可以自定义项目目录结构:

* `PUBLIC_DIR`: 网站公共目录,默认为`wwwroot`
  * 同时修改`composer.json`中的`extra.wwwroot`
* `ASSETS_DIR`: 资源目录,默认为`assets`
  * 同时修改`composer.json`中的`extra.wula.assets-dir`
* `MODULE_DIR`: 模块目录,默认为`modules`
  * 同时修改`composer.json`中的`extra.wula.modules-dir`
* `THEME_DIR`: 主题目录,默认为`themes`
  * 同时修改`composer.json`中的`extra.wula.themes-dir`
* `EXTENSION_DIR`: 扩展目录,默认为`extensions`
  * 同时修改`composer.json`中的`extra.wula.extensions-dir`
* `CONF_DIR`: 配置目录,默认为`conf`
* `LIBS_DIR`: 第三方库目录,默认为`includes`
* `STORAGE_DIR`: 存储目录,默认为`storage`
* `TMP_DIR`: 临时文件目录,默认为`tmp`
* `LOGS_DIR`: 日志文件,默认为`logs`

## 主题目录

和其它框架不同,`wulaphp`有一个特殊的目录:`themes`主题目录. 为你创建一个可更换主题的网站助力;为你开发一个CMS系统助力.
在`Controller`(控制器)的`Action`里可以通过以下代码渲染主题中的模板:

```php
class MyController extends Controller {
    public function abc(){
        // 你的业务代码 ....
        return template('my_page.tpl');
    }
}
```

更多主参考[主题](theme.html)相关文档.
