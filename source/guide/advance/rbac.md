---
title: 授权认证
type: guide
order: 1103
---

wulaphp提供了可扩展的授权认证机制，按套路可以很轻松地实现用户授权认证。先列出需要使用的类:

1. `Passport` 登录用户通行证类，保存用户信息，并完成授权。
2. `RbacSupport` 授权认证特性，Controller使用此特性进行授权认证。
3. `AdminController` 使用了`RbackSupport`特性的控制器。
4. `AclResourceManager` 可访问资源管理器。
5. `AclResource` 可访问资源，通过它定义一个可访问资源与对其的操作。

接下来按套路一步一步实现一个简单的授权认证模块(此例不会使用`3,4,5`提到的类)，包括以下功能:

1. 登录
2. 授权

## 登录

1. 新建模块`auth`(可以通过命令`php artisan create:module auth`创建), 其引导文件如下:
    ```php
    <?php
    namespace auth;

    use wulaphp\app\App;
    use wulaphp\app\Module;

    class AuthModule extends Module {
        public function getName() {
            return '登录模块';
        }

        public function getDescription() {
            return '演示wulaphp的授权认证机制';
        }

        public function getHomePageURL() {
            return '';
        }
    }
    App::register(new AuthModule());
    ```
2. 创建`auth\classes\AuthedController`作为所有需要登录控制器的基类:
    ```php
    <?php

    namespace auth\classes;

    use wulaphp\app\App;
    use wulaphp\auth\PassportSupport;
    use wulaphp\auth\RbacSupport;
    use wulaphp\mvc\controller\Controller;
    use wulaphp\mvc\controller\SessionSupport;
    use wulaphp\mvc\view\SimpleView;

    class AuthedController extends Controller {
        use SessionSupport, PassportSupport, RbacSupport;
        //定义通行证类型
        protected $passportType = 'vip';

        /**
        * 需要登录时。
        *
        * @param $view
        */
        protected function needLogin($view) {
            //直接跳转到登录页
            App::redirect('auth/login');
        }
        //没权限时
        protected function onDenied($message, $view) {
            $view = new SimpleView('你没权限干这事:' . $message);
            return $view;
        }
    }
    ```
3. 创建`auth\classes\VipxPassport`类（自定义通行证类）:
    ```php
    <?php

    namespace auth\classes;

    use wulaphp\auth\Passport;

    class VipxPassport extends Passport {
        /**
        * 当前用户是否是$role角色.
        *
        * @param string|array $roles
        *
        * @return bool
        */
        public function is($roles) {
            return !empty(array_intersect(['管理员', '超级管理员'], (array)$roles));
        }

        /**
        * 鉴权.
        *
        * @param string $op    操作
        * @param string $res   资源
        * @param array  $extra 额外数据
        *
        * @return bool 可以对资源($res)进行操作($op)时返回true，反之返回false。
        */
        protected function checkAcl($op, $res, $extra) {
            if ($op == 'add' && $res == 'user') {
                return true;
            }

            return false;
        }

        /**
        * 登录.
        *
        * @param array $data
        *
        * @return bool 登录成功返回true,登录失败返回false.
        */
        protected function doAuth($data = null) {
            if ($data && $data['username'] == 'leo' && $data['passwd'] == '123321') {
                $this->uid      = 1;
                $this->username = $data['username'];
                $this->nickname = 'Leo Ning';
                $this->phone    = '13888888888';

                return true;
            } else {
                return false;
            }
        }
    }
    ```
    > **说明**
    > 
    > 1. `is` 判断用户是否拥有一个或多个角色.示例中假设登录的用户是『管理员』和『超级管理员』。
    > 2. `checkAcl` 鉴权，示例演示登录用户只有`add user`和`del role`权限。
    > 3. `doAuth` 登录，示例演示只要用户名是`leo`密码是`123321`就可以登录。
4. 修改引导文件使用自定义的VipxPassport类:
    ```php
    /**
    * 绑定到勾子passport\newVipPassport
    * @param $passport
    *
    * @filter passport\newVipPassport
    * @return Passport
    */
    public static function createPassport($passport) {
        if ($passport instanceof Passport) {
            $passport = new VipxPassport();
        }

        return $passport;
    }
    ```
5. 创建`auth\controllers\LoginController`(出于演示目的，此处直接登录):
    ```php
    <?php

    namespace auth\controllers;

    use wulaphp\app\App;
    use wulaphp\mvc\controller\Controller;
    use wulaphp\mvc\controller\SessionSupport;

    class LoginController extends Controller {
        use SessionSupport;

        public function index() {
            $passport = whoami('vip');
            if ($passport->login(['username' => 'leo', 'passwd' => '123321'])) {
                App::redirect('auth/acl');
            } else {
                return '登录错误信息:' . $passport->error;
            }
        }
    }
    ```
