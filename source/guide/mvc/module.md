---
title: 模块(M)
type: guide
order: 22
---

`wulaphp`通过模块来组织代码，将实现一组相关业务功能的所有资源、代码封装在一起方便管理。模块资源、代码存放在`modules`目录(可通过MODULES_DIR常量修改)下。一个模块的典型目录结构如下:

<pre>
    helloword
    ├─assets                  #静态资源目录
    ├─classes                 #类目录
    │  ├─ClassOne.php         #ClassOne类
    │  └─OtherClass.php       #OtherClass
    ├─controllers             #控制器目录
    │  ├─IndexController.php  #默认控制器
    │  └─OtherController.php  #别的控制器
    ├─views                   #视图目录
    │  ├─index                #IndexController的视图目录
    │  │  ├─index.tpl         #默认视图文件(Smarty)
    │  │  └─abc.php           #abc方法视图文件(php)
    │  └─other                #OtherController的视图目录
    │     ├─index.tpl         #默认视图文件
    │     └─def.php           #def方法视图文件
    └─bootstrap.php           #引导文件
</pre>

<p class="tip">
可以通过`php artisan admin create-module yourModule`创建一个典型的模块目录结构.
</p>

## 定义

`bootstrap.php`是模块的引导文件，我们在此文件中定义模块类.

每个模块都必须有一个唯一的**命名空间**。模块的命名空间由模块类的命名空间决定，与模块的目录名无关（可以相同），同样与模块类的类名也没关系，如:

<pre>
modules
└─abc
   └─bootstrap.php
</pre>

在`bootstrap.php`中定义`wulaphp\app\Module`的子类`def\GhiModule`:

```php
<?php
namespace def;

use wulaphp\app\Module;

class GhiModule extends Module{
    public function getName() {
        return 'Hello World';
    }

    public function getDescription() {
        return '模块描述';
    }

    public function getHomePageURL() {
        return '模块的主页';
    }
    // 版本声明
    public function getVersionList() {
        $v ['1.0.0'] = '第一个版本';
        return $v;
    }
}
```

说明如下:

1. 模块的目录: abc, 决定访问模块的URL。
2. 模块的命名空间: def，模块里的代码的命名空间都是他的子命名空间。
    * 模块类只支持一级命名空间,像`def\abc`这样的二级是不支持的。
3. 模块名称: Hello World，沟通交流、模块管理功能显示用
4. 模块类名: GhiModule, 模块管理功能使用
5. 模块版本列表: 供模块管理使用

看上去他们之间没有半毛钱关系(**强烈建议现实中不要这么干**), 推荐下边的写法:

```php
namespace abc;

use wulaphp\app\Module;

class AbcModule extends Module{
    // ...
    // 类的代码
    // ...
}
```

在开发阶段保持**模块目录名**与**命名空间**相同会方便很多.

## 注册模块

有了模块类之后就可以把它注册到wulaphp框架中了. 在模块类定义下方添加代码:

```php
App::register(new AbcModule());
```

<p class="tip">
为什么要注册?为什么?因为通过注册,wulaphp才能:

1. 实现勾子绑定
2. 实现模块的类自动加载
3. 实现模块管理功能

</p>

## 勾子绑定

只需在模块类中重写`Module::bind`方法，在其中实现勾子绑定,如下:

```php
class AbcModule extends Module{
    // ...
    // 类的其它代码
    // ...

    /*
     * 勾子实现
     */
    public function impl1($value) {
        return $value;
    }
    /**
    * 批量事件处理器注册.
    */
    protected function bind() {
        bind('impl1', [$this, 'impl1']);
        // 更多的绑定
    }
}
```

### 自动绑定

通过wulaphp提供的**注解功能**可以很方便地实现勾子自动绑定:

1. 通过`@bind`绑定通知/事件型勾子；
2. 通过`@filter`绑定修改型勾子;

这两个注解只能作用于模块类的公众静态方法上。通过它们实现自动绑定可以自动检测参数个数。更多绑定相关内容可以查看[插件(P)](plugin.html)。

1. 通知/事件型: `@bind 勾子[ 优先级]`
    ```php
    class AbcModule extends Module{
        // ...
        // 类的其它代码
        // ...

        /**
        * 自动绑定通知/事件型勾子示例.
        *
        * @bind wula\stop 1
        */
        public static function onWulaStop() {
            // wula停止时做一个操作的代码
        }
    }
    ```
2. 修改型：`@filter 勾子[ 优先级]`
    ```php
    class AbcModule extends Module{
        // ...
        // 类的其它代码
        // ...

        /**
        * 自动修改型勾子示例.
        *
        * @filter impl1 1
        */
        public static function impl11($value) {
            return $value+1;
        }
    }
    ```
> 如不指定`优先级`,则使用默认优先级:10

## 公共模块

如果你有一颗开源的心，可以将你写的牛逼的模块作为composer包发布分享给其他人,只需要简单地添加一个composer.json并提交到composer库即可，示例如下:

```json
{
  "name": "mymodule/mymodule",
  "type": "wula-module",
  "require": {
    "wula/wula-installer": "^2.0"
  }
}
```

1. `type`必须为`wula-module`，这样它才能被正确安装到模块目录。
2. 必须依赖`wula/wula-installer`，不然composer不知道如何安装它。
3. 其它依赖请根据实际情况添加.
4. 其它各项composer配置请根据实现情况添加.

更多composer知识请传送至[Composer](https://getcomposer.org/).

## 类自动加载

模块的其它类(class)的文件匀应存放到`classes`目录中以便按需自动加载(懒加载)，此功能由类加载器提供.

## 静态资源

请将模块用到的所有静态资源(图片,JS,CSS等)放入`assets`目录并将其软链接到`wwwroot/assets/`目录下.

<p class="tip">
通过composer安装的模块,`wula-installer`会自动执行软链接操作.
</p>

## 控制器

详见[控制器](controller.html).

## 视图

详见[视图](view.html).

## 子模块

详见[子模块](../advance/submodule.html).

## 模块加载器

如果你需要自定义模块加载器以实现更牛逼的模块管理功能,请传送至[模块加载器](../advance/module-loader.html).