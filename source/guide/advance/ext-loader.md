---
title: 扩展加载器
type: guide
order: 1101
---

## 默认加载器

wulaphp通过默认的[ExtensionLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/app/ExtensionLoader.php)扩展加载器加载扩展, 流程大致如下:

<pre>
    创建扩展加载器（由EXTENSION_LOADER_CLASS指定）
                &dArr;
        扫描扩展目录（包含二级目录）
                &dArr;
        加载引导文件(如果有)
                &dArr;
        注册扩展实例(如果有)
                &dArr;
           绑定勾子（如果有）
</pre>

### 扩展类自动加载

与[模块类自动加载](module-loader.html#模块类自动加载)不同，扩展提供的类由wulaphp使用默认的基于PSR-0的自动加载器加载。如类`hello\classes\AbcCls`:
<pre>
extensions
└─hello
   └─classes
      └─AbcCls.php
</pre>

则只需要在使用`AbcCls`的地方直接使用:

```php
$abc = new hello\classes\AbcCls();
```

扩展的类的加载交给wulaphp吧。

## 自定义扩展加载器

如果有对扩展进行管理的需要（安装，启用，禁用，卸载，升级等）可以自定义扩展加载器实现。根据wulaphp处理流程，自定义扩展加载器可以通过`composer`类库方式实现。自定义一个类继承[\wulaphp\app\ExtensionLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/app/ExtensionLoader.php)并重写:

1. `load` 加载扩展引导文件
2. `scanExtensions` 扫描扩展目录（至少扫描二级）

假设我们实现了一个自定义模块加载器:

```php
<?php
namespace wula\cms;

use wulaphp\app\ExtensionLoader;

class CmfExtLoader extends ExtensionLoader {
    ....
}
```

### 使用自定义加载器

修改`bootstrap.php`文件中`EXTENSION_LOADER_CLASS`为自定义扩展加载器的全类名即可:

```php
define('EXTENSION_LOADER_CLASS', 'wula\cms\CmfExtLoader');
```
