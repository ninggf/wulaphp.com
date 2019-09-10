---
title: 模块目录
showToc: 0
index: module bootstra
desc: 模块是wulaphp的代码组织方式
---

**wulaphp**通过模块来组织代码，可以将一个或多个业务单元的代码组织在一起形成一个模块。
模块必须拥有唯一的[命名空间](https://www.php.net/manual/zh/language.namespaces.php)且与**模块目录名**相同。模块里可以包括：

1. 控制器
2. 视图文件
3. 模型类
4. 其它类
5. 脚本
6. 资源文件
7. 业务相关的其它文件

> 通过合理的模块设计，可以很好的重用代码哦。

## 目录结构

一个模块就是`modules`目录下的一个目录，以`hello`做为模块**HelloWorld**的目录，其结构大致如下:

<img src="/doc/guide/img/mdir.jpg" width="239px" alt="module dir"/>。

### 重要说明

1. `bootstrap.php`是模块引导文件必须存在。
2. 所有控制器都要放在`controllers`目录中。
3. 视图文件放在`views`目录中。
4. `hello`是自定义的,也可以是其它的名称（**模块的目录名与命名空间必须相同**）。

<p class="tip" markdown=1>上述目录结构可以通过`php artisan admin create-module hello`创建。</p>

## 命名空间与类 {#ns}

wulaphp 对**模块命名空间**有着严格的约定:

1. 模块的**命名空间**只能由小写字母(`a-z`)组成且不能是**子命名空间**。
2. 在模块里定义的类（包括控制器类）的**命名空间**是基于其**目录层级**所形成**子命名空间**。
3. 在模块里定义的类（包括控制器类）的名字与文件名同名。
4. 符合命名空间约定的类都可以按需自动加载(autoload)。
5. 模块的命名空间不必与模块的目录相同。

> 以上表述可能真的很绕，但是真的、真的很重要，请多多思考并理解透彻。

## 控制器目录

控制器只能放在`controllers`目录里。

## 视图目录

视图只能放在`views`目录里。

## 类目录

默认是放在`classes`目录。除了`controllers`与`views`目录，大家可以便宜行事。

<p class="tip" markdown=1>推荐大家把模型类放到`model`目录中</p>

## Hooks

勾子类存放目录，此目录内的勾子类通过懒加载的方式在勾子事件触发时才被加载调用。

## 引导文件 {#bootstrap}

`bootstrap.php`是模块引导文件也是整个模块必不可少的一个文件，我们需要在这个文件中定义模块类并将其实例注册到`wulaphp`，内容大致如下:

```php
namespace hello;

use wulaphp\app\App;
use wulaphp\app\Module;

class HelloWorldModule extends Module {
    public function getName() {
        return 'HelloWorld';
    }

    public function getDescription() {
        return 'demo module for wulaphp document';
    }

    public function getHomePageURL() {
        return 'https://www.wulaphp.com/';
    }
}

App::register(new HelloWorldModule());
```

一个简单的模块引导文件就完成了，是不是很简单？

## 接下来

接下来去看一下**wulaphp**的[约定与规范](convention.md)，以便更好的理解它。
