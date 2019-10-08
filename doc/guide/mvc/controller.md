---
title: 控制器
showToc: 0
index: 1
desc: 控制器，一切尽在你的掌握之中
---

{$toc}

MVC中的C -- 控制器，小名叫`Controller`。可能与其它框架的控制器不太相同:

1. wulaphp的控制器要属于一个模块。
2. 它的**命名空间**只能是模块的命名空间的子命名空间（详见[模块(M)](../module/index.md#ns)）。
3. 控制器类文件要存放在模块(或子模块)的`controllers`目录里。
4. wulaphp的控制器可按需加载需要的特性。

## 定义控制器 {#ctr}

上代码:

```php
<?php
namespace hello\controllers;

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

所有控制器都是[Controller](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/controller/Controller.php)类的子类。`wulaphp`对控制器有以下两个约定:

1. `IndexController` 为模块的默认控制器。
2. `index` 方法为控制器的默认方法(Action)。

默认控制器与默认方法将影响URL路由，具体请传送至[URL路由](../start.md#url)。

## 方法(Action) {#action}

真正干活的是控制器的方法(Action),如上例中的`index`。每个方法都要返回一个[视图](view.md)实例做为对用户请求的响应。
如果方法没有返回值或者返回`null`,那么当前请求将交由其它分发器处理。创建视图实例有以下几种方法:

1. 使用`view`方法加载[SmartyView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/SmartyView.php)实例(详见[视图(View)](#视图)):

    ```php
    return view(...);
    ```

2. 使用`pview`方法加载php模板文件:

    ```php
    return pview(...);
    ```

3. 使用`template`方法加载[ThemeView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/ThemeView.php)实例(详见[主题](../theme.md)):

    ```php
    return template(...);
    ```

4. 直接返回字符或创建[SimpleView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/SimpleView.php)实例以响应普通文本(响应头为:`Content-type: text/plain; charset=utf-8`):

    ```php
    return 'Hello World!';
    //等同于下边代码
    return new SimpleView('Hello World!');
    ```

5. 直接返回数组或创建[JsonView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/JsonView.php)实例以响应JSON数据(响应头为:`Content-type: application/json`):

    ```php
    return ['code'=>0,'message'=>'ok'];
    //等同于下边代码
    return new JsonView(['code'=>0,'message'=>'ok']);
    ```

6. 使用`xmlview`创建[XmlView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/XmlView.php)实例以响应XML文档(响应头为:`Content-type: text/xml; charset=utf-8`):

    ```php
    return xmlview(...)
    // 或
    return new XmlView(...);
    ```

7. 使用`excel`创建Excel文件(用于下载/导出Excel文件):

    ```php
    $data[1] = ['A'=>'A1','B'=>'B1','E'=>'E1'];
    ...
    $data[n] = ['A'=>'An'];

    return excel('文件名',$data);
    ```

8. 输出JS文件:

    ```php
    $js = $this->module->loadFile('your_js_file');
    // 对js一顿猛操作
    return new JsView($js);
    ```

当然你可以在方法里直接使用`die`、`exit`干死当前请求或者使用`Response::redirect`或`App::redirect`跳转到其它页面。

## 方法进阶 {#more}

想像一下你正在开发用户登录功能，你搞了一个控制器`AuthController`，用它的`login`方法(相应的URL为`auth/login`)显示登录界面:

```php
class AuthController extends Controller{
    public function login(){
        return view();
    }
}
```

那么用户登录数据（用户名，密码啥的）要提交到哪个方法呢?`doLogin`?提交到`doLogin`这个方法是没问题的，但是wulaphp允许你使用`POST`方式将数据提交到`auth/login`这个URL，而要做的只是简单的定义一个`loginPost`方法:

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

[HTTP请求方式](https://www.w3schools.com/tags/ref_httpmethods.asp)常用的有以下几种:

1. GET
2. POST
3. PUT
4. DELETE
5. HEAD

讲真，知道PUT和DELETE的请举手，不能分清GET和POST请抓紧时间自学一波。

## URL生成 {#url}

无论是控制器还是方法，如果他们使用了驼峰方式命名，如:`MyInfoController`、`doLogin`, 请记住在URL中用`-`连接驼峰:

1. `my-info`
2. `do-login`

请一定要通过`App::url`和`App::action`方法生成URL，他们可以保证生成的URL在不同情况下是正确的。比如默认模块的URL、设置了别名的模块的URL、设置了别名的URL、启用了`urlGroup`的控制器的URL等等，详见[App::url](../utils/app.md#url)和[App::action](../utils/app.md#action)。Smarty模板中一定要通过`app`和`action`修饰器生成URL，他们的作用同`App:url`和`App::action`，详见[修饰器](../theme.md#modifiers)。

## 视图模板 {#tpl}

视图模板文件存放在`views`目录中。

<p class="tip">
如果你还不熟悉Smarty模板引擎,请在开始使用主题之前花点时间熟悉一下<a href="https://www.smarty.net/docs/zh_CN/" target="_blank">Smarty</a>。
</p>

如果你的方法通过`view`或`pview`来加载`views`目录下的Smarty模板或PHP模板做为视图，那么请您记住以下三点约定:

1. `view/pview`方法加载的视图默认响应为`Content-type: text/html`,可通过它们的第三个参数进行修改:

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

另外wulaphp为Smarty模板视图提供了一些有用的[变量修饰器](../theme.md#modifiers)，不妨去看看。

> 通过继承`wulaphp\mvc\view\View`可以很方便地实现自己的视图模板引擎哦~,请移步[自定义模板引擎](view.md#custom)。

## 方法执行前后 {#beaf}

在执行『方法(Action)』之前控制器的`beforeRun`会被调用，执行『方法(Action)』之后控制器的`afterRun`会被调用。

可以用他们来干一些有趣的事情，比如:

1. 在`beforeRun`中初始化一些共用资源；
2. 在`afterRun`中为模板传一些共用变量等。
3. 不过有一点要记住:**如果beforeRun返回了一个视图实例，那么『方法(Action)』将不会被执行！！**

具体用法可以看看wulaphp是如何利用`beforeRun`为控制器提供可按需加载的[特性](supports.md)的。
