---
title: 控制器特性
type: guide
order: 25
---

## 概述

控制器[Controller](controller.html)功能太简单了，啥功能都得自己从头写。现代WEB应用哪能离开会话，登录授权这些功能。得益于PHP的[Trait](http://php.net/manual/zh/language.oop5.traits.php)，wulaphp利用Trait实现了为控制器动态添加功能的特性。目前内置的特性有:

1. [SessionSupport](#SessionSupport): 会话支持(自动开启会话)
2. [PassportSupport](#PassportSupport): 通行证支持(依赖SessionSupport)
3. [RbacSupport](#RbacSupport): 授权验证支持（依赖PassportSupport）
4. [CacheSupport](#CacheSupport): 缓存支持
5. [LayoutSupport](#LayoutSupport): 视图布局支持
6. [URLGroupSupport](#URLGroupSupport): 将控制器分组

当然[自己实现一个特性](#自定义特性)也是很简单的。

## SessionSupport

自动为`Controller`开启会话，wulaphp默认是不会为`Controller`开启会话(`session`)的，为啥？
因为开启会话真的耗费服务器资源，所以只为需要会话支持的控制器开启会话，比如我们有一个控制器`AdminController`需要会话来保存用户登录信息,只需要使用(`user`)`SessionSupport`特性即可:

```php
class AdminController extends Controller{
    use SessionSupport;
}
```

可以在`AdminController`的所有方法中直接使用`$_SESSION`了, 原汁原味。

## PassportSupport

wulaphp通过[Passport](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/auth/Passport.php)机制为控制器提供当前登录用户的信息。
当控制器使用了`PassportSupport`特性之后就可以在其方法中直接访问`$this->passport`了:

```php
class AdminController extends Controller{
    use SessionSupport,PassportSupport;
    private $passportType = 'admin';

    public function index() {
        if (!$this->passport->isLogin) {
            //未登录啊
        }
    }
}
```

> **说明**
>
> 1. `PassportSupport`依赖`SessionSupport`存储通行证数据，所以要在其之前使用`SessionSupport`。
> 2. 可以通过`$passportType`指定当前控制器使用的通过行类型。`admin`类型的通行证可以通过勾子`passport\newAdminPassport`自定义创建。
> 3. 通行证登录、退出等操作详见[授权认证](../advance/rbac.html)。

## RbacSupport

用户能访问哪个控制器的哪个方法？通过`RbacSupport`可以简单实现授权认证。`RbacSupport`通过`PassportSupport`提供的通行证的`cando`进行权限认证，
通过`is`进行角色认证，具体请见[授权认证](../advance/rbac.html)。为`AdminController`添加此特性并要求`index`用户登录后才能访问:

```php
class AdminController extends Controller{
    use SessionSupport,PassportSupport,RbacSupport;
    protected $passportType = 'admin';
    /**
     * @login
     */
    public function index() {

    }
}
```

wulaphp真的提供了一个[AdminController](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/controller/AdminController.php)呢，可以直接使用哦。
更多此特性提供的功能见[授权认证](../advance/rbac.html)。

## CacheSupport

此特性超简单，配置好[缓存](../config/cache.html)，然后在要缓存的方法上添加`@expire`注解即可，剩下的事情交给wulaphp:

```php
class AController extends Controller{
    /**
     * @expire 3600
     */
    public function page($id){
        return view(...)
    }
}
```

`a/page/1`这样的页面会缓存3600秒(1小时)。

## LayoutSupport

布局特性，特别适合后台界面,直接上代码了:

```php
class VipController extends Controller{
    use LayoutSupport;
    protected $layout = '~vip/views/user';

    public function index(){
        return $this->render();
    }
    public function orders(){
        return $this->render();
    }
}
```

`$this->render`模板加载机制同`view`[视图(View)](controller.html#视图)。

`vip/views/user.tpl`:

```html
<html>
<head>
</head>
<body>
<header>....</header>
<aside></aside>
<section>{include "$workspaceView"}</section>
<footer>....</footer>
</body>
</html>
```

重要的是`{include "$workspaceView"}`。`$workspaceView`是通过`$this->render`加载的模板。

## URLGroupSupport

可以将模块、控制器URL进行分组。假如有两个模块,`a`和`b`，各有一个控制器`CController`，它们的URL分别为`a/c`和`b/c`。可以通过此特性修改他们的访问URL，比如修改为`d/a/c`和`d/b/c`。不多说了，上代码：

1. a模块类:
    ```php
    class AModule extends Module {
        use URLGroupSupport;

        public static function urlGroup() {
            return ['~', 'd'];
        }
    }
    ```
2. b模块类:
    ```php
    class BModule extends Module {
        use URLGroupSupport;

        public static function urlGroup() {
            return ['~', 'd'];
        }
    }
    ```
3. CController:
    ```php
    class CController extends Controller{
        use URLGroupSupport;

        public static function urlGroup() {
            return ['~', 'd'];
        }
    }
    ```

当控制器通过本特性进行分组时，模板中通过`app`修改器生成URL的地方要相应的改为`{'~a/c'|app}`。`~`就是分组标识用于`app`修改器，除了`~`还有以下合法的分组标识:`!, @, #, %, ^, &, *`。这个功能有啥用?!!

## 自定义特性

如果上述特性不够用，你可以自己动手实现啊，反正又不难的喽。比如实现一个`DiaoSupport`:

```php
trait DiaoSupport{
    protected function onInitDiaoSupport(){
        //特性初始化代码
    }
    protected function beforeRunInDiaoSupport($method,$view){
        return $view;
    }
    protected function afterRunInDiaoSupport($action,$view,$method){
        return $view;
    }
}
```

好啦，你实现了一个特性。简单地解释一下:

1. `onInitDiaoSupport`初始化这个特性（控制器初始化时）。
2. `beforeRunInDiaoSupport`在`Controller`的`beforeRun`方法中被调用。
3. `afterRunInDiaoSupport`在`afterRun`方法中被调用。

**特别说明**
除这三个方法以外，特性还可以提供其它方法哦，比如你搞一个`RedisSupport`提供一个`getRedis`方法，控制器的其它方法就可以方便的获取redis实例了:

```php
trait RedisSupport{
    private $redis;
    protected function onInitRedisSupport(){
        $this->redis = new ...
    }
    protected function getRedis(){
        return $this->redis;
    }
}
```

wulaphp提供了更易使用[Redis](../utils/redis.html)的方式，所以你不要真的去写一个Reids特性哦^_^