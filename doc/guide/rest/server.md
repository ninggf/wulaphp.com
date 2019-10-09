---
title: 服务端开发
showToc: 0
index: 1
---

{$toc}

## 概述 {#intro}

利用框架提供的`RESTFulServer`可以很方便地开发符合**RESTFul**风格的接口服务器。服务器端需要一些公共参数来完成工作,也就是
调用任何一个API都必须传入的参数，目前支持的公共参数有：

| 参数名称    | 参数类型 | 是否必须 | 参数描述                                                                                                         |
| ----------- | :------: | :------: | ---------------------------------------------------------------------------------------------------------------- |
| api         |  String  |    Y     | API接口名称                                                                                                      |
| app_key     |  String  |    Y     | 分配给客户端的AppKey                                                                                             |
| session     |  String  |    N     | 系统颁发给应用的会话信息，API标记有`SESSION`时此参数必填                                                         |
| timestamp   |  String  |    Y     | 时间戳，格式为yyyy-MM-dd HH:mm:ss GMT+8,例如:2017-01-01 12:00:00。RESTFul服务端允许客户端请求最大时间误差为5分钟 |
| format      |  String  |    N     | 响应格式，默认为json格式,可选值:json,xml                                                                         |
| v           |   Int    |    Y     | API版本                                                                                                          |
| sign_method |  String  |    Y     | 签名的摘要算法，可选值为：hmac，md5，sha1                                                                        |
| sign        |  String  |    Y     | API输入参数签名结果，签名算法参照下面的介绍。                                                                    |

<p class="tip" markdown=1>
`app_key`参数相当重要，密钥校验器需要通过它获取相应的密钥并传给签名器使用。在实践中与`app_key`相伴的还有`app_secret`，客户端需要通过`app_secret`对请求的参数进行签名，服务端需要通过与`app_key`配对的`app_secret`校验参数的签名。
</p>

开发一个接口服务器基本步骤如下:

1. 创建一个接口模块，模块名随便取，比如`api`，`rest`之类的
2. 定义密钥检验器以保证请求的合法性
3. 定义签名器以保证数据传输过程中未被篡改
4. 在接口模块中创建入口控制器，建议使用默认控制器:`IndexController`
5. 在入口控制器的默认方法(`index`)中使用自定义的密钥检验器和签名器实例化`RESTFulServer`并调用其`run`方法
6. 按约定编写API代码
7. 如有需要可以通过勾子(事件)监测API调用

本文通过一个简单的实例来演示接口服务器的开发。

## 接口模块 {#module}

