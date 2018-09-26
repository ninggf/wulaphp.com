---
title: 插件(P)
type: guide
order: 21
---

`wulaphp`利用PHP语言的动态特性实现了神奇的插件(addon, plugin)机制(借鉴wordpress)，让我们**可以在不修改原有代码的前提下修改或添加功能**（绝对符合`开闭原则`）。

它有三部分组成:

1. **勾子(扩展点)**:普通的字符串，可以随意命名，是代码中需要修改或添加功能的地方。
    * 通过`fire`触发通知/事件
    * 通过`apply_filter`触发变量修改
2. **实现(处理器)**:当勾子触发时修改原有功能或添加新功能的代码。
    * 可以是普通函数(支持命名空间)
    * 可以是匿名函数
    * 可以是类的静态方法
    * 可以是类的实例方法
3. **绑定**:将**勾子(扩展点)**和**实现(处理器)**关联起来。
    * 通过`bind`函数
    * 通过模块的自动绑定功能.

## 勾子(扩展点)

勾子(扩展点)分两类:

1. 通知/事件: 不需要`实现`代码有返回值。通过`fire('勾子'[,可选参数])`触发。
2. 修改器: `实现`代码需要修改变量值并返回。通过 `$value = apply_filter('勾子',$oldvlue [,可选参数])`触发。

<p class="tip">
wulaphp框架内置了很多勾子,以便对wulaphp核心功能进行扩展,请移步至[扩展点](../../hooks.html).
</p>

## 实现与绑定

`实现(处理器)`有四种方式(绑定方式随之变化):

1. 普通函数（支持命名空间）
    ```php
    function impl1($value){
        return $value+1;
    }
    bind('filter1','impl1');//绑定
    $value = apply_filter('filter1',1);//触发
    echo $value;//$value=2
    ```
2. 匿名函数
    ```php
    bind('impl1', function ($value) {
        return $value * 2;
    });

    $value = apply_filter('impl1', 2);
    echo $value;//$value = 4
    ```
3. 实例方法
    ```php
    class Impl {
        public function abc($value,$v) {
            return $value + $v;
        }
    }
    $impl = new Impl();
    bind('impl1', [$impl, 'abc'],1,2);
    $value = apply_filter('impl1', 1,3);
    echo $value;// $value= 4
    ```
4. 静态方法
    ```php
    class Impl {
        public static function impl1($value, $v) {
            return $value + $v;
        }
    }
    bind('impl1', '&Impl', 1, 2);
    $value = apply_filter('impl1', 1, 3);
    echo $value;//$value=4
    ```
> 注意:
>
> 静态方法绑定时,勾子名即为静态方法名
>
> 模块与扩展都提供了[自动绑定](module.html#自动绑定)功能。

## 相关函数

wulaphp的插件机制对外只提供了以下函数:

1. `fire($hook[,参数...])`, 参数可选。 触发勾子。
2. `apply_filter($hook,要修改的值[,参数...])`, 参数可选。触发修改勾子。
3. `bind($hook,$impl,$priority = 10, $accepted_args = 1)`关联勾子与实现, 参数说明如下:
    * $hook: 勾子
    * $impl: 实现
    * $priority: 优先级，有多个实现时优先级数值小的先执行
    * $accepted_args: `fire`或`apply_filter`传了几个参数给实现
4. `unbind($hook, $impl, $priority = 10)`, 解绑:
    * $hook: 勾子
    * $impl: 实现
    * $priority: 优先级
5. `unbind_all($hook, $priority = false)`解绑$hook的所有实现.
    * $hook: 勾子
    * $priority: 优先级，值为false时解绑所有
6. `has_hook($hook, $function_to_check = false)`勾子是否绑定了实现.

> 如有兴趣可以看[源文件](https://github.com/ninggf/wulaphp/blob/master/includes/plugin.php)哦.