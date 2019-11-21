---
title: 插件
showToc: 0
index: 1
keywords: wulaphp 插件 plugin
desc: 插件机制:开闭原则的最佳应用
---

{$toc}

## 概述 {#intro}

想像一下，你现在正负责一个系统的运营活动模块，这个模块会提供很多任务供用户参与，比如:

1. 注册就给大礼包
2. 邀请1个好友给ZZ奖励
3. 邀请5个好友给AA奖励
4. 连续签到7天给XX奖励
5. 连续签到15天给YY奖励

你怎么实现上边的5个活动？如果某一天运营人员为了拉新又出了一个新活动:**被邀请人连续签到3天送邀请人10无现金红包**，
这时你又怎么办？

`wulaphp`通过PHP语言的动态特性实现了神奇的插件(addon, plugin)机制(借鉴wordpress)，让我们**可以在不修改原有代码的前提下修改原有功能或添加新的功能**（绝对符合`开闭原则`）来解决上述问题。

插件系统有三部分组成:

1. **勾子(事件)**:普通的字符串，是代码中预留的供修改或添加功能的地方。
    * 通过`fire`触发勾子(事件)
    * 通过`apply_filter`触发变量修改勾子(事件)
2. **处理器**:当勾子(事件)触发时修改原有功能或添加新功能的代码。
    * 可以是普通函数(支持命名空间)
    * 可以是匿名函数
    * 可以是类的静态方法
    * 可以是类的实例方法
3. **绑定**:将**勾子(事件)**和**处理器**关联起来。
    * 通过`bind`函数
    * 通过延迟自动绑定机制

有了插件机制，我们可以在用户注册成功后触发**注册成功勾子(事件)**，在用户签到成功后触发**签到成功勾子(事件)**，为每个活动编写相应的。

## 触发勾子(事件) {#fire}

勾子(事件)分两类:

1. 通知/事件: 不需要`监听(处理器)`代码有返回值
   * 通过`fire('勾子'[,可选参数])`触发
2. 修改器: `监听(处理器)`代码需要修改变量值并返回
   * 通过 `$value = apply_filter('勾子',$oldvlue [,可选参数])`触发

<p class="tip" markdown=1>
框架内置了很多勾子,以便对框架核心功能进行扩展,请移步至[Hooks](../hooks.md)了解它们。
</p>

## 绑定处理器 {#bind}

将`处理器`绑定到`勾子(事件)`有四种主动绑定方式和[懒绑定](#lazy)方式。

### 主动绑定 {#manual}

需要主动调用`bind`函数将处理器与勾子(事件)绑定且`bind`必须在`fire`或`apply_filter`之前调用，处理器才会启作用。

`bind`函数原型为:`bind($hook,$impl,$priority = 10, $accepted_args = 1)`, 参数说明如下:

* $hook: 勾子(事件)
* $impl: 实现
* $priority: 优先级，有多个实现时优先级数值小的先执行
* $accepted_args: `fire`或`apply_filter`传了几个参数给实现

#### 普通函数 {#func}

```php
function impl1($value){
    return $value+1;
}
bind('filter1','impl1');//绑定
```

#### 匿名函数 {#anon}

```php
bind('impl1', function ($value) {
    return $value * 2;
});
```

#### 实例方法 {#ins}

```php
class Impl {
    public function abc($value,$v) {
        return $value + $v;
    }
}
$impl = new Impl();
bind('impl1', [$impl, 'abc'],1,2);
```

#### 静态方法 {#static}

勾子名即为静态方法名,只有勾子名符合PHP的函数命名规则时可用。

```php
class Impl {
    public static function impl1($value, $v) {
        return $value + $v;
    }
}
bind('impl1', '&Impl', 1, 2);
```

### 懒绑定 {#lazy}

当勾子名满足`#^[\w][\w\d/\\_\.\-]+$#i`表达式时(由以字母开头，包括字母数字.-_/\字符组成的字符)，处理器可以被懒绑定，不需要手动调用`bind`函数。
为了实现懒绑定，处理器必须是一个继承自[Handler](#handler)或[Alter](#alter)类的子类且按约定放在**模块或扩展的`hooks`目录中**。如下述勾子对应的处理器类如下(**假设app模块提供这些处理器**):

1. impl1 => `app\hooks\Impl1`
2. math.add => `app\hooks\MathAdd`
3. abc\impl1 => `app\hooks\abc\Impl1`
4. abc/impl1 => `app\hooks\abc\Impl1`
5. passport\user.login => `app\hooks\passport\UserLogin`
6. passport\user-login => `app\hooks\passport\UserLogin`
7. passport\user_login => `app\hooks\passport\UserLogin`

勾子映射到处理器类的规则是:

1. `/\` 变为命名空间
2. `-_.` 变为驼峰大写

#### Handler {#handler}

继承自[Handler](/api/hook/Handler.html)的处理器处理`fire`触发的勾子(事件)，实现其`handle(...$args)`方法即可，不需要返回值，如:

```php
class MyHandler extends Handler {
    protected $acceptArgs = 0;  // 参数个数
    protected $priority   = 10; // 优先级
    public function handle(...$args){
        //TODO 处理器代码
    }
}
```

如果处理器需要接收参数请修改`$acceptArgs`属性，通过`$priority`调整处理器优先级。

#### Alter {#alter}

继承自[Alter](/api/hook/Alter.html)的处理器处理`apply_filter`触发的勾子(事件)，实现其`alter($value,...$args)`方法并返回修改后的`$value`，如:

```php
class MyAlter extends Alter {
    protected $acceptArgs = 2;
    protected $priority   = 10;

     public function alter($value, ...$args){
         return $value + $args[0];
     }
}
```

如果处理器需要接收参数请修改`$acceptArgs`属性，通过`$priority`调整处理器优先级。

## 相关函数 {#more}

如果你需要更高级的插件应用，可以使用以下相关函数:

1. `fire($hook[,参数...])`, 参数可选。 触发勾子。
2. `apply_filter($hook,要修改的值[,参数...])`, 参数可选。触发修改勾子。
3. `bind($hook,$impl,$priority = 10, $accepted_args = 1)`关联勾子与实现, 参数说明如下:
    * $hook: 勾子
    * $impl: 实现
    * $priority: 优先级，有多个实现时优先级数值小的先执行
    * $accepted_args: `fire`或`apply_filter`传了几个参数给实现
4. `unbind($hook, $impl, $priority = 10)`, 解绑:
    * $hook: 勾子
    * $impl: 实现
    * $priority: 优先级
5. `unbind_all($hook, $priority = false)`解绑$hook的所有实现.
    * $hook: 勾子
    * $priority: 优先级，值为false时解绑所有
6. `has_hook($hook, $function_to_check = false)`勾子是否绑定了实现.
