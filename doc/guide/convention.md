---
title: 约定规范
showToc: 0
index: 1
keywords: wulaphp 约定 编码规范 路由约定 命名规范
desc: wulaphp的约定与规范
---

本文档通过以下主题指引你写出符合**wulaphp**规范的代码。

{$toc}

## 模块与扩展 {#me}

**wulaphp**以**模块、扩展**为最小单元组织代码,以便代码重用.每个**模块、扩展**都有其唯一的[命名空间](http://php.net/manual/zh/language.namespaces.php)。
顶级命名空间与**模块、扩展**目录相同。

> **顶级命名空间** 约定由 _小写字母_ 组成.

## URL路由约定 {#url}

**wulaphp**支持**所见即所得**URL路由规则,通过URL可直接对应到具体的控制器,如`user`模块的`MyController`的`view`方法:

```php
<?php
namespace user\controllers;
use wulaphp\mvc\controller\Controller;

class MyController extends Controller{
    public function view(){
        // ....
    }
}
```

其对应的URL为 `user/my/view`.

## 类名与懒加载 {#lz}

类名遵循**大写驼峰**命名规则,如:`MyController`、`UserModel`。
**wulaphp**使用懒加载机制在需要的时候才加载类以提升程序性能，所以要求**类名与文件名**相同且存放在与命名空间相对应的目录中,如:

```php
<?php
namespace user\classes;
use wulaphp\db\Table;

class UserModel extends Table{
    //....
}
```

则其:

1. 文件名应为`UserModel.php`.
2. 文件应存放于`modules/user/classes`目录中.

## 变量名 {#var}

变量名,不严格要求.但不推荐**大写驼峰**命名规则。

## 函数名 {#func}

函数名推荐使用**小写驼峰**命名规则,如:`addUser`,`deleteUser`。

> 控制器里的动作函数命名不推荐**驼峰**命名规则.

## 控制器类名 {#controller}

控制器类的类名以`Controller`结尾且与文件名相同，如:`UserController`。

> 控制器类名可以不以`Controller`结尾，如:`User`。

## 模型类名 {#model}

数据模型类推荐以`Model`、`View`、`Table`结尾。如:`UserModel`,`UserView`,`StudentTable`.

> 不以`Model`、`View`、`Table`结尾也是可以的。

## 模型主键 {#pk}

默认模型主键字段为`id`且自增.

## 配置约定 {#conf}

**wulaphp**的所有配置文件位于`conf`目录中,其中:

1. 普通配置文件以`_config[_mode].php`结尾
   * `config.php`为默认配置文件
2. 数据库配置文件以`_dbconfig[_mode].php`结尾
   * `dbconfig.php`为默认数据库配置文件

> `_mode`为运行模式. 模式对应的配置文件将覆盖基础配置文件,如:`my_config_test.php`将覆盖`my_config.php`中的配置.

## 接下来 {#next}

进入深水区，去看下**wulaphp**是[如何工作](how.md)哒。
