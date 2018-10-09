---
title: 高级路由
type: guide
order: 1001
---

路由功能是所有WEB框架的核心，wulaphp的路由功能由两部分组成:

1. [路由器](#路由器)
2. [分发器](#分发器)
    1. 前置分发器
    2. 分发器
    3. 后置分发器

一个请求先到达路由器，然后按优先级交给分发器处理，流程图如下:

![route](../../imgs/route.png)

## 路由器

路由器负责管理分发器、解析URL、处理别名、分发URL、绘制视图、输出响应。

> 通过自定义分发器，你的URL你做主!

### 管理分发器

模块、扩展通过勾子`router\registerDispatcher`向路由器注册分发器:

1. `Router::register`注册分发器
2. `Router::registerPreDispatcher`注册前置分发器
3. `Router::registerPostDispatcher`注册后置分发器

### 解析URL

在真正分发URL之前，可以通过:

1. `router\parse_url` 勾子修改要分发的`$url`。
2. 设置URL别名重写`$url`。
3. `router\beforeDispatch`勾子优先处理`$url`。

### 分发URL

将[解析](#解析URL)后的`$url`交给分发器处理。

### 绘制视图

绘制分发器返回的控制器[视图](../mvc/view.html)或[主题](../mvc/theme.html)。

### 输出响应

将绘制好的视图内容输出给客户端。

## 分发器

分发器就是请求处理器，用户想要的东东(视图)都由分发器提供，分发器有三种类型:

1. 前置分发器，可以返回一个视图中断路由器将`$url`交给**分发器**处理。
2. 分发器，一旦一个分发器返回了视图，路由器将忽略优先级低的其它分发器。
3. 后置分发器，可以在此处理分发器返回的视图。

### 前置分发器

实现`\wulaphp\router\IURLPreDispatcher`接口，通过`Router::registerPreDispatcher`注册到路由器:

```php
// 类
class MyPreDispatcher implements IURLPreDispatcher {
    /**
    * 分发之前调用
    *
    * @param string $url    正在请求的URL.
    * @param Router $router 路由器实例.
    * @param View   $view   前一个分发器返回的View实例.
    *
    * @return View|null View 实例或null
    */
    public function preDispatch($url, $router, $view){
        // 你的处理
    }
}

// 注册
bind('router\registerDispatcher',function($router){
    $router->registerPreDispatcher(new MyPreDispatcher());
});
```

### 分发器

实现`\wulaphp\router\IURLDispatcher`接口，通过`Router::register`注册到路由器:

```php
// 类
class MyDispatcher implements IURLDispatcher {
    /**
    * 分发URL.
    * 一旦有一个分发器返回View实例，则立即返回，停止分发其它的.
    *
    * @param string        $url        正在请求的URL.
    * @param Router        $router     路由器.
    * @param UrlParsedInfo $parsedInfo URL解析信息.
    *
    * @return View View 实例.
    */
    public function dispatch($url, $router, $parsedInfo){
        if($url == 'my.html'){
            return template('my.tpl');
        }
        return null;
    }
}

// 注册
bind('router\registerDispatcher',function($router){
    $router->register(new MyDispatcher());
});
```

#### parsedInfo

生成分页URL分用的[UrlParsedInfo](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/router/UrlParsedInfo.php)的实例，在分发的过程中，你需要解析以下数据并填充到`$parsedInfo`(路由器已经初步解析了大部分数据，你的分发器只需要按需修改):

1. `$parsedInfo->page` 页码
2. `$parsedInfo->ext` 扩展名，比如`abc/add.html`的扩展名为'html'。
3. `$parsedInfo->contentType` 内容类型
4. `$parsedInfo->path` URL路径
5. `$parsedInfo->name` URL对应的文件名
6. `$parsedInfo->ogname` 浏览器友好的文件名(经`urlencode`编码)

#### 内置分发器

wulaphp提供了两个内置的分发器:[DefaultDispatcher](#默认分发器)和[RouteTableDispatcher](#路由表)。

### 后置分发器

对分发器返回的视图进一步处理，实现`\wulaphp\router\IURLPostDispatcher`接口，通过`Router::registerPostDispatcher`注册到路由器:

```php
// 类
class MyPostDispatcher implements IURLPostDispatcher {
    /**
    * 分发之后.
    *
    * @param string $url    正在请求的URL.
    * @param Router $router 路由器.
    * @param View   $view   要渲染的view.
    *
    * @return View View 实例.
    */
    function postDispatch($url, $router, $view){
        // 你的处理
    }
}

// 注册
bind('router\registerDispatcher',function($router){
    $router->registerPostDispatcher(new MyPostDispatcher());
});
```

## 默认分发器

将请求分发给模块的控制器的具体方法(Action)，遵循**所见即所得**的路由规则。
但是，但是，但是路由规则还是因模块的配置不同而有所不同。

<p class="tip">下述文档以`helloworld`模块为例</p>

### 普通模块

<pre>
[urlGroup/]helloworld/math/sub/1/2
    │       │          │    │  └─└────────── 参数（*）
    │       │          │    └─────────────── action/参数（*）
    │       │          └──────────────────── 控制器名/action（*）
    │       └─────────────────────────────── 模块目录
    └──────────────────────────────────────── urlGroup(*)
</pre>

> 带*的表示可以没有

此URL的路由分发顺序如下:

1. MathController的sub方法，接收二个参数: 1,2
2. MathController的index方法，接收三个参数:sub,1,2
3. IndexController的math方法，接受三个参数:sub,1,2
4. IndexController的index方法，接收四个参数:math,sub,1,2

<p class="tip">
urlGroup部分参考控制器的[URLGroupSupport](../mvc/supports.html#URLGroupSupport)
</p>

### 子模块

<pre>
[urlGroup/]helloworld/calc/math/sub/1/2
    │       │          │    │    │  └─└───── 参数（*）
    │       │          │    │    └────────── action/参数（*）
    │       │          │    └─────────────── 控制器名/action（*）
    │       │          └──────────────────── 子模块（*）
    │       └─────────────────────────────── 模块目录
    └─────────────────────────────────────── urlGroup(*)
</pre>

> 带*的表示可以没有

此URL的路由分发顺序如下:

1. 模块的CalcController的math方法,接收三个参数: sub,1,2
2. 模块的CalcController的index方法,接收四个参数:math,sub,1,2
3. 模块的IndexController的calc方法,接收四个参数:math,sub,1,2
4. 模块的IndexController的index方法,接收五个参数:calc,math,sub,1,2
5. 子模块`calc`的MathController的sub方法，接收二个参数: 1,2
6. 子模块`calc`的MathController的index方法，接收三个参数:sub,1,2
7. 子模块`calc`的IndexController的math方法，接受三个参数:sub,1,2
8. 子模块`calc`的IndexController的index方法，接收四个参数:math,sub,1,2

<p class="tip">
为了简单，当模块开启子模块功能后，**强烈建议**不要再为模块提供控制器了。
这样路由将简化为`5-8`步骤。
</p>

## 路由表

可以在`route.php`文件中(与模块的引导文件`bootstrap.php`在同一目录中)自定义路由:

```php
return [
    'mul.html' => [
        'template'     => 'mul.tpl',
        'expire'       => 100,
        'func'         => function ($data,$page) {
            $data['num1'] = 20 * $data['base'];

            return $data;
        },
        'Content-Type' => 'text/html',
        'session'      => true,
        'data'         => ['base' => 10]
    ],
    'math/add.do' => [
        ...
    ]
];
```

上述路由表对应的URL如下:

1. `helloworld/mul.html`
2. `helloworld/math/add.do`

在使用路由表分发器时，请注意以下限制:

1. 仅支持有扩展名的URL。
2. 不支持正则。
3. 不支持[URLGroupSupport](../mvc/supports.html#URLGroupSupport)
