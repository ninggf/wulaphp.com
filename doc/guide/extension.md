---
title: 扩展
showToc: 0
index: 1
desc: 扩展 - 将通用功能进行高度内聚形成类库供wulaphp模块调用
---

{$toc}

## 使用时机

将通用功能进行高度内聚形成类库供wulaphp模块调用。

1. 无须提供URL供外部访问。
2. 需要配置加载完成后才能正常运行(配置加载完成后才会加载扩展)。
3. 需要[懒加载](plugin.md#lazy)处理以扩展第三方模块功能。

## 实现扩展

wulaphp的扩展存放在`extensions`目录(可通过修改`EXTENSION_DIR`改变目录名),默认的扩展加载器加载此目录下**与目录名同名的PHP文件(扩展引导文件)**。我们可以在此文件中定义扩展类并将其注册到wulaphp框架中。

### 扩展类

每一个扩展可以有一个扩展类也可以没有扩展类，这一点与[模块](module/index.md)不同。扩展类定义在**与目录同名的PHP文件(引导文件)中**，**目录名即为扩展类的命名空间**（两者必须相同，此处与模块也不一样）。如下面的目录结构:
<pre>
extensions
└─hello
    └─hello.php
</pre>

在hello.php文件中定义扩展类`hello\HelloExtension`:

```php
<?php
namespace hello;

use wulaphp\app\App;
use wulaphp\app\Extension;

class HelloExtension extends Extension {
    public function getName() {
        return 'Hello Ext';
    }
}

App::registerExtension(new HelloExtension());
```

通过`App::registerExtension(new HelloExtension())`将扩展注册到系统。

<p class="tip">引导文件可省略.</p>

### 勾子绑定

只需在扩展类中重写`Extension::bind`方法，在其中实现勾子绑定,如下:

```php
class HelloExtension extends Extension{
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

## 公共扩展

如果你有一颗开源的心，可以将你写的牛逼的扩展作为composer包发布分享给其他人,只需要简单地添加一个composer.json并发布到composer即可，示例如下:

```json
{
  "name": "mymodule/mymodule",
  "type": "wula-extension",
  "require": {
    "wula/wula-installer": "^2.0"
  }
}
```

1. `type`必须为`wula-extension`，这样它才能被正确安装到扩展目录。
2. 必须依赖`wula/wula-installer`，不然composer不知道如何安装它。
3. 其它依赖请根据实际情况添加.
4. 其它各项composer配置请根据实现情况添加.

更多composer知识请传送至[Composer](https://getcomposer.org/).

## 类自动加载

`wulaphp`会自动按[PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md)规则自动加载extensions目录中类。

## 扩展加载器

如果你需要自定义扩展加载器以实现更牛逼的扩展管理功能,请传送至[扩展加载器](advance/ext-loader.md).
