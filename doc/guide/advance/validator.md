---
title: 数据校验
showToc: 0
index: 数据 校验
keywords: 数据 校验 Validator 参数校验 内置校验规则
type: guide
desc: 通过数据校验器，保证数据安全
---

{$toc}

『不要相信任何人』，特别是对于要『保存』到数据库的数据更要进行校验。所以保存数据到数据库之前必须对数据进行校验以使其符合业务要求。

## Validator

wulaphp提供了一个[Validator](https://github.com/ninggf/wulaphp/blob/master/wulaphp/validator/Validator.php)，它是一个PHP的[Trait](http://php.net/manual/zh/language.oop5.traits.php)。
[Table](../db/model.md)的子类(模型)使用它之后，那么调用`Table`的`insert`, `inserts`, `update`方法时就会自动对数据根据设定的规则进行校验；
[Params](https://github.com/ninggf/wulaphp/blob/master/wulaphp/util/Params.php)的子类使用它，就可以方便的获取合法的参数（数据）。

## 简单示例 {#simple}

上代码(以`UserTable`为例):

```php
class UserTable extends \wulaphp\db\Table {
    use \wulaphp\validator\Validator;
    /**
    * @required 这个字段是必须的
    */
    public $username;
    /**
    * @minlength (6) => 怎么着也要有6个字符吧
    */
    public $nickname;
    /**
    * @phone
    */
    public $phone;
    /**
    * @email 正确的邮箱来一个
    */
    public $email;
    /**
    * @passwd (3) => 密码强度不够哦
    */
    public $hash;

    public function addUser($user) {
        return $this->insert($user);
    }

    public function updateUser($user, $id) {
        return $this->update($user, $id);
    }
}
```

新增和修改用户示例:

```php
$userTable = new UserTable();
try {
    $uid = $userTable->addUser(['nickname' => 'abc', 'hash' => '123321', 'email' => 'aaaa']);
} catch (\wulaphp\validator\ValidateException $ve) {
    echo "<pre>";
    print_r($ve->getErrors());
    echo "</pre>";
}

try {
    $uid = $userTable->updateUser(['nickname' => 'abc', 'hash' => '123321', 'email' => 'aaaa'], 1);
} catch (\wulaphp\validator\ValidateException $ve) {
    echo "<pre>";
    print_r($ve->getErrors());
    echo "</pre>";
}
```

执行上边的代码你将得到下边的结果:

<pre>
Array
(
    [username] => 这个字段是必须的
    [nickname] => 怎么着也要有6个字符吧
    [email] => 正确的邮箱来一个
    [hash] => 密码强度不够哦
)
Array
(
    [nickname] => 怎么着也要有6个字符吧
    [email] => 正确的邮箱来一个
    [hash] => 密码强度不够哦
)
</pre>

> **重点来了**
>
> 请想一想为什么结果不一样呢？那是因为:
>
> 1. 新增时以定义的字段进行校验
> 2. 修改时以要修改的字段进行校验

## 校验规则 {#rule}

Validator通过注解方式来定义校验规则。注解格式有四种:

1. 无参数且使用默认提示的注解: `@校验规则`
2. 无参数且自定义提示的注解: `@校验规则 提示`
3. 有参数且使用默认提示的注解: `@校验规则 (参数)`
4. 有参数且自定义提示的注解: `@校验规则 (参数) => 提示`

### 内置检验规则

|注解|说明|参数详解|参数可省畋|
|---|---|---|:---:|
|required|非空字段|依赖的字段（多个以逗号分隔），当依赖字段全为空时此规则不起作用|是|
|equalTo|和另一个字段相等|字段名|否|
|notEqualTo|不等于别一个字段|字段名|否|
|num|数字|无||
|number|同`num`|无||
|digits|整数|无||
|min|最小值|数值|否|
|max|最大值|数值|否|
|range|取值范围|最小值,最大值|否|
|phone|手机号|无||
|minlength|最小长度|数值|否|
|maxlength|最大长度|数值|否|
|rangelength|长度范围|最小值,最大值|否|
|callback|自定义校验方法|方法名([字段[,字段]])|否|
|pattern|正则|正则表达式|否|
|email|邮箱|无||
|url|URL|无||
|ip|IP地址|无||
|ipv6|IP6地址|无||
|date|日期|分隔符|是|
|datetime|分隔符|格式|是|
|step|按指定步长增减|步长|否|
|rangeWords|单词个数范围|最小值,最大值|否|
|minWords|最少单词数|数值|否|
|maxWords|最大单词数|数值|否|
|require_from_group|组内至少有N个字段不为空|2,组名,字段1,字段2|否|
|passwd|密码强度|强度值:1,2,3|是|

## 动态规则 {#drule}

除了通过注解方式配置校验规则，还可以通过Validator提供的`addRule`和`removeRule`来动态管理规则.

### addRule

添加校验规则，声明如下:

```php
/**
 * 添加验证规则.
 *
 * @param string  $field
 * @param array   $rules
 * @param boolean $multiple
 */
public final function addRule($field, array $rules, $multiple = false)
```

参数说明:

1. $field: 要校验的字段
2. $rules: 规则数组，支持多种格式:
    * ['校验规则','参数','提示',$multiple]
    * '校验规则 (参数)'=> '提示'
    * '检验规则 (参数)'
3. $multiple: 字段是否会出现多次

示例:

为上例中手机号字段添加『必填』校验规则:

```php
$userTable->addRule('phone', ['required' => '请填写手机号']);
```

### removeRule

删除校验规则，声明如下:

```php
/**
 * 删除验证规则.
 *
 * @param string      $field
 * @param string|null $rule
 */
public final function removeRule($field, $rule = null) 
```

参数说明:

1. $field:字段
2. $rule: 要删除的规则，不指定时删除字段所有校验规则。

## Params

通过`Params`类的`getParams`方法可以快速地获取到合法的数据（可以用于任何地方），比如获取用户登录时通过表单提交的数据，在做验证之前我们希望验证用户提交的数据是合法的，我们可以这么干(新建`wwwroot/params_test.php`):

```php
<?php
define('WWWROOT', __DIR__ . DIRECTORY_SEPARATOR);
include WWWROOT . '../bootstrap.php';

class UserLoginData extends \wulaphp\util\Params {
    /**
    * @required
    */
    public $username;
    /**
    * @required (username)
    * @minlength (6)
    */
    public $passwd;
    /**
    * @minlength (4)
    */
    public $captach;
}

$data = new UserLoginData(true);

$data = $data->getParams($errors);
if ($errors) {
    var_dump($errors);
} else {
    var_dump($data);
}
```

通过浏览器测试一下吧。

## 手动校验 {#manual}

上边演示的都是自动校验，接下来演示Validator的`validate`方法,接上例:

```php
$userLogindata    = new UserLoginData();
$data['username'] = 'leo';
$data['passwd']   = '111';
try {
    $userLogindata->validate($data);
    var_dump($data);
} catch (\wulaphp\validator\ValidateException $e) {
    var_dump($e->getErrors());
}
```

如果你愿意再写一遍校验规则，那么请为`validate`方法提供第二个参数就行了，参数具体格式参见[addRule](#addRule):

```php
$userLogindata->validate($data,['username'=>[...]]);
```