6. 创建`auth\controllers\AclController`(授权示例将写在此控制器):
    ```php
    <?php

    namespace auth\controllers;

    use auth\classes\AuthedController;

    /**
    * Class AclController
    * @package auth\controllers
    * @login
    */
    class AclController extends AuthedController {
        public function index() {
            return 'Hello ' . $this->passport->nickname;
        }
    }
    ```
    > **注意到`@login`注解了吗?**此注解表示AclController里的所有方法都需要登录才能执行。
    >
    > `AclController`通过继承`AuthedController`使用`RbacSupport`。

访问`auth/acl`试下，不出差错你将看到：**Hello Leo Ning**。如何实现的？让我们一起来捊一捊，看看能不能捋顺:

1. 访问`auth/acl`时:
    * RbacSupport通过勾子`passport\newVipPassport`获取VipxPassport实例。
        * 调用`AuthModule::createPassport`创建VipxPassport实例
    * RbacSupport发现访问`index`方法需要登录(@login决定的)。
    * RbacSupport检查后发现VipxPassport实例未登录调用`AuthedController::needLogin)
2. `AuthedController::needLogin`将用户跳转到`auth/login`时:
    * `LoginController::index`方法通过`whoami('vip')`获取VipxPassport实例。
        * 内部也是使用勾子`passport\newVipPassport`。
        * `whoami`可以在任何地方获取指定类型的通行证实例。
    * 此处出于演示目的直接调用`Passport::login`方法。
    * `Passport::login`将数据传给`VipxPassport::doAuth`进行登录验证。
    * 登录完成后`LoginController::index`方法将用户跳转到`auth/acl`
3. 跳转到`auth/acl`时:
    * VipxPassport实例已经登录，那么就向通行证的主人打个招呼呗。

捋顺了吗？没顺再去看下代码!

## 授权

通过`acl`注解定义访问方法需要的权限，通过`aclmsg`注解定义用户无权限时的提示信息。

> `acl`和`aclmsg`同样可以作用于控制器定义控制器所有方法需要的权限。

RbacSupport还支持以下几个注解:

1. nologin： 方法不需要登录就可以访问
2. roles： 需要角色，多个角色用逗号分隔（可以作用于控制器）

示例走起:

1. 为`AclController`添加需要`add:user`权限的方法`addUser`:
    ```php
    /**
    * @acl add:user
    * @aclmsg 你没权限添加用户
    */
    public function addUser() {
        return 'you are adding a new user';
    }
    ```
    访问`auth/acl/add-user`你肯定能看到:**you are adding a new user**。
2. 为`AclController`添加需要`del:user`权限方法`delUser`:
    ```php
    /**
    * @acl    del:user
    * @aclmsg 你没权限删除用户
    */
    public function delUser() {
        return 'you are deleting a user';
    }
    ```
    访问`auth/acl/del-user`你肯定能看到:**你没权限干这事:你没权限删除用户**。
3. 为`AclController`添加需要特定角色才能执行的方法`listUser`:
    ```php
    /**
    * @roles  人事,人事总监
    * @aclmsg 你没权限看用户列表
    */
    public function listUser() {
        return 'you are viewing user list';
    }
    ```
    访问`auth/acl/list-user`你看到啥了?

至此，**授权认证演示完毕**!! 有以下几点要重点说明:

1. 实现一个Passport子类然后重写它的以下方法:
    * `is` 有没有角色啊
    * `checkAcl` 有没有权限啊
    * `doAuth` 能不能登录啊，登录之后用户有哪些数据要存会话啊。
2. 如果需要在代码中手动验证权限，你可以这么干:
    ```php
    $passport = whoami('type');
    if($passport->cando('add:user')){
        //可以做
    }
    ```
3. 权限格式为**op:res**，用逗号分隔操作与资源。
4. 如果简单的**op:res**搞不定你的授权认证需求，请使用插件搞定(以`add:user/account`为例):
    ```php
    class UserAccountChecker extends AclExtraChecker {
        protected function doCheck(Passport $passport, $op, $extra) {
            return true;
        }
    }
    bind('rbac\getExtraChecker\user\account',function($checker){
        $checker = new UserAccountChecker();
        return $checker;
    });
    ```
    完成doCheck方法，用户有权限你就返回true,没权限你就返回false。就这么简单，请注意勾子的格式。
