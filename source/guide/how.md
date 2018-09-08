---
title: 原理
type: guide
order: 4
---

{% blockquote 古人 , 中国的 %}
知其然，知其所以然。
{% endblockquote %}

知道wula.php是如何工作的对你有极大的帮助。如果有些东西你现在不能理解，不要灰心。从简单的东西入手，慢慢的你就啥都会了。

<p class="tip">
加QQ群找群主:<a target="_blank" href="http://shang.qq.com/wpa/qunwpa?idkey=9be37f660c70dd33c22f6055cd113215a52e9cab29d46b5c02fe2f68c67a0f17">371487281</a>
</p>

## 引导文件

wula.php通过[bootstrap.php](index.html#bootstrap.php)将自己拉起来:

1. 定义目录，常量，公用函数，类加载，错误处理，缓冲区管理等等
2. 加载公用类库
3. 加载[配置](config.html)
4. 加载[扩展](ext.html)
5. 加载[模块](module.html)

无论你在写命令行应用还是写基于HTTP协议的应用(通俗的叫法是『网站』)都应在入口文件里`include`或`require`它。就像`wwwroot/index.php`这样:

```php wwwroot/index.php
<?php
use wulaphp\app\App;

define('WWWROOT', __DIR__ . DIRECTORY_SEPARATOR);
include WWWROOT . '../bootstrap.php';
App::run();//分发请求
```

或者像`artisan`命令程序这样:

```php artisan
#!/usr/bin/env php
<?php
/**
 * 此处省略大段代码...
 */
include __DIR__ . '/bootstrap.php';
@ob_end_clean();
/**
 * 此处省略大段代码...
 */
```

> 鼓励你阅读bootstrap.php与vender/wula/wulaphp/bootstrap.php的源文件获取更多信息.

## Web应用

编写中...

## 命令行应用

<p class="tip">如果你想通过命令行访问Controller里的Action，请使用`curl`或`wget`。</p>

编写中...