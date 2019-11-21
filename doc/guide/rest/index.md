---
title: API 开发
showToc: 0
index: api
keywords: API RESTFul 接口开发 快速接口开发 API名称 API文档 文档生成
desc: 1分钟实现自己的RESTFul风格的接口开发，尽享文档生成便利
---

{$toc}

## 概述 {#intro}

基于`RESTFulServer`类的所见即所得的API机制(详见[服务端开发](server.md))。开发人员只需要按约定编写代码与注释即可完成API的开发与文档的编写。

## API名称约定 {#name}

以API`helloworld.greeting.sayHello`为例。API名称被`.`分成了三段：

* 第一段:`helloworld`, 模块的命名空间,表示此API属于`helloworld`模块.
* 第二段:`greeting`, API是由`GreetingApi`类实现的.
* 第三段:`sayHello`, `GreetingApi`类的`sayHello`方法即API的具体实现.

## 代码实现 {#code}

每个API类都是`\wulaphp\restful\API`类的子类且都有版本号约RESTFul定版本号为正整数。API实现类文件存放在`api`目录下对应的版本目录中.

以API`helloworld.greeting.sayHello`开发为例:

1. 在__helloworld__模块目录(一般为`helloworld`)下新建目录`api`(与`controllers`同级):

    <pre>
    helloworld
    |-- api
    |-- controllers
    </pre>

2. 根据约定在`api`目录下新建文件`v1/GreetingApi.php`:

    <pre>
    helloworld
    |-- api
        |-- v1
            |-- GreetingApi.php
    </pre>

    > * `v1` 目录即1版本API类存放目录.
    > * `GreetingApi.php` 即API类.
3. 在`GreetingApi.php`定义`GreetingApi`类并实现sayHello方法:

    ```php
    namespace helloworld\api\v1;

    use rest\classes\API;

    /**
     * @name 打招呼
     */
    class GreetingApi extends API {
        /**
         * 打招呼
         *
         * @apiName 打招呼
         *
         * @param string $name (required) 姓名
         *
         * @return array {
         *      "hello":"姓名"
         * }
         */
        public function sayHello($name) {
            return ['hello' => $name];
        }
    }
    ```

    > * 如需使用`POST`方法调用`helloworld.greeting.sayHello`则将类中`sayHello`方法重命名为`sayHelloPost`即可。
    > * 请注意此类的命名空间，切不可写错喽。

### setup 与 tearDown {#setup}

可以通过重写`API::setup`与`API::tearDown`方法为接口类里的所有接口准备/释放数据、资源。`setup`方法会在接口调用前被调用，`tearDown`方法会在接口执行完后被调用。

如果`setup`抛出了异常那么接口不会被调用:

1. `HttpException`: 响应http状态。
2. `UnauthorizedException`: 响应http 401状态，表明需要用户登录,可通过`$this->unauthorized()`直接抛出。
3. `RestException`: 运行时错误，可通过`$this->error()`直接抛出。
4. `PDOException`: 数据库异常。
5. `Exception`: 内部错误。

以上异常不仅可以在`setup`方法中抛出，也可以在接口中抛出。不要在`tearDown`方法中抛出异常。

## 文档生成 {#ann}

`ApiDoc:doc`方法可以通过方法的`doc comment`中的注解自动生成API文档, 只要注解遵守以下的规定:

|注释|位置|唯一|示例|说明|
|---|:---:|:---:|---|---|
|name|类|是|@name 会话管理|API实现类名|
|apiName|方法|是|@apiName 开启会话|API名称|
|session|方法|是|@session|API需要SESSION支持|
|param|方法|否|@param string $name 姓名|参数定义，支持多种格式，详见下文|
|paramo|方法|否|@paramo string abc 输出数据描述|输出数据定义，支持多种格式，详见下文|
|error|方法|否|@error 200 => 出错啦|定义此API可能出现的错误信息|
|return|方法|是|@return array {"id":"用户ID"}|返回信息定义，必须是合法的JSON格式|

> `return` 注解格式为`@return array {合法的返回值示例JSON}`

**param输入参数注解格式：**

1. `@param string $name` 只定义参数名与类型
2. `@param string $name 姓名` 定义参数名，类型与描述
3. `@param string $name (required) 姓名` 定义参数名，类型，描述且说明此参数必须
4. `@param object $info (sample={"age":"int","name":"string"}) 信息` 定义参数名，类型，描述，且给出示例值
5. `@param object $info (required,sample={}) 信息` 参数名，类型，描述，必须且出给示例值
    * 当参数类型为`object`时，`sample`(示例值)必须提供.

**paramo输出数据注解格式：**

1. `@paramo string name` 只定义数据名与类型
2. `@paramo string .key` 表示`key`是它一条数据的子项数据，用于Object类型的输出.

### 扫描所有API {#scan}

调用`ApiDoc::scan`获取所有API数据:

```php
$apis = ApiDoc::scan();
```

返回值是一个多级关联数组(array),说明:

1. 一级模块列表
   1. `id`: ID
   2. `title`: 模块名
   3. `children`: 二级版本列表
2. 二级版本列表
   1. `id`: ID
   2. `title`: 版本名
   3. `children`: 三级接口类列表
3. 三级接口类列表
   1. `id`: ID
   2. `title`: 接口类名称
   3. `children`: 四级接口列表
4. 四级接口列表
   1. `id`: ID
   2. `api`: API
   3. `title`: API名称
   4. `ver`: 版本
   5. `method`: 请求方法(get,post,put,delete)

### 获取文档 {#doc}

调用`ApiDoc::view`获取指定API的文档:

```php
$doc = ApiDoc::view('helloworld.greeting.sayHello','1');
```

返回值`$doc`是一个关联数组(array),说明如下:

1. `document`: 接口说明,Markdown字符串
2. `params`: 接口参数,Markdown字符串
3. `paramos`: 响应数据,Markdown字符串
4. `errors`: 错误代码,Markdown字符串
5. `return`: 响应示例,Markdown字符串
