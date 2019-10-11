---
title: 模块
showToc: 1
desc: 模块化，让代码重用成为可能。
---

## 概述 {#overview}

**wulaphp**使用模块组织代码，将相关的业务放在一个模块里实现，以实现代码的最大化重用。数据库模型(M)、视图(V)、控制器(C)等都要包含在模块里。简单来说，一个模块就是`modules`目录下的一个目录,其典型目录结构如下图:

<img src="/doc/guide/img/mdir.jpg" width="239px" alt="module dir"/>

## 创建模块 {#create}

以模块**Hello World**(目录为`hello`)为例，可以通过以下两种方式创建模块，

### 手动创建 {#manual}

1. 在`modules`目录创建模块目录`hello`。
2. 创建引导文件`bootstrap.php`，其内容见[引导文件](#bootstrap)。
3. 添加控制器目录`controllers`。
4. 添加视图目录`views`。
5. 添加其它文件。

### 命令方式 {#artisan}

打开命令行并执行:

`php artisan create module --name "Hello World" hello`

命令将为你创建:

1. 引导文件`bootstrap.php`，其内容见[引导文件](#bootstrap)。
2. 控制器目录`controllers`和一个默认控制器`IndexController`
3. 视图目录`views`和默认控制器对应的视图文件`index.tpl`
4. 类目录`classes`
5. 测试目录`tests`和测试配置文件`phpunit.xml`

## 引导文件与模块类 {#bootstrap}

`bootstrap.php`是模块的导引文件，此文件是模块成为模块必不可少的一个文件。在该文件中定义代表模块的模块类并将其实例注册到框架以便[模块加载器]加载。模块类是[Module](../../api/app/Module.md)类的子类，其命名空间必须与模块目录相同。以上文中的**Hello World**模块为倒，其引导文件如下:

```php
namespace hello; # 模块类的命名空间必须与模块目录相同

use wulaphp\app\App;
use wulaphp\app\Module;

class HelloWorldModule extends Module {
    public function getName() {
        return 'Hello World';
    }
}

App::register(new HelloWorldModule()); # 注册模块
```

## 命名空间与自动加载 {#ns}

框架对模块命名空间有着严格的规定:

1. 模块类(<small markdown=1>在引导文件`bootstrap.php`中定义</small>)的**命名空间**必须与模块**目录名**相同。
2. 在模块里实现的类（包括控制器类）的**命名空间**是基于其**目录层级**所形成**子命名空间**。
3. 在模块里实现的类（包括控制器类）的类名与文件名同名(注意大小写)。

符合上述命名空间约定的类都可以按需自动加载(autoload)。

## 控制器 {#controller}

控制器是`controllers`目录里继承自[Controller](../../api/mvc/controller/Controller.md)类的类，其类名可以用`Controller`作为后缀。`IndexController`或`Index`是默认控制器。控制器的`index`方法是默认页面（动作）。更多关于控制器的内容详见[控制器](../mvc/controller.md)。

## 视图 {#view}

框架内建以下视图引擎:

1. Smarty: 通过`view`函数加载
2. PHP: 通过`pview`函数加载
3. XML: 通过`xmlview`函数加载
4. Excel: 通过`excel`函数加载
5. JSON: 控制器直接返回`array`即可
6. CSV: 创建`CsvView`实例方式加载

其中`Smarty`,`PHP`,`Excel`需要编写模板文件，详见[视图](../mvc/view.md)。

## 勾子(事件) {#hook}

将处理相应勾子(事件)的处理器类放在`hooks`目录中，当事件发生时框架会自动加载处理器类并执行相应的方法。详见[插件](../plugin.md)

## 模型类 {#model}

建议此类型的类放到`model`目录里，详见[模型](../db/model.md)。

## 测试类 {#test}

在进行单元测试之前需要通过composer安装`phpunit`:

`composer require --dev phpunit/phpunit:^7.5`

然后把所有测试用例类放到`tests`目录，通过以下命令运行测试：

**类Unix** `vendor/bin/phpunit --prepend bootstrap.php -c modules/hello/phpunit.xml.dist`

**Windows** `vendor\bin\phpunit --prepend bootstrap.php -c modules\hello\phpunit.xml.dist`

> 如果使用**3.0**之前版本的**wulaphp**则不需要添加`--prepend`参数。

## 其它类 {#others}

除`model`、`controllers`、`views`、`hooks`、`scripts`、`tests`目录外随便放，只要遵守命名空间的规定都可以被自动加载。

## 脚本文件 {#script}

推荐放在`scripts`目录里，使用`php artisan`运行，如:

**类Unix** `php artisan hello/scripts/greeting.php`

**Windows** `php artisan hello\scripts\greeting.php`

这样的好处是：脚本不需要引用框架的引导文件，由`artisan`帮你引用。

## 默认模块 {#default}

wulaphp支持默认模块(默认的默认模块是`app`)，何谓默认模块？就是URL中未指定模块目录时还可以访问的模块。要设置默认模块，只需要在`bootstrap.php`文件中定义常量`DEFAULT_MODULE`:

```php
/* 配置系统的默认模块配置,请取消下一行的注释，将其值改为模块命名空间 */
define('DEFAULT_MODULE', 'abc');
```

原URL `abc/add/user`在将`abc`设置默认模块后就可以通过`add/user`访问啦(前提是没有`add`模块哦)。
更多URL路由信息请查看[高级路由](../advance/route.md)。

> 默认模块的功能应尽量简单！

## 模块别名 {#alias}

在默认配置文件`conf/config.php`中可以为模块定义别名，当模块定义了别名以后，访问模块的URL中模块目录将变为相应的别名,如:

```php
[
    ...,
    'alias' => [
        'mymodule' => 'hello'
    ]
    ...
]
```

此时URL中模块目录`hello`对应的部分都将换为`mymodule`。为了适应这种变化，URL的生成请使用`App::url`或`App::action`(Smarty模板中使用`app`和`action`[修饰器](../theme.md#modifiers)),详见控制器[URL生成](../mvc/controller.md#url)。

## 子模块 {#submodule}

详见[子模块](submodule.md)

## 公共模块 {#open}

如果你有一颗开源的心，可以将你写的牛逼的模块作为`Composer`包发布分享给其他人,只需要简单地添加一个composer.json并提交到[Composer库](http://packagist.org/)即可，示例如下:

```json
{
  "name": "mymodule/mymodule",
  "type": "wula-module",
  "require": {
    "wula/wula-installer": "^2.0"
  }
}
```

1. `type`必须为`wula-module`，这样它才能被正确安装到模块目录。
2. 必须依赖`wula/wula-installer`，不然composer不知道如何安装它。
3. 其它依赖请根据实际情况添加.
4. 其它各项composer配置请根据实现情况添加.

## 模块加载器 {#loader}

模块加载器将注册到框架的模块实例按需加载引导使之可用，默认的模块加载器加载所有注册到框架的模块。如果有需要，可以通过[自定义模块加载器](../advance/loader.md)实现特殊的模块加载机制。

[模块加载器]: #loader
