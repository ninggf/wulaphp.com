---
title: 前言
type: guide
order: 1
---

## 介绍
她的名来自电影《异星战场》里那个速度极快的狗狗(真的很快) - 乌拉(wula)，wulaphp和她一样快。
她是一个简单、小巧、高效、快速、灵活、模块化的轻量级`PHP MVC`开发框架；
她是一个学习成本极底，任何人都可以快速上手，只需专注于业务开发的框架；
她是一个站在前辈肩膀上的新框架，集前辈优点于一身，时刻将性能、简洁、易用做为最高设计原则。

她遵循`MIT`开源许可协议发布，放心使用。

她自身仍在快速发展中，生态环境也在蓬勃成长。

* 欢迎参与项目维护:
    1. [修订记录](https://github.com/ninggf/wulaphp/blob/v2.0.0/changelog.md)
    2. [贡献者名单](https://github.com/ninggf/wulaphp/graphs/contributors)
* 生态环境
    1. [wulacms](https://github.com/ninggf/wulacms)基于wulaphp的CMS系统.
    2. [jqadmin](https://github.com/ninggf/wula_assets_jqadmin/tree/v2.0)后台界面UI

## 特性
- 小巧，她是一个简单的基于MVC设计模式开发的框架。
    - 她是一个composer包，可以通过composer进行引用
    - 她只依赖`psr/log`与`smarty/smarty`这两个第三方库
    - 高效的类懒加载机制
- 基于插件(plugin)机制提供无限扩展性.
- 利用模块(module)来合理组织你的应用,大大提高代码重用率.
- 提供扩展(extension)机制,将通用功能高度内聚,大大提高代码重用率.
- 允许自定义View模板，用你最熟悉的模板，一切都是那么亲切~
    - 内置Smarty,Xml,Json,PHP等
- 支持Annotation（注解）让编码不那么死板。
    - 权限控制
    - 布局配置
    - 其它数据...
- 基于[Trait](http://php.net/manual/zh/language.oop5.traits.php)机制为控制器(Controller)提供自定义特性:
    - `SessionSupport`: Session支持
    - `PassportSupport`: 通行证支持,依赖`SessionSupport`
    - `RbacSupport`: Rbac权限支持,依赖`PassportSupport`
    - `CacheSupport`: 缓存支持
    - `LayoutSupport`: 布局支持(仅限Smarty模板)
    - ...更多自定义特性
- 适度封装数据库访问(Table,View)和简易的ORM.
    - 支持多数据源
    - 像写SQL一样操作数据库(链式操作)
    - 集成验证特性
    - 事务处理透明
    - ORM支持一对一,一对多,多对多关系
    - ORM支持预加载与懒加载机制
- 支持所见即所得的URL路由及基于插件的URL路由自定义功能.
    - 支持子模块
    - 支持默认模块
    - 支持路由表
    - 支持URL别名
    - 支持**自定义的路由器**
- 支持多语言(国际化)
    - 可以根据语言自动选择模板
- 基于`apc`,`yac`,`xcache`提供运行时缓存，让应用在产品模式(`pro`)下飞起来.
    - 类路径缓存
    - 配置缓存
- 基于redis提供分布式部署支持.
- 内置基于`Redis`的分布式锁.
- 基于redis或memcached提供缓存支持.
    - 可通过插件来自定义不同的缓存支持
- 提供`artisan`工具,告别手工脚本,并内置以下命令:
    - `service` 命令,让你的脚本在后台运行, 支持三种类型:
        * `cron` 精确到秒的定时任务
        * `script`或`parallel` 同时运行多个脚本
        * `gearman` Gearman Worker 
    - `run` 同时运行多个脚本
    - `cron` 精确到秒的定时任务
    - 你自己实现的命令

## 适场景
**wulaphp**是通用WEB开发框架，她是高性能、模块化、可扩展的PHP MVC框架，用她可以开发任意类型的WEB应用。
内置的分布式、缓存等特性让她可以更好的应对高并发应用；模块化让她应对大规模应用易如反掌。
用她搞个CMS（[wulacms](https://github.com/ninggf/wulacms)）、论坛、电商、RESTful API服务就是小菜一碟。

## 技术交流
欢迎加入 **wulaphp** 技术交流 QQ 群，分享 **wulaphp** 资源，交流 **wulaphp** 技术。

* QQ 群 I 371487281

> 如果有任何问题或建议请到[issues](https://github.com/ninggf/wulaphp/issues)提交。

## 鼓励项目
* 到[Github](https://github.com/ninggf/wulaphp)给我们一个star ^_^
* 将**wulaphp**介绍给你身边的朋友 ^_^
* 直接fork，然后提交你的`pull request`。