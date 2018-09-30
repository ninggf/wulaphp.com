---
title: App类
type: guide
order: 606
---

使用wulaphp真的要瞅一瞅它的[源代码](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/app/App.php)。

除去之前文档中提到的`cfg`系列、`table`、`db`等方法，本文档注重讲解以下几个方法。

- [res](#res)
- [action](#action)
- [url](#url)
- [config](#config)
- [dir2id](#dir2id)
- [id2dir](#id2dir)
- [redirect](#redirect)
- [base](#base)
- [assets](#assets)
- [run](#run)

## res

生成模块资源URL:

```php
$src = App::res('helloworld/views/test.js');
```

**注意**使用res时请忘记模块目录名，要使用模块的命名空间。

## action

生成模块控制器的URL:

```php
$url = App::action('helloworld\controllers\MathController::add');
```

假设`helloworld`模块的模块目录为`hello`，那么生成的URL:`hello/math/add`。

## url

生成控制器URL:

```php
$url = App::url('helloworld/math/add');
```

假设`helloworld`模块的模块目录为`hello`，那么生成的URL:`hello/math/add`。
**再次强调**使用**命名空间**不要使用**模块目录**。

## config

获取Configuration实例:

```php
$cfg = App::config('default');
$val = $cfg->get('name','wula');
```

获取默认配置。

## dir2id

将模块目录转换为模块命名空间.

```php
$ns = App::dir2id('hello');
```

假设`helloworld`模块的模块目录为`hello`，那么`$ns`为`helloworld`。

## id2dir

将命名空间转换为模块目录.

```php
$dir = App::id2dir('helloworld');
```

假设`helloworld`模块的模块目录为`hello`，那么`$dir`为`hello`。

## redirect

跳转到相应的模块控制器.

```php
App::redirect('helloworld/math/add');
```

假设`helloworld`模块的模块目录为`hello`，那么将跳转到`hello/math/add`。如果你要跳转外部URL，请使用`Response::redirect()`。

## base

生成网站根目录下资源的URL。

```php
$url = App::base('a/b/c.png');
```

## assets

生成`assets`目录下资源的URL。

```php
$url = App::assets('a/b/c.png');
```

## run

运行或以指定方法访问指定URL:

1. 运行 -- 将请求路由给具体业务处理器:
    ```php
    App::run($url=null,$data=null,$method='GET');
    ```
2. 请求 -- 以指定方式访问指定URL(命令行脚本中):
    ```php
    @ob_start();
    try {
        App::run('/helloworld/');
    } catch (\Exception $e) {}
    $page = @ob_get_clean();
    ```
    > 1. `$page`即为URL `helloworld`页面的内容。
    > 2. 只能在命令行脚本中执行只方法，不能在控制器的方法中调用。

参数:

1. `$url`: 默认为`null`，路由客户端请求。如果不为空，则直接请求`$url`。
2. `$data`: `$url`不为`null`时要传递的数据。
3. `$method`: `$url`不为`null`时的请求方式。

返回:

无，直接输出页面内容(可以通过缓冲获取到内容)。