---
title: 控制器(C)
type: guide
order: 24
---

MVC中的C -- 控制器，小名叫`Controller`。可能与其它框架的控制器不太相同:

1. wulaphp的控制器要属于一个模块。
2. 它的**命名空间**只能是模块的命名空间的子命名空间（详见[模块(M)](module.html)）。
3. 控制器类文件要存放在模块(或子模块)的`controllers`目录里。
4. wulaphp的控制器可按需加载需要的特性。

## 定义控制器

上代码:

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

所有控制器都是[Controller](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/controller/Controller.php)类的子类。`wulaphp`对控制器有以下两个约定:

1. `IndexController` 为模块的默认控制器。
2. `index` 方法为控制器的默认方法(Action)。

默认控制器与默认方法将影响URL路由，具体请传送至[URL路由简述](../getstarted.html#URL路由简述)文档。

## 方法(Action)

真正干活的是控制器的方法(Action),如上例中的`index`。每个方法都要返回一个[视图](view.html)实例做为对用户请求的响应。
如果方法没有返回值或者返回`null`,那么当前请求将交由其它分发器处理。创建视图实例有以下几种方法:

1. 使用`view`方法加载[SmartyView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/SmartyView.php)实例(详见[视图(View)](#视图))。
    ```php
    return view(...);
    ```
2. 使用`pview`方法加载php模板文件
    ```php
    return view(...);
    ```
3. 使用`template`方法加载[ThemeView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/ThemeView.php)实例(详见[主题](theme.html))。
    ```php
    return template(...);
    ```
4. 直接返回字符或创建[SimpleView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/SimpleView.php)实例以响应普通文本(响应头为:`Content-type: text/plain; charset=utf-8`).
    ```php
    return 'Hello World!';
    //等同于下边代码
    return new SimpleView('Hello World!');
    ```
5. 直接返回数组或创建[JsonView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/JsonView.php)实例以响应JSON数据(响应头为:`Content-type: application/json`)。
    ```php
    return ['code'=>0,'message'=>'ok'];
    //等同于下边代码
    return new JsonView(['code'=>0,'message'=>'ok']);
    ```
6. 创建[XmlView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/XmlView.php)实例以响应XML文档(响应头为:`Content-type: text/xml; charset=utf-8`).
    ```php
    return new XmlView(...);
    ```

当然你可以在方法里直接使用`die`、`exit`干死当前请求或者使用`Response::redirect`或`App::redirect`跳转到其它页面。

### 方法进阶

想像一下你正在开发用户登录功能，你搞了一个控制器`AuthController`，用它的`login`方法(相应的URL为`auth/login`)显示登录界面:

```php
class AuthController extends Controller{
    public function login(){
        return view();
    }
}
```

那么用户登录数据（用户名，密码啥的）要提交到哪个方法呢?`doLogin`?提交到`doLogin`这个方法是没问题的，但是wulaphp允许你使用`POST`方式将数据提交到`auth/login`这个URL，而要做的只是简单的定义一个`loginPost`方法:

```php
class AuthController extends Controller{
    //显示登录界面
    public function login(){
        return view();
    }
    //登录处理
    public function loginPost(){
        ....
    }
}
```

搞定，就这么简单。

[HTTP请求方式](https://www.w3schools.com/tags/ref_httpmethods.asp)常用的有以下几种:

1. GET
2. POST
3. PUT
4. DELETE
5. HEAD

讲真，知道PUT和DELETE的请举手，不能分清GET和POST请抓紧时间自学一波。

## URL映射

无论是控制器还是方法，如果他们使用了驼峰方式命名，如:`MyInfoController`、`doLogin`, 请记住在URL中用`-`连接驼峰:

1. `my-info`
2. `do-login`

## 视图

视图文件存放在`views`目录中!

如果你的方法通过`view`或`pviews`来加载`views`目录下的Smarty模板或PHP模板做为视图，那么请您记住以下三点约定:

1. `view/pview`方法加载的视图默认响应为`Content-type: text/html`,可通过它们的第三个参数进行修改:
    ```php
    return view($data,null,['Content-type'=>'text/html; charset=utf-8']);
    ```
2. 如果不指定模板文件，那么:
    * wulaphp将为你加载**与控制器同名(小写)目录下与方法同名的模板文件**。
    * 例: `MathController::add`的默认模板文件为`math/add.tpl`或`math/add.php`
3. 如果指定模板文件,那么:
    * 不要包括`views`目录名,可以通过`~`加载其它模块的模板除外，如:`~user/views/layout`表示加载`user`模块的`layout`模板。
    * 不要包括扩展名:`.tpl`或`.php`,以下为错误的加载方式
    ```php
    return view('math/add.tpl',$data);//错误
    //或
    return pview('math/add.php',$data);//错误
    ```

另外wulaphp为Smarty模板视图提供了一些有用的[修改器](theme.html#修改器)，不妨去看看。

> 通过继承`wulaphp\mvc\view\View`可以很方便地实现自己的视图模板引擎哦~,请移步[自定义模板引擎](../advance/view.html).

## 方法执行前后

在执行『方法(Action)』之前控制器的`beforeRun`会被调用，执行『方法(Action)』之后控制器的`afterRun`会被调用。

可以用他们来干一些有趣的事情，比如:

1. 在`beforeRun`中初始化一些共用资源；
2. 在`afterRun`中为模板传一些共用变量等。
3. 不过有一点要记住:**如果beforeRun返回了一个视图实例，那么『方法(Action)』将不会被执行！！**

具体用法可以看看wulaphp是如何利用`beforeRun`为控制器提供可按需加载的[特性](supports.html)的。