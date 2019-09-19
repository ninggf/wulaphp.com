---
title: 开启会话
showToc: 0
index: 1
desc: 使用wulaphp提供的SessionSupport使用会话(Session)功能
---

{$toc}

会话（SESSION）是现代WEB应用必不可少的功能之一，`wulaphp`内置的会话由类`wulaphp\io\Session`实现。

在`wulaphp`中使用会话很简单，只需为`Controller`添加`SessionSupport`特性即可, 眼见为实。

## 简单尝鲜 {#simple}

我们实现一个小功能以演示会话的基础应用，创建`hello\controllers\SessDemoController`:

```php
<?php
namespace hello\controllers;

use wulaphp\mvc\controller\Controller;
use wulaphp\mvc\controller\SessionSupport;

class SessDemoController extends Controller {
    use SessionSupport;

    public function index() {
        //return ['name' => sess_get('name')];
        return ['name' => $_SESSION['name']];
    }

    public function set() {
        $_SESSION['name'] = 'wulaphp is great!';

        return 'ok';
    }
    public function del(){
        $_SESSION['name'] = null;
        //sess_del('name');
        return 'deleted';
    }
}
```

### 验证 {#check}

1. 首先访问[http://127.0.0.1:8090/hello/sess-demo/set](http://127.0.0.1:8090/hello/sess-demo/set).
2. 然后访问[http://127.0.0.1:8090/hello/sess-demo](http://127.0.0.1:8090/hello/sess-demo),你将看到:

    ```json
    {"name":"wulaphp is great!"}
    ```

就是这么简单的, 原汁原味的PHP会话操作方式~

## 登录实战 {#login}

使用[连接数据库](db.md)中创建的用户进行登录。

### 支持会话 {#muc}

修改`hello\controllers\UserController`添加**SessionSupport**特性：

```php
class UserController extends Controller {
    use SessionSupport;
```

### 登录表单页 {#login}

它会显示登录表单页，让用户填写用户名和密码。
在`UserController`控制器中添加:

```php
public function login() {
    //从SESSION中读取errorInfo数据同时删除.
    $data['errorInfo'] = sess_del('errorInfo');

    return view($data);
}
```

#### 视图 {#aview}

添加视图文件`user/login.tpl`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
</head>
<body>
    <form action="{'hello/user/login'|app}" method="POST">
        <table>
            {if $errorInfo}
                <tr>
                    <td colspan="2" style="color: red">{$errorInfo}</td>
                </tr>
            {/if}
            <tr>
                <td>用户名</td>
                <td>
                    <input type="text" name="username"/>
                </td>
            </tr>
            <tr>
                <td>密码</td>
                <td>
                    <input type="password" name="passwd">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="登录">
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
```

### 登录处理 {#loginPost}

获取从登录表单页传递过来的用户名和密码，并进行验证，在`UserController`中添加代码如下:

```php
public function loginPost() {
    //读取表单数据
    $username = rqst('username');
    $passwd   = rqst('passwd');
    if (!$username || !$passwd) {
        $_SESSION['errorInfo'] = '用户名或密码为空';
        App::redirect('hello/user/login');
    }

    $userTable = App::table('user');
    //取用户数据并将其转换为array
    $user = $userTable->get(['username' => $username])->ary();
    if (!$user) {
        $_SESSION['errorInfo'] = '用户不存在';
        App::redirect('hello/user/login');
    }
    if ($user['hash'] != md5($passwd)) {
        $_SESSION['errorInfo'] = '用户名或密码错误';
        App::redirect('hello/user/login');
    }
    $_SESSION['userInfo'] = $user;
    App::redirect('hello/user/admin');
}
```

### 登录成功 {#acc}

在`UserController`中添加代码如下:

```php
public function admin() {
    //从SESSION中读取userInfo.
    $data['userInfo'] = sess_get('userInfo', []);
    if (!$data['userInfo']) {
        App::redirect('hello/user/login');
    }

    return view($data);
}
```

#### 视图 {#adview}

添加视图`user/admin.tpl`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>欢迎{$userInfo.nickname}</title>
</head>
<body>
    欢迎{$userInfo.nickname},<a href="{'hello/user/logout'|app}">退出</a>
</body>
</html>
```

### 退出 {#logout}

在`UserController`中添加代码如下:

```php
public function logout() {
    sess_del('userInfo');
    App::redirect('hello/user/login');
}
```

一个简单的登录功能就完成了，用[连接数据库](db.md)一节中创建的用户(`user1、user2、user3、user4、user5`，默认的密码是`123321`)去登录一下试试吧。

## 说明 {#note}

1. `sess_del`函数为wualphp提供的会话快捷操作函数
    * `sess_del` 取值并删除
    * `sess_get` 取值
2. `{'hello/user/login'|app}`中`app`是wulaphp提供的Smarty模板修饰器(`modifier`)
    * 模板中的模块控制器的URL都应使用`app`修饰器，因为模块的目录名是可变的
3. `rqst` 读取**POST**和**GET**数据,同时还有`irqst`,`frqst`等.
4. 当我们以**POST**方法请求`hello/user/login`时,请求将优先分发给`loginPost`处理.

## 接下来 {#next}

全面深入了解**wulaphp**，首先从它的[目录结构](structure.md)开始吧。
