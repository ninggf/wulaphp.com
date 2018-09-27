---
title: 主题(T)
type: guide
order: 28
---

wulaphp之所以是wulaphp而不是其它的什么什么框架,就是因为wulaphp支持主题模板啊.

`themes`目录（如果你没通过重新定义`THEME_DIR`修改它）下的子目录就是**主题**，**主题**目录下存放的就是**主题模板**。默认情况下使用`template()`函数加载基于**Smarty**的主题模板文件。如果你愿意可以参考[视图(V)](view.html)实现基于其它模板引擎的模板文件。

<p class="tip">
如果你还不熟悉Smarty模板引擎,请在开始使用主题之前花点时间熟悉一下<a href="https://www.smarty.net/docs/zh_CN/" target="_blank">Smarty</a>。
</p>

## 目录结构

典型的主题目录结构如下：
<pre>
themes
  ├─mytheme          # mytheme主题
  │  ├─index.tpl     # 首页模板文件
  │  ├─404.tpl       # 404模板文件
  │  ├─403.tpl       # 403模板文件
  │  ├─500.tpl       # 500模板文件
  │  ├─503.tpl       # 503模板文件
  │  ├─...           # 其它模板文件
  │  └─template.php  # 主题脚本
  └─abc
     ├─index.tpl
     ├─...
     └─template.php
</pre>

`.tpl`结尾的就是Smarty模板文件啦，其中有几个模板文件是wulaphp会用到的:

1. `404.tpl` 404页面
2. `403.tpl` 403页面
3. `500.tpl` 500页面
4. `503.tpl` 503页面
5. `index.tpl`主页

### template.php

有必要详细说明一下`template.php`文件。首先这个文件不是必须的，可以没有。其次可以在此文件中定义函数来修改或添加传给Smarty模板的变量:

1. 定义`mytheme_template_data`修改所有模板变量:
    ```php
    function mytheme_template_data(&$data){
        $data['siteTitle'] = '网站名称';
    }
    ```
2. 定义特定模板数据修改函数（修改index.tpl模板数据）:
    ```php
    function mytheme_index_template_data(&$data){
        $data['pageTitle'] = '首页名称';
    }
    ```
3. 模板在子目录下的修改函数(修改abc/def.tpl模板数据):
    ```php
    function mytheme_abc_def_template_data(&$data){
        $data['pageTitle'] = '首页名称';
    }
    ```
4. 模板文件名中包括'.'的修改函数(修改ghi.jkl.tpl模板数据):
    ```php
    function mytheme_ghi_jkl_template_data(&$data){
        $data['pageTitle'] = '首页名称';
    }
    ```

通过`template()`函数加载主题模板时，`mytheme_template_data`先于`mytheme_index_template_data`调用。

## 加载主题模板

通过`template()`函数加载基于Smarty模板引擎的模板，原型如下:

```php
/**
 * 加载基于Smarty模板引擎的模板。
 * @param string $tpl
 * @param array  $data
 * @param array  $headers
 *
 * @filter get_theme $theme,$data
 * @filter get_tpl $theme,$data
 * @return \wulaphp\mvc\view\ThemeView
 * @throws
 */
function template($tpl, $data = [], $headers = ['Content-Type' => 'text/html'])
```

加载`abc.tpl`做为示例:

```php
$view = template('abc.tpl',$data);
```

如果模板中有`Mustache`语法,请记得像下边这样:

```php
$view = template('abc.tpl',$data)->mustache();
```

### 勾子与failback

1. 可以通过`get_theme`勾子来设置当前使用的**主题**。
    * `themes`目录下可以有多个主题，默认加载`default`主题下的模板。
    * 如果在指定的主题下未找到模板则到`default`主题下查找。
2. 还可以使用`get_tpl`勾子来修改要加载的模板哦。

## Smarty修饰器

Smarty里的`modifier`，wulaphp提供了以下`modifier`:

1. `app` 生成访问控制器的URL
    * 使用模块的命名空间而不是模块目录.
    * 如果对控制器进行了分组需要将分组标识加在命名空间前.
    ```html
    <a href="{'helloworld/math/add'|app}">helloworld模块MathController的add方法</a>
    <a href="{'~vip/user/lists'|app}">分组标识为'~'的vip模块的UserController的lists方法</a>
    ```
    * 模板中一定要使用`app`生成控制器的URL
2. `action` 生成访问控制器URL
    ```html
    <a href="{'vip\controllers\UserController::lists'|action}">同`1`中的第二个链接</a>
    ```
3. `media` 生成上传的多媒体文件URL(所有用户上传的文件都推荐使用media进行修改).
    ```html
    <img src="{'uploads/myadsfa.png'|media}">
    ```
4. `res` 生成模块资源URL(使用模板的命名空间)
    ```html
    <img src="{'vip/views/my.png'|res}">
    ```
5. `cdn` 生成资源URL.
6. `url` 生成基于根目录的URL.
7. `here` 生成相对模板所在目录的资源URL
    ```html
    <script src="{'js/my.js'|here}"></script>
    ```
8. `assets`,`vendor`生成`assets`目录下资源的URL
9. `media` 生成上传的图片URL（图片存储在其它地方时有用）
10. `cfg` 加载配置
11. `clean`清空所有html标签
12. `rnum`生成随机数字,见`rstr`.
13. `rstr`生成随机字符串(长度和连接符可省略)
    ```html
    <p>{'abc'|rstr:10:'-'}</p>
    <!-- 生成如下 -->
    <p>abc-AadgeqeAAD</p>
    ```
14. `render` 绘制[Renderable](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/Renderable.php)实例(比如视图View的实例)。
15. `checked`输出`checked="checked"`
    ```html
    <!-- $status = 1 -->
    <input type="radio" name="radio" value="0" {'0'|checked:$status}>关
    <input type="radio" name="radio" value="1" {'1'|checked:$status}>开
    ```
    或
    ```html
    <!-- $opts = [1,3] -->
    <input type="checkbox" name="opt[]" value="0" {'0'|checked:$opts}>选项1
    <input type="checkbox" name="opt[]" value="1" {'1'|checked:$opts}>选项2
    <input type="checkbox" name="opt[]" value="2" {'2'|checked:$opts}>选项3
    ```
16. `status`输出值对应的文本
    ```html
    <!-- $value = 2; $status = [0=>'保密',1=>'男',2=>'女'] -->
    用户的性别为:<strong>{$value|status:$status}</strong>
    ```

更多修饰器，直接看[template.php](https://github.com/ninggf/wulaphp/blob/v2.0/includes/template.php)的代码中以`smarty_modifiercompiler_`开头的函数或Smarty[内置变量修饰器](https://www.smarty.net/docs/zh_CN/language.modifiers.tpl).

## Smarty内置函数

Smarty很好扩展的，简单的定义一个类就可以实现一个,wulaphp提供了一些内置函数来简化主题模板中数据获取，分页处理，数据分隔等操作，详见[Smarty扩展](../advance/smarty.funcs.html)。
