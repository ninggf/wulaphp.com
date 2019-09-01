---
title: 从 Hello World 模块开始
showToc: 0
index: 1
desc: 用wulaphp写的第一个模块，尝尝鲜
---

在完成安装，了解目录结构与模块等概念后，让我们弄个**HelloWorld**模块跟世界打个招呼，开始`wulaphp`之旅吧。

{$toc}

## 预备式

先回顾一下模块相关知识:

1. 将一个或多个业务单元的代码组织在一起形成一个模块。
2. 模块必须拥有唯一的命名空间且与模块目录相同。
3. 模块必须有一个引导文件`bootstrap.php`。
4. 模块目录位于`modules`目录下。
5. 可以通过下边的代码生成模块初始目录结构:
   * `php artisan admin create-module`

## 创建模块

假设:

**我们将HelloWorld模块放在`hello`目录中**

我们可以通过如下命令创建HelloWorld模块:

`php artisan admin create-module --name HelloWorld hello`

命令很快完成，此时在`modules`目录里你将看到`hello`目录:

<img src="/doc/guide/img/hellodir.jpg" width="218px" alt="module dir"/>

命令自动为您创建了引导文件`bootstrap.php`，其内容如下:

```php
<?php
namespace hello;

use wulaphp\app\App;
use wulaphp\app\Module;

/**
 * HelloWorld
 *
 * @package hello
 */
class HelloModule extends Module {
    public function getName() {
        return 'HelloWorld';
    }

    public function getDescription() {
        return '描述';
    }

    public function getHomePageURL() {
        return '';
    }
}

App::register(new HelloModule()); # 注册模块实例
// end of bootstrap.php
```

它是一个标准引导文件，已经可以很好的工作，目前我们还不需要修改它。**引导文件非常重要，没有它模块就不能工作**。

<p class="tip">如果你不喜欢用使用命令创建模块，你可以手动建立目录和相关文件。</p>

### 控制器

控制器位于模块的子目录`controllers`中，控制器类名与控制器名文件名相同(**使用Windows系统的同学注意文件名大小写**)。
如果你是通过命令创建的模块，命令会帮你创建`IndexController`和对应的视图`index.tpl`，否则你需要手动创建它们:

```php
<?php
namespace hello\controllers; # 请注意这里的子命名空间！！

use wulaphp\mvc\controller\Controller;

/**
 * 默认控制器.
 */
class IndexController extends Controller {
   /**
    * 默认控制方法.
    *
    * @param string $name
    *
    * @return \wulaphp\mvc\view\View
    */
    public function index($name = 'World') {
        $data = ['name' => $name];
        return view($data);
    }
}
```

这个控制器相当简单:

* 首先，它继承`wulaphp\mvc\controller\Controller`说明自己是一个控制器.
* 接着，它创建一个`Index` Action并接收一个**GET**参数`name`:
  * `public function index($name = 'World')`
* 最后，使用`view`函数加载`Index` Action对应的默认视图文件:[views/index/index.tpl](#view)并返回视图实例。

### 视图 {#view}

视图模板文件位于模块的子目录`views`中，可以通过以`view`，`pview`，`xmlview`，`excel`等函数加载。
如果你是通过命令创建的模块，命令已经帮你创建好了视图模板文件`views/index/index.tpl`，否则你需要手动创建它:

```html
<html>
<head>
    <title>Gretting</title>
    <meta charset="UTF-8">
</head>
<body>
<h1>Hello {$name}!</h1>
</body>
</html>
```

简单到只显示从控制器传过来的变量，如果对Smarty模板不熟悉，请传送至[Smarty文档](https://www.smarty.net/docs/zh_CN/).

> 当`view`(`pview`)函数不指定模板仅传数据时，`wulaphp`将使用与控制器同名目录下与action同名的视图文件。

### 验证

我们有了模块，有了控制器，写了`Index` Action与视图，我们要怎么访问它呢？`wulaphp`使用所见即所得的URL路由机制。
`hello\IndexController::index`的URL就是`hello/index/index`, 根据约定`index`是默认的路径可以省略，
所以URL可以简化为`hello`,通过浏览器访问[试一下](/hello)吧。你看到了:

**Hello World!**

总感觉有点不对，是不是？参数name呢？`wulaphp`支持默认参数,`name`就是默认参数，它有默认值*World*, 提供参数*Bill*, 将URL变为[hello/Bill](/hello/Bill)即可，你将看到:

**Hello Bill!**

你也可以通过[hello?name=Bill](/hello?name=Bill)得到相同的结果。

### 另一个 Action

在`IndexController`类中添加add方法：

```php
public function add($i, $j) {
    return 'the result is: ' . ($i + $j);
}
```

访问[hello/add/1/2](/hello/add/1/2), 你看到**the result is: 3**了吗？

## 另一个控制器

`IndexControll`是默认控制器，总不能所有代码都在写在它里边。再创建一个控制器`MathController`:

```php
<?php
namespace hello\controllers;

use wulaphp\mvc\controller\Controller;
use wulaphp\mvc\view\XmlView;

class MathController extends Controller {
    //加
    public function add($i, $j) {
        return new XmlView(['result' => $i + $j], 'math');
    }
    //减
    public function sub($i, $j) {
        return ['result' => $i-$j];
    }
    //乘
    public function mul($i,$j){
        return view(['result'=>$i*$j]);
    }
}
```

浏览器访问[hello/math/add/1/2](/hello/math/add/1/2)结果如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<math>
    <result>3</result>
</math>
```

访问[hello/math/sub/3/1](/hello/math/sub/3/1)结果如下:

```json
{"result":2}
```

访问[hello/math/mul/3/1](/hello/math/mul/3/1)结果如下:

500页面提示您：

> 靠!! 模板文件"modules/hello/views/math/mul.tpl"不存在

因为没有提供视图。请尝试解决并得到正确的输出:**结果是: 3**

## URL路由简述

如你所见`wulaphp`的URL路由基本上是**所见即所得**的, 以`hello/math/sub/1/2`为例来讲解路由规则:
<pre>
hello/math/sub/1/2
 │     │    │  └─└────────── 参数（*）
 │     │    └─────────────── action/参数（*）
 │     └──────────────────── 控制器名/action（*）
 └────────────────────────── 模块目录
</pre>

> * 带*的表示可以没有。
> * 当控制器或Action是`index`时，可以省略。

此URL的路由分发顺序如下:

1. MathController的sub方法，接收二个参数: 1,2
2. MathController的index方法，接收三个参数:sub,1,2
3. IndexController的math方法，接受三个参数:sub,1,2
4. IndexController的index方法，接收四个参数:math,sub,1,2

如果经过上述4步分发都找不到控制器或者参数个数不对，则分发失败。
如果模块有子模块，则路由规则参见[子模块](module/submodule.md#url)相关的路由规则.

## 小技巧

将模块根目录`modules`设为源码目录,在创建类，接口，Trait时就不需要为它们**手动编写命名空间**了，设置方式如下:

1. **PhpStorm**
   1. 在项目工具窗口中右击`modules`目录
   2. 从弹出菜单的底部选择“Mark Directory as”
   3. 选择“Sources Root”
2. **Zend Studio**
   1. 默认项目一级目录都是源码目录

> 强烈推荐你使用[PhpStorm](https://www.jetbrains.com/phpstorm/)开发PHP项目。
