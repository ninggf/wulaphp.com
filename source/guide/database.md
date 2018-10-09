---
title: 连接数据库
type: guide
order: 12
---

是时候连接数据库了！

> 目前`wulaphp`提供了`MySQL`与`SQLite`数据库驱动。

## 创建数据库

用你拿手的工具连接上你的`MySQL`数据库并执行以下SQL语句：

1. 创建数据库

    ```sql
    CREATE DATABASE demo_db DEFAULT CHARSET UTF8;
    ```

2. 创建表

    ```sql
    CREATE TABLE `user` (
        `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
        `username` VARCHAR(32) NOT NULL COMMENT '用户名',
        `nickname` VARCHAR(32) NULL COMMENT '昵称',
        `phone` VARCHAR(16) NULL COMMENT '手机号',
        `email` VARCHAR(128) NULL COMMENT '邮箱地址',
        `status` SMALLINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1正常,0禁用,2密码过期',
        `hash` VARCHAR(255) NOT NULL COMMENT '密码HASH',
        PRIMARY KEY (`id`),
        UNIQUE INDEX `UDX_USERNAME` (`username` ASC),
        INDEX `IDX_STATUS` (`status` ASC)
    )  ENGINE=INNODB DEFAULT CHARACTER SET=UTF8 COMMENT='用户表'
    ```

3. 添加一些数据

    ```sql
    INSERT INTO
        `user`(`username`,`nickname`,`phone`,`email`,`hash`)
    VALUES
        ('user1','张三','13888888888','admin@abc.com',MD5('123321')),
        ('user2','李四','13988888888','admin@def.com',MD5('123321')),
        ('user3','王二','13788888888','admin@ghi.com',MD5('123321')),
        ('user4','韩梅梅','13688888888','admin@jkl.com',MD5('123321')),
        ('user5','李雷','13588888888','admin@mno.com',MD5('123321'));
    ```

数据准备好了，让我们连上它并读出用户列表吧.

## 配置数据库

打开`conf/dbconfig.php`文件，根据提示进行配置:

```php
<?php
/**
 * 数据库配置。
 */
$config = new \wulaphp\conf\DatabaseConfiguration('default');
//数据库驱动
$config->driver(env('db.driver', 'MySQL'));
//数据库所在主机的域名或IP
$config->host(env('db.host', 'localhost'));
//数据库运行端口
$config->port(env('db.port', '3306'));
//数据库名称
$config->dbname(env('db.name', 'demo_db'));
//数据库编码
$config->encoding(env('db.charset', 'UTF8'));
//用户名
$config->user(env('db.user', 'root'));
//密码
$config->password(env('db.password', '888888'));
//驱动选项
$options = env('db.options', '');
if ($options) {
    $options = explode(',', $options);
    $dbops   = [];
    foreach ($options as $option) {
        $ops = explode('=', $option);
        if (count($ops) == 2) {
            if ($ops[1][0] == 'P') {
                $dbops[ @constant($ops[0]) ] = @constant($ops[1]);
            } else {
                $dbops[ @constant($ops[0]) ] = intval($ops[1]);
            }
        }
    }
    $config->options($dbops);
}
```

更多配置请参考[数据库配置](config/db.html)。

## 显示用户列表

1. 在`helloworld`模块的controllers目录创建控制器`helloworld\controllers\UserController`:

    ```php
    <?php

    namespace helloworld\controllers;

    use wulaphp\app\App;
    use wulaphp\mvc\controller\Controller;

    class UserController extends Controller {
        public function index() {
            $data['users'] = App::table('user')->select('*');

            return view($data);
        }
    }
    ```

2. 在`views`目录创建视图`user/index.tpl`:

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>用户列表</title>
    </head>
    <body>
    <table>
        <tr>
            <th>ID</th>
            <th>账户</th>
            <th>姓名</th>
            <th>手机</th>
            <th>邮箱</th>
        </tr>
        {foreach $users as $user}
            <tr>
                <td>{$user.id}</td>
                <td>{$user.username}</td>
                <td>{$user.nickname}</td>
                <td>{$user.phone}</td>
                <td>{$user.email}</td>
            </tr>
        {/foreach}
    </table>
    </body>
    </html>
    ```

3. 访问`helloworld/user`,结果如你想见。

### 更多显示方式

1. 按姓名倒序显示列表:

    ```php
    public function index() {
        $user          = App::table('user');
        $users         = $user->select('*')->desc('nickname');
        $data['users'] = $users;

        return view($data);
    }
    ```

2. 只显示2个用户

    ```php
    public function index() {
        $user          = App::table('user');
        $users         = $user->select('*')->limit(0, 2);
        $data['users'] = $users;

        return view($data);
    }
    ```

3. 只显示用户ID大于2且姓名中含有「李」的用户

    ```php
    public function index() {
        $user                   = App::table('user');
        $where['id >']          = 2;
        $where['nickname LIKE'] = '李%';
        $users                  = $user->select('*')->where($where);
        $data['users']          = $users;

        return view($data);
    }
    ```

4. 只显示用户ID不是1和5的用户.

    ```php
    public function index() {
        $user            = App::table('user');
        $where['id !IN'] = [1, 5];
        $users           = $user->select('*')->where($where);
        $data['users']   = $users;

        return view($data);
    }
    ```

5. 显示用户名是user1或user2的用户

    ```php
    public function index() {
        $user                = App::table('user');
        $where['username']   = 'user1';
        $where['||username'] = 'user2';
        $users               = $user->select('*')->where($where);
        $data['users']       = $users;

        return view($data);
    }
    ```

6. 显示用户ID大于2且用户名是user3或user5的用户

    ```php
    public function index() {
        $user          = App::table('user');
        $where['id >'] = 2;
        $where[]       = ['username' => 'user3', '||username' => 'user5'];
        $users         = $user->select('*')->where($where);
        $data['users'] = $users;

        return view($data);
    }
    ```

连接数据库并进行简单的查询就是这么简单哦,至于"增删改"等更多数据库操作请查看[数据库访问](db).

## 接下来

WEB应用基本上离不开会话（SESSION）的支持，那么让我们通过`wulaphp`提供的SessionSupport特性来[开启会话](session.html)之旅吧。
