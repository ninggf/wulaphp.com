---
title: 应用配置
type: guide
order: 11
---

## 默认配置

其实`helloworld`模块也不需要啥配置，为了演示之目的，那我们就随便配置点东西，读出来玩玩吧。

### 添加配置

打开`conf/config.php`文件，它看起来差不多是这样的:

```php
<?php
return [
    'debug'    => env('debug', DEBUG_DEBUG),
    'resource' => [
        'combinate' => env('resource.combinate', 0),
        'minify'    => env('resource.minify', 0)
    ]
];
```

我们添加两个配置`name`(姓名),`contact`(联系信息)到文件中:

```php
<?php
return [
    'debug'    => env('debug', DEBUG_DEBUG),
    'resource' => [
        'combinate' => env('resource.combinate', 0),
        'minify'    => env('resource.minify', 0)
    ],
    'name'     => 'Leo Ning',
    'contact'  => [
        'addr'   => 'China',
        'qq'     => '284795022',
        'wechat' => 'windywany'
    ]
];
```

### 读取配置

1. 添加`InfoController`控制器到`helloworld`模块:

    ```php
    <?php

    namespace helloworld\controllers;

    use wulaphp\app\App;
    use wulaphp\mvc\controller\Controller;

    class InfoController extends Controller {
        public function index() {
            $data['name'] = App::cfg('name');
            //读取整个配置
            $data['contact'] = App::cfg('contact');
            //读取一个不存在的配置将使用默认值10
            $data['age'] = App::icfg('age', 10);
            //直接读取 contact数组的addr
            $data['addr'] = App::cfg('contact.addr');

            return view($data);
        }
    }
    ```

2. 创建`views/info/index.tpl`:

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Info</title>
    </head>
    <body>
        <p>name:{$name}</p>
        <p>age:{$age}</p>
        <p>contact wechat:{$contact.wechat}</p>
        <p>contact addr:{$addr}</p>
    </body>
    </html>
    ```

3. 访问`helloworld/info`你将看到:

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Info</title>
    </head>
    <body>
    <p>name:Leo Ning</p>
    <p>age:10</p>
    <p>contact wechat:windywany</p>
    <p>contact addr:China</p>
    </body>
    </html>
    ```

读取配置就是这么简单。

## 自定义配置

上边是把配置添加到默认配置组了，下边我们创建自定义配置组:`hello`。

1. 创建文件 `conf/hello_config.php`:

    ```php
    <?php
    return [
        'name'    => 'Leo Ning',
        'contact' => [
            'addr'   => 'China',
            'qq'     => '284795022',
            'wechat' => 'windywany'
        ]
    ];
    ```

2. 添加`infoHello`方法到`InfoController`控制器:

    ```php
    public function infoHello() {
        $data['name'] = App::cfg('name@hello');
        //读取整个配置
        $data['contact'] = App::cfg('contact@hello');
        //读取一个不存在的配置将使用默认值10
        $data['age'] = App::icfg('age@hello', 10);
        //直接读取 contact数组的addr
        $data['addr'] = App::cfg('contact.addr@hello');

        return view('info/index', $data);
    }
    ```

3. 访问`helloworld/info/info-hello`你将看到:

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Info</title>
    </head>
    <body>
    <p>name:Leo Ning</p>
    <p>age:10</p>
    <p>contact wechat:windywany</p>
    <p>contact addr:China</p>
    </body>
    </html>
    ```

> 注意读取配置参数的变化,通过在配置名后添加`@组名`来读取指定组的配置，
>
> 如: `App::cfg('name@hello')`
>
> 注意URL的变化, infoHello --> info-hello, 这是约定。

好啦，配置就是这么简单。

## 读取方法

也许你已经注意到了`App::cfg`、`App::icfg`等读取配置的方式,`wulaphp`读取配置的快捷方法还有以下种:

1. `App::bcfg($name, $default = false)`:读取`bool`型配置
2. `App::icfg($name, $default = 0)`:读取`int`型配置
3. `App::icfgn($name, $default = 0)`:
    * 读取`int`型配置
    * 如果配置值为0则返回`$default`
4. `App::acfg($name, $default = [])`:加载`array`型配置
5. `App::cfg($name = '@default', $default = '')`:
    * 调用`App::cfg()`时返回默认配置(Configuration)实例.
    * 调用`App::cfg('@hello')`时返回`hello`配置实例.
    * 调用`App::cfg('name@hello')`时返回`hello`配置中`name`配置项的值.

更多配置相关信息,请移步[配置详解](advance/config.html).

## 接下来

不连数据库的WEB应用都不能叫WEB应用，让我们[连上数据库](database.html)吧.