---
title: 视图
showToc: 1
index : view 视图
keywords: view 视图 mvc视图作用 smarty模板 主题视图 Theme Json视图
desc: 我有我风格，怎么优秀怎么表现,善用视图一切都是那么简单
---

## 概述

MVC的V - 视图，就是页面、JSON数据、XML、EXCEL表格、图片这些东东吧, 反正用户可以直接看到（使用）它，控制器需要返回它的实例。

<p class="tip">
如果你还不熟悉Smarty模板引擎,请在开始使用视图之前花点时间熟悉一下<a href="https://www.smarty.net/docs/zh_CN/" target="_blank">Smarty</a>
</p>

## 内置视图 {#buitin}

wulaphp内置了以下几种视图模板引擎:

1. [SmartyView](#SmartyView)
2. [ThemeView](#ThemeView)
3. [HtmlView](#HtmlView)
4. [JsonView](#JsonView)
5. [XmlView](#XmlView)
6. [ExcelView](#ExcelView)
7. [SimpleView](#SimpleView)
8. [JsView](#JsView)

### SmartyView

基于**Smarty**模板引擎的视图.主要为控制器的方法提供视图实例:

1. `view()`函数加载模板.
2. 直接`new SmartyView()`

默认输出头: `Content-Type: text/html; charset=utf-8`

详见控制器如何使用[视图](controller.md#tpl).

### ThemeView

基于**Smarty**模板引擎的视图,为wulaphp提供[主题](../theme.md)功能.

默认输出头: `Content-Type: text/html; charset=utf-8`

### HtmlView

基于**Smarty**模板引擎的视图.主要为控制器的方法提供视图实例:

1. `pview()`函数加载模板.
2. 直接`new HtmlView()`

默认输出头: `Content-Type: text/html; charset=utf-8`

详见控制器如何使用[视图](controller.md#tpl).

### JsonView

这个最简单喽,直接返回`array`即可:

```php
return ['greeting'=>'Hello World!'];
```

默认输出头: `Content-Type: application/json`

### XmlView

看代码吧:

```php
$data['books'][] = ['book' => ['@auther' => '曹雪芹', '#' => '红楼梦']];
$data['books'][] = ['book' => ['@auther' => '金庸', '#' => '笑傲江湖']];
$data['books']['@total'] = 2;

return xmlview($data,'datas');
// 或
return new XmlView($data,'datas');
```

生成的XML如下:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<datas>
    <books total="2">
        <book auther="曹雪芹">红楼梦</book>
        <book auther="金庸">笑傲江湖</book>
    </books>
</datas>
```

说明:

1. 通过`@`设置节点属性
2. 通过`#`设置节点文本(正文)

默认输出头: `Content-Type: text/xml; charset=utf-8`

### ExcelView

使用此视图前请安装**phpspreadsheet**: `composer require phpoffice/phpspreadsheet`,然后:

1. 制作Excel模板文件
2. 按行准备数据

代码大概就是这样的:

```php

$data[1] = ['A'=>'A1','B'=>'B1','E'=>'E1'];
...
$data[n] = ['A'=>'An'];

return excel('文件名',$data,'excel_tpl');
```

关键是制作好模板文件.

### SimpleView

这个也简单哦,直接返回`string`即可:

```php
return 'Hello World!';
```

默认输出头: `Content-Type: text/plain; charset=utf-8`

### JsView

你的`js`文件真的要通过控制器生成?如果是,请试试下边的代码:

```php
$js = $this->module->loadFile('your_js_file');
// 对js一顿猛操作
return new JsView($js);
```

默认输出头: `Content-Type: application/javascript; charset=utf-8`

## Smarty引擎 {#smarty}

Smarty模板引擎使用的`{}`与`Mustache`(Vuejs、Angular等库)使用的`{{mustache}}`会产生冲突,解决这个冲突的途径有:

1. 使用`mustache()`代替`view()`
2. 如果你使用`SmartyView`:

    ```php
    return new SmartyView(...)->mustache();
    ```

3. 如果你使用`ThemeView`(主题)

    ```php
    return template(...)->mustache();
    //或者
    return new ThemeView(...)->mustache();
    ```

### 变量修饰器 {#modifiers}

wulaphp为Smarty提供了几个新的[变量修饰器](../theme.md#modifiers).

### 内置函数 {#builtin}

wulaphp为Smarty提供了几个新的[内置函数](../theme.md#builtin).

## 自定义视图 {#custom}

所有视图都是[View](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/View.php)的子类，基于此你可以很随便地实现一个基于自己熟悉的模板引擎的视图。
不信我实现一个基于PHP语法的视图给你看看。

我们通过[扩展](../extension.md)机制来实现这个屌屌的视图模板引擎。

1. 在`extensions`目录创建文件`myview/PhpView.php`:

    ```php
    namespace myview;

    use wulaphp\mvc\view\View;

    class PhpView extends View {
        /**
        * 绘制
        *
        * @return string
        * @throws
        */
        public function render() {
            $tpl = MODULES_PATH . $this->tpl;
            if (is_file($tpl)) {
                extract($this->data);
                @ob_start();
                include $tpl;
                $content = @ob_get_contents();
                @ob_end_clean();

                return $content;
            } else {
                throw_exception('tpl is not found:' . $tpl);
            }
        }

        public function setHeader() {
            $this->headers['Content-Type'] = 'text/html; charset=utf-8';
        }
    }
    ```
2. 写个控制器使用它（假设是helloworld\controllers\ViewController）:

    ```php
    <?php
    namespace helloworld\controllers;

    use myview\PhpView;
    use wulaphp\mvc\controller\Controller;

    class ViewController extends Controller {
        public function index() {
            $data['name'] = 'Leo Ning';

            return new PhpView($data, 'helloworld/views/index.php');
        }
    }
    ```

3. 模板文件`helloworld/views/index.php`:

    ```php
    <html>
    <head>
        <title>ready to go</title>
    </head>
    <body>
    <h1 style="text-align: center">Hello <?php echo $name;?>!!</h1>
    </body>
    </html>
    ```

就这么简单(实现`render`就行), 它和wulaphp的[HtmlView](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/view/HtmlView.php)一模一样呢。有几点要说明：

1. wulaphp默认使用Smarty模板引擎。
    * 可以通过[勾子](../../hooks.md)来修改Smarty引擎。
2. wulaphp内置了一些视图，详见[控制器(C)](controller.md#action)文档中相关部分。

### 模板文件自加载 {#autoload}

想让`PhpView`像SmartyView和HtmlView一样自动加载`views`目录下对应的模板文件吗?简单得很,只需要让`PhpView`实现``就可以啦:

```php
use wulaphp\mvc\view\View;
use wulaphp\mvc\view\IModuleView;

class PhpView extends View implements IModuleView {
    ...
}
```

<p class="tip">
模板文件的加载会受到用户选择的语言影响，具体见<a href="../advance/i18n.md">I18N</a>国际化。
</p>

## 接下来

视图是给控制器用的，对于前端页面，wulaphp使用[主题(T)](../theme.md)来搞定。
