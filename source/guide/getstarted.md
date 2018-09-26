---
title: 第一个模块
type: guide
catalog: 入门
order: 10
---

## 预备式

让我们弄个`helloworld`模块跟世界打个招呼: *hello world!*

开始之前我们要知道`wulaphp`:

1. 通过模块来组织代码(模块是不可分隔的最小功能单元)
2. 每个模块都有自己独立的命名空间。
3. 模块代码位于`modules`目录。
4. 模块的典型目录结构如下:
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

> 小提示:
>
> 可以通过`php artisan admin create-module helloworld`快速创建模块.

## 创建模块

在`modules`目录中新建目录`helloworld`，在`helloworld`目录中创建**模块引导文件**`bootstrap.php`, 其内容如下:

```php
<?php
namespace helloworld;

use wulaphp\app\App;
use wulaphp\app\Module;

class HelloworldModule extends Module {
    public function getName() {
        return 'Hello World';
    }

    public function getDescription() {
        return '我的第一个模块，它的名字叫Hello World';
    }

    public function getHomePageURL() {
        return '';
    }
}

App::register(new HelloworldModule());
```

我们在`bootstrap.php`文件中定义了一个`HelloworldModule`类(它是`wulaphp\app\Module`的子类),同时把它的实例通过`App::register`注册到`App`，让`wulaphp`知道有这么个模块。

<p class="tip">
请特别注意`namespace helloworld;`(每个模块都有自己独立的命名空间):

1. 它定义了**helloworld**模块的命名空间为`helloworld`(模块目录与命名空间可以不同)。
2. 它决定了**helloworld**模块的类、控制器的命名空间必须是`helloworld`的子命名空间。

</p>

### 创建控制器

创建文件`controllers/IndexController.php`并在其中实现`wulaphp\mvc\controller\Controller`的子类
`helloworld\controllers\IndexController`(所有的控制器都必须以`Controller`结尾，这是wulaphp的约定),内容如下:

```php
<?php

namespace helloworld\controllers;

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

控制器类名与文件名同名，所有控制器类都是`wulaphp\mvc\controller\Controller`类的子类，命名空间为`helloworld/controllers`.
这个控制器相当简单，接收一个GET参数`name`，并将它传到视图. 此外使用默认的视图文件:`views/index/index.tpl`,
这是约定(当view函数不指定模板时，wulaphp将使用与控制器同名目录下与action同名的视图文件,由此可见:

1. 控制器名为`index`
2. action为`index`

### 创建视图文件

创建文件`views/index/index.tpl`(Smarty模板),内容如下:

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

### Say Hello

我们有了模块，有了控制器，写了Action与视图，我们要怎么访问它呢？wulaphp使用所见即所得的URL路由机制。
`hellowlrd\IndexController::index`的URL就是: `helloworld/index/index`, 根据约定`index`是默认的路径可以省略，
所以URL可以简化为`helloworld`,试一下吧。你看到了*Hello World!*

总感觉有点不对，是不是？参数name呢？wulaphp支持默认参数, `name`就是默认参数，它有默认值*World*, 提供参数`Bill`, 将URL变为`helloworld/Bill`，
你将看到*Hello Bill!*

### 来点不一样的

在`IndexController`类中添加add方法：

```php
public function add($i, $j) {
    return 'the result is: ' . ($i + $j);
}
```

访问`helloworld/add/1/2`, 你看到**the result is: 3**了吗？

### 另一个控制器

`IndexControll`是默认控制器，总不能所有代码都在写在它里边。再创建一个控制器`MathController`:

```php
<?php

namespace helloworld\controllers;

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

访问`helloworld/math/add/1/2`结果如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<math>
    <result>3</result>
</math>
```

访问`helloworld/math/sub/3/1`结果如下:

```json
{
    "result":2
}
```

访问`helloworld/math/mul/3/1`结果如下:

500页面提示您：

> modules/helloworld/views/math/mul.tpl is not found

因为没有提供视图。请尝试解决并得到正确的输出:**结果是: 3**

### 更进一步

让我们再创建一个控制器`AddController`:

```php
<?php

namespace helloworld\controllers;

use wulaphp\mvc\controller\Controller;

class AddController extends Controller {
    public function index($i, $j) {
        return ['result' => $i + $j];
    }
}
```

访问`helloworld/add/1/2`, 你看到的是**the result is: 3**还是

```json
{
    "result":3
}
```

> 请思考两分钟, 这是为什么???

## 给模块目录改个名

wulaphp中**模块目录名**不必与**模块的命名空间**一致。所以把`helloworld`目录名改为`hello`(**注意命名空间不要改**)然后把上边的URL中的`helloworld`替换成`hello`再访问一遍吧，会有惊喜的哦~

> 爽完之后请把目录名`hello`改回`helloworld`,后边的文档都是基于`helloworld`写的.

## URL路由简述

如你所见wulaphp的URL路由基本上是**所见即所得**的, 以`helloworld/math/sub/1/2`为例来讲解路由规则:
<pre>
helloworld/math/sub/1/2
 │          │    │  └─└────────── 参数（*）
 │          │    └─────────────── action/参数（*）
 │          └──────────────────── 控制器名/action（*）
 └─────────────────────────────── 模块目录
</pre>

> 带*的表示可以没有

此URL的路由分发顺序如下:

1. MathController的sub方法，接收二个参数: 1,2
2. MathController的index方法，接收三个参数:sub,1,2
3. IndexController的math方法，接受三个参数:sub,1,2
4. IndexController的index方法，接收四个参数:math,sub,1,2

如果经过上述4步分发都找不到控制器或者参数个数不对，则分发失败。如果模块有子模块，则路由规则参见[子模块](./advance/submodule.html).

## 接下来

模块很简单，读取配置也简单，让我们为`helloworld`添加一些[配置](config.html)并读取它们。