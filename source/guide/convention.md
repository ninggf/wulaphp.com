---
title: 约定规范
type: guide
order: 4
---

## 模块、扩展

wulaphp以模块、扩展为最小单元组织代码,以便代码重用.每个模块、扩展都有其唯一的[命名空间](http://php.net/manual/zh/language.namespaces.php)。
顶级命名空间与模块、扩展目录一般情况下相同（为了安全，可以不相同）。

> **顶级命名空间约定由小写字母组成.**

## URL路由约定

wulaphp支持所见即所得URL路由规则,通过URL可直接对应到具体的控制器,如`user`模块的`MyController`的`view`方法:

```php
<?php
namespace user\controllers;

class MyController extends Controller{
    public function view(){
        // ....
    }
}
```

其对应的URL为 `user/my/view`.

## 类名与懒加载

类名遵循**大写驼峰**命名规则,如:`MyController`、`UserModel`。
wulaphp使用懒加载机制(`spl_autoload_register`)在需要的时候才加载类以提升程序性能，所以请保证**类名与文件名**相同且存放在与命名空间相对应的目录中,如:

```php
namespace user\classes;

class UserModel extends Model{
    //....
}
```

则其:

1. 文件名应为`UserModel.php`.
2. 文件应存放于`modules/user/classes`目录中.

## 变量名

变量名,不严格要求.但不推荐**大写驼峰**命名规则。

## 函数名

函数名推荐使用**小写驼峰**命名规则,如:`addUser`,`deleteUser`。

> 控制器里的动作函数命名不推荐**驼峰**命名规则.

## 配置约定

wulaphp的所有配置文件位于`conf`目录中,其中:

1. 普通配置文件以`_config[_mode].php`结尾
   * `config.php`为默认配置文件
2. 数据库配置文件以`_dbconfig[_mode].php`结尾
   * `dbconfig.php`为默认数据库配置文件

> `_mode`为运行模式. 模式配置文件将覆盖配置文件,如:`my_config_test.php`将覆盖`my_config.php`中的配置.