本实例中使用的接口模块是`api`，通过命令`php artisan create module api`创建或手工创建。更多关于模块的内容请传送至[模块](../module/index.md#create)。

## 密钥检验器 {#app}

密钥检验器是一个实现`\wulaphp\restful\ISecretCheck`接口的类，只需实现`check(string $app_key)`检验客户端传过来的`app_key`是否合法，如果`app_key`是合法的那么需要返回一个与之配对的`app_secret`供签名器校验参数签名用即可。本例中使用最简单的密钥检验器(`api\classes\SecretChecker`)如下:

```php
namespace api\classes;

use wulaphp\restful\ISecretCheck;

class SecretChecker implements ISecretCheck {
    public function check(string $app_key): string {
        return $app_key=='abc123456789'?'987654321cba.aaa.bbb':'';
    }
}
```

此例中，固定死`app_key`为**abc123456789**，与之匹配的`app_secret`是**987654321cba.aaa.bbb**。

现实中的密钥检验器不会这么简单，怎么着也得从数据库或其它什么地方读取吧。对`app_key`与`app_secret`进行合理的管理还是很有必要的。

## 签名器 {#sign}

签名器的主要作用是请求参数进行签名以防止数据传输过程中被篡改，签名器是一个实现`\wulaphp\restful\ISignCheck`接口的类，只需要实现`sign(array $args, string $appSecret, string $type = 'sha1', bool $server = false)`方法对请求参数进行签名并返回签名即可。框架提供了一个默认的签名器:[DefaultSignChecker](#dsign)，如果有特殊需要可以像下边这样实现自己的签名器:

```php
class MySignChecker implements ISignCheck {
    public function sign(array $args,
                         string $app_secret,
                         string $type = 'sha1',
                         bool $server = false): string{
        // 对参数进行签名。
    }
```

参数:

1. `$args`: 请求参数
2. `$app_secret`: 密钥
3. `$type`: 签名方法
4. `$server`: 是否是服务端签名

本实例中使用默认的`DefaultSignChecker`。

### DefaultSignChecker

`DefaultSignChecker`目前支持的签名算法有三种：MD5(sign_method=md5)，HMAC_MD5(sign_method=hmac), SHA1(sign_method=sha1)，签名大体过程如下：

* 对所有API请求参数（包括公共参数和业务参数，但除去sign参数），根据参数名称的ASCII码表的顺序排序。如：foo=1, bar=2, foo_bar=3, foobar=4排序后的顺序是bar=2, foo=1, foo_bar=3, foobar=4。

    1. 如果参数对应的是文件，则取文件的sha1摘要进行签名，如: file参数是文件，转换后为file=SHA1(file的内容)
    2. 如果参数是数组，则需将参数进行如下转换: arg[0]=1,arg[1]=2
    3. 如果参数是关联数组(map)，则需要对其进行按key按ASCII码表的顺序排序后按数组的方式处理。

* 将排序好的参数名和参数值拼装在一起，根据上面的示例得到的结果为：bar2foo1foo_bar3foobar4
* 把拼装好的字符串采用utf-8编码，使用签名算法对编码后的字节流进行摘要。如果使用MD5或SHA1算法，则需要在拼装的字符串前后加上app的secret后，再进行摘要，如：md5(bar2foo1foo_bar3foobar4+secret)；如果使用HMAC_MD5算法，则需要用app的secret初始化摘要算法后，再进行摘要，如：hmac_md5(bar2foo1foo_bar3foobar4)。
* 将摘要得到的字节流结果使用十六进制表示，如：hex(“helloworld”.getBytes(“utf-8”)) = “68656C6C6F776F726C64”

> 说明：MD5和HMAC_MD5都是128位长度的摘要算法，用16进制表示，一个十六进制的字符能表示4个位，所以签名后的字符串长度固定为32个十六进制字符。

## 入口控制器 {#controller}

将`IndexController`修改为如下内容:

```php
namespace api\controllers;

use wulaphp\mvc\controller\Controller;
use wulaphp\restful\DefaultSignChecker;
use wulaphp\restful\RESTFulServer;

use api\classes\SecretChecker;

class IndexController extends Controller {
    public function index() {
        $debug  = false;
        $sign   = new DefaultSignChecker();
        $server = new RESTFulServer(new SecretChecker(), $sign);

        return $server->run($debug);
    }
}
```

`RESTFulServer`的构造函数的参数说明如下:

1. `$secretChecker`:  密钥校验器。
2. `$signChecker`:    签名校验器,默认为DefaultSignChecker。
3. `$format`:         默认响应格式，支持json和xml,默认为`json`。
4. `$session_expire`: session过期时间(单位秒),默认为`300`秒。

在调用`$server->run()`方法时，如果传入了`true`，那么签名检验过程将被忽略，方便调试。

### JSON支持 {#json}

如果希望通过`json`格式向服务器端提交(`POST/PUT`)数据，请为`IndexController::index()`添加注解`@jsonBody`:

```php
class IndexController extends Controller {
    /**
     * @jsonBody
     */
    public function index() {
```

客户端提交数据时将`Content-Type`值设为`application/json`就可以了。

> 仅在请求方法为`POST`或`PUT`时可用。

到此一个简单的接口服务端就完成了，下边通过编写一个API来测试一下。

## 验证 {#usage}

### GreetingApi

API开发的具体文档请传送到[API开发](index.md)，此处只提供一个简单的示例用于演示。新建API类`api\api\v1\GreetingApi`:

```php
namespace api\api\v1;

use wulaphp\restful\API;

class HelloApi extends API {
    /**
     * 打招呼API
     *
     * @apiName Greeting
     *
     * @param string $name (required) 姓名
     *
     * @paramo  string greeting 招呼信息
     *
     * @error   5001 => 演示的错误用的
     *
     * @return array {
     *  "greeting":"Hello Leo"
     * }
     */
    public function greeting($name) {
        return ['greeting' => 'Hello ' . $name];
    }
}
```

### 客户端 {#client}

新建测试脚本`api_test.php`如下:

```php
use wulaphp\restful\RESTFulClient;

$client = new RESTFulClient('http://127.0.0.1:9090/api',
                            'abc123456789',// app_key
                            '987654321cba.aaa.bbb', // app_secret
                            '1');

$rst = $client->get('testm.hello.greeting', ['name' => 'wulaphp']);

print_r($rst->getReturn());

```

本实例使用内置[RESTFulClient](/api/restful/RESTFulClient.html)类进行接口访问，不同的语言的客户端接入，请参考[客户端接入](client.md)。

### Greeting

首先，启动PHP内置WEB SERVER:

`php artisan serve`

然后，通过`artisan`命令运行脚本`api_test.php`：

`php artisan api_test.php`

最后，得到输出:

<pre>
Array
(
    [response] => Array
        (
            [greeting] => Hello wulaphp
        )
)
</pre>

## 勾子(事件) {#hooks}

`RESTFulServer`提供了丰富的勾子(事件)以便于二次开发时监测API的调用，下表列出所有勾子(事件)：

| 勾子              | 类型 | 参数                        | 触发时机              |
| ----------------- | ---- | --------------------------- | --------------------- |
| restful\startCall | H    | 1.UNIX时间戳；2.格式        | 开始处理一个API请求时 |
| restful\callApi   | H    | 1.API；2.UNIX时间戳；3.参数 | 处理API请求时         |
| restful\endApi    | H    | 1.API；2.UNIX时间戳；3.参数 | 处理完成后            |
| restful\errApi    | H    | 1.API；2.UNIX时间戳；3.数据 | API返回错误时         |
| restful\callError | H    | 1.UNIX时间戳；2.数据        | 处理出错时            |
| restful\endCall   | H    | 1.UNIX时间戳；2.数据        | 处理结束时            |

> `H`: Handler，由`fire`触发的事件不需要返回值
