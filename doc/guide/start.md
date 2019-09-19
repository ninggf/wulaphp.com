---
title: 从 Hello World 模块开始
showToc: 0
index: 1
desc: 用wulaphp写的第一个模块，尝尝鲜
---

让我们弄个**HelloWorld**模块跟世界打个招呼，开始**wulaphp**之旅吧。

{$toc}

## 创建模块 {#create}

执行下边的命令:

`php artisan admin create-module --name "HelloWorld hello"`

命令很快完成，此时在`modules`目录里你将看到`hello`目录:

<img src="/doc/guide/img/hellodir.jpg" width="300px" alt="module dir"/>

<small style="margin:0 130px 0">图1</small>

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

<p class="tip" markdown=1>如果你不喜欢或不能使用命令创建模块，你可以手动在`modules`目录中建立**图1**所示的目录和`bootstrap.php`文件并把上边的代码复制其中。</p>

### 控制器 {#controller}

控制器位于模块的子目录`controllers`中，控制器类的类名与控制器名文件名必须相同(**使用Windows的同学请注意文件名大小写**)。
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
* 接着，它创建一个`index` Action并接收一个**GET**参数`name`:
  * `public function index($name = 'World')`
* 最后，使用`view`函数加载`index` Action对应的默认视图文件:[views/index/index.tpl](#view)并返回视图实例。

### 视图 {#view}

视图模板文件位于模块的子目录`views`中，可以通过以`view`，`pview`，`xmlview`，`excel`等函数加载不同引擎的视图文件。
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

它是一个**Smarty**模板文件，简单到只显示从控制器传过来的变量。如果你对`Smarty`模板不熟悉，请传送至[Smarty文档](https://www.smarty.net/docs/zh_CN/).

> 当`view`(`pview`)函数不指定模板文件仅传数据时，**wulaphp**将使用`views`(视图)目录里与控制器同名目录下与action同名的视图文件。

### 验证 {#run}

我们有了模块，有了控制器，写了`index` Action与视图，我们要怎么访问它呢？

首先，开启PHP的内建开发服务器(<small>如已开启请跳过</small>):

**Windows:** `php -S 127.0.0.1:8090 -t wwwroot\ wwwroot\index.php`

**类Unix:** `php -S 127.0.0.1:8090 -t wwwroot/ wwwroot/index.php`

然后，通过浏览器访问[http://127.0.0.1:8090/hello](http://127.0.0.1:8090/hello)。你将看到:

<div class="demo-wrapper"> <div class="demo">
<h1>Hello World!</h1>
</div></div>

总感觉有点不对，是不是？参数name呢？**wulaphp**支持默认参数,`name`就是默认参数，它有默认值*World*,
提供参数*Bill*, 将URL变为[http://127.0.0.1:8090/hello/Bill](http://127.0.0.1:8090/hello/Bill)即可，你将看到:

<div class="demo-wrapper"> <div class="demo">
<h1>Hello  Bill!</h1>
</div></div>

你也可以通过[http://127.0.0.1:8090/hello?name=Bill](http://127.0.0.1:8090/hello?name=Bill)得到相同的结果。

> 重要说明:
>
> 1. **wulaphp**使用所见即所得的URL路由机制。
> 2. `hello\controllers\IndexController::index`的对应的URL是`hello/index/index`, 根据约定`index`是默认的路径可以省略，所以URL可以简化为`hello`。

### 另一个 Action {#otherm}

在`IndexController`类中添加add方法：

```php
public function add($i, $j) {
    return 'the result is: ' . ($i + $j);
}
```

访问[http://127.0.0.1:8090/hello/add/1/2](http://127.0.0.1:8090/hello/add/1/2),
你看到**the result is: 3**了吗？

## 另一个控制器 {#otherC}

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

浏览器访问[http://127.0.0.1:8090/hello/math/add/1/2](http://127.0.0.1:8090/hello/math/add/1/2)结果如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<math>
    <result>3</result>
</math>
```

访问[http://127.0.0.1:8090/hello/math/sub/3/1](http://127.0.0.1:8090/hello/math/sub/3/1)结果如下:

```json
{"result":2}
```

访问[http://127.0.0.1:8090/hello/math/mul/3/1](http://127.0.0.1:8090/hello/math/mul/3/1)结果如下:

500页面提示您：

> 靠!! 模板文件"modules/hello/views/math/mul.tpl"不存在

因为没有提供视图。请尝试解决并得到正确的输出:**结果是: 3**

## URL路由简述 {#url}

如你所见**wulaphp**的URL路由基本上是**所见即所得**的, 以`hello/math/sub/1/2`为例来讲解路由规则:
<pre>
hello/math/sub/1/2
 │     │    │  └─└────────── 参数（*）
 │     │    └─────────────── action 或者 参数（*）
 │     └──────────────────── 控制器名 或 action（*）
 └────────────────────────── 模块
</pre>

> * 带*的表示可以没有。
> * 当控制器或Action是`index`时，可以省略。

此URL的路由分发顺序如下:

1. MathController的sub方法，接收二个参数: 1,2
2. MathController的index方法，接收三个参数:sub,1,2
3. IndexController的math方法，接受三个参数:sub,1,2
4. IndexController的index方法，接收四个参数:math,sub,1,2

如果经过上述4步分发都找不到控制器或者参数个数不匹配，则分发失败，此时路由器将请求分发给其它分发器处理，详见[高级路由](advance/dispacther.md)。

## 小技巧 {#tips}

将`modules`目录设为源码目录，在创建类，接口，Trait时就不需要为它们**手动编写命名空间**了，设置方式如下:

1. **PhpStorm**
   1. 在项目工具窗口中右击`modules`目录
   2. 从弹出菜单的底部选择“Mark Directory as”
   3. 选择“Sources Root”
2. **Zend Studio**
   1. 默认项目一级目录都是源码目录

> 强烈推荐你使用<a href="https://www.jetbrains.com/phpstorm/" target="_blank">PhpStorm</a>。

## 接下来 {#next}

让我们为`HelloWorld`模块添加一些[配置](cfg.md)并读取它们。
