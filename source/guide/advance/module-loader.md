---
title: 模块加载器
type: guide
order: 1100
---

为什么控制器要包含在模块里？为什么模块要被加载？

1. 控制器包含在模块里可以更好的组织代码。
2. 控制器包含在模块里可以简单的重命名目录名来改变URL。
    * 这特性有个锤子用哦！`admin`模块的访问URL是`axfas3ea`是不是安全一点呢？
3. 加载模块是为了绑定勾子哦
4. 加载模块给了管理模块的机会，第三方可以做出牛逼的管理后台。

## 默认加载器

wulaphp通过默认的[ModuleLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/app/ModuleLoader.php)模块加载器加载模块, 流程大致如下:

<pre>
          初始化模块加载器（由MODULE_LOADER_CLASS指定）
                    &dArr;
                扫描模块目录
                    &dArr;
            加载引导文件(bootstrap.php)
                    &dArr;
                注册模块实例
                    &dArr;
              绑定勾子（自动绑定）
</pre>

## 模块类自动加载

默认的ModuleLoader通过`loadClass($cls)`实现了简单的[PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md)类加载器。
唯一不同的是: **命名空间是由模块类的命名空间决定而不是由类文件存放路径决定**。比如有个类`helloworld\forms\AbcForm`,它应定义在`helloworld`模块的forms/AbcForm.php中(假设`hello`是模块目录名):
<pre>
modules
 └─hello
    └─forms
        └─AbcForm.php
</pre>

> 强烈建议模块提供的类定义在`classes`目录中。

## 自定义加载器

如果有对模块进行管理的需要（安装，启用，禁用，卸载，升级等）可以自定义模块加载器。根据wulaphp处理流程，自定义模块加载器可以通过:

1. wulaphp的[扩展(P)](../mvc/plugin.html)实现
2. composer类库实现

不管哪种，只需要自定义一个类继承[\wulaphp\app\ModuleLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/app/ModuleLoader.php)并重写:

1. `load` 加载模块引导文件
2. `scanModules` 扫描模块目录
3. `loadClass($cls)` 加载模块的类, 强烈建议遵循[PSR-0](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md).
4. `isEnabled(Module $module)` 模块是否启用

假设我们实现了一个自定义模块加载器:

```php
<?php
namespace wula\cms;

use wulaphp\app\App;
use wulaphp\app\Module;
use wulaphp\app\ModuleLoader;

class CmfModuleLoader extends ModuleLoader {
    ....
}
```

### 启用自定义加载器

修改`bootstrap.php`文件中`MODULE_LOADER_CLASS`为自定义模块加载器的全类名即可:

```php
define('MODULE_LOADER_CLASS', 'wula\cms\CmfModuleLoader');
```

详细可以参考`wulacms`实现的[类加载器](https://github.com/ninggf/wulacms_extension_cms/blob/master/src/wula/cms/CmfModuleLoader.php).