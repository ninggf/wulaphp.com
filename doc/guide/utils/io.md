---
title: 输入输出
showToc: 0
type: guide
index: redirect 重定向 cooke cache uuid
keywords: redirect 重定向 cooke cache uuid 输入输出 post get IO
desc: 没有输入输出的算法都不能叫算法，何况WEB应用呼
order: 602
---

没有输入输出的算法都不能叫算法，何况WEB应用呼。对于一个WEB应用来说，IO无外乎:

1. 用户通过浏览器传来的数据
    * $_GET - GET请求数据
    * $_POST - POST提交的数据
    * $_COOKIE - Cookie(小饼干，一直没明白为啥叫个小饼干)
    * $_SESSION - 会话
2. 处理用户请求生成的页面或数据
    * 页面
    * 数据

## 输入 {#req}

wulaphp是不建议你们直接通过`$_GET`、`$_POST`(更不要说`$_REQUEST`了)获取数据的。因为有什么`XSS`、`CRSF`等等攻击，详见[XSS与CRSF的比较](https://security.stackexchange.com/questions/138987/difference-between-xss-and-csrf)。
wulaphp提供了一个[Request](https://github.com/ninggf/wulaphp/blob/master/wulaphp/io/Request.php)类来清洗用户的输入。
同时也提供了几个快捷获取输入的函数:

1. `rqst($name, $default = '', $xss_clean = true)` 获取请求参数或表单值
    * $name - 参数名或表单字段名。
    * $default - 默认值,如果请求参数或表单中没有$name则使用$default。
    * $xss_clean - 是否清洗用户输入
2. `rqsts($names, $xss_clean = true, $map = [])` 一次取多个值.
    * $names -  表单中的字段名数组.
    * $xss_clean - 是否清洗用户输入
    * $map - 表单字段与结果字段的映射

    ```php
    $data = rqsts(['My.name','name','age'=>18],true,['My.name'=>'my_name']);
    // $data 值如下:
    // array('my_name'=>'your_name','name'=>'value of name','age'=>20)
    // 如果没传age那么$data中的age的值为18
    ```

3. `arg($name, $default = '')` 同`rqst`，只是`$xss_clean=false`。
4. `rqset($name)` 请求或表单中是否有字段$name。
5. `irqst($name, $default = 0)` 取整数
6. `frqst($name, $default = 0)` 取浮点数
7. `sess_get($name, $default = "")` 从SESSION中取值,如果未设置,则返回默认值 $default。
    * $name - 值名
    * $default - 默认值
8. `sess_del($name, $default = '')` 从SESSION中删除变量$name,并将该变量值返回.

原谅我，小饼干的值还得通过`$_COOKIE`直接获取，但是可以放心使用，wulaphp已经通过Request清洗过它了。

```php
$uuid = $_COOKIE['uuid'];
```

wulaphp还提供了一些很好用的函数，可以传送至[公共函数库](common.md)).

## 输出 {#res}

见[Response](https://github.com/ninggf/wulaphp/blob/master/wulaphp/io/Response.php)。有六个方法需要在此特别说明:

1. `Response::redirect($location, $args = "", $status = 302)` 跳转到$location:
    * $location - 要跳转的地址
    * $args - 参数（可以是数组）
    * $status - 跳转时响应给服务器的状态码，默认是302.
2. `Response::respond($status=404,$message='')` 输出响应码与消息:
    * $status - 状态码
    * $message - 提示消息

    ```php
    Response::respond(403,'你没权限这个么干');
    ```

3. `Response::cookie($name, $value = null, $expire = null, $path = null, $domain = null, $security = null)` 设置小饼干:
    * $name - 饼干名称
    * $value - 值
    * $expire - 过期时间
    * $path - 路径
    * $domain - 域名
    * $security - 启用安全
4. `close($exit=true)` 关闭响应，如果`$exit`为`true`那么将直接调用`exit()`结束运行。
5. `Response::cache($expire = 3600, $last_modify = null)` 设置缓存响应头:
    * $expire - 缓存时间，单位秒
    * $last_modify - 最后修改时间（unix时间戳）
6. `Response::nocache()` 禁用浏览器缓存.
