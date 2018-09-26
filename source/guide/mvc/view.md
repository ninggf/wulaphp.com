---
title: 视图(V)
type: guide
order: 26
---

MVC的V - 视图，就是页面、JSON数据、XML、EXCEL表格、图片这些东东吧, 反正用户可以直接看到（使用）它，控制器需要返回它的实例。
所有视图都是[View](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/View.php)的子类，基于此你可以很随便地实现一个基于用自己熟悉的模板引擎的视图。
不信我实现一个基于PHP语法的视图给你看看。

## 自定义视图

我们通过[扩展(E)](extension.html)机制来实现这个屌屌的视图模板引擎。

1. 在`extensions`目录创建文件`myview/PhpView.php`:
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
2. 写个控制器使用它（假设是helloworld\controllers\ViewController）:
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
3. 模板文件`helloworld/views/index.php`:
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

就这么简单(实现`render`就行), 它和wulaphp的[HtmlView](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/mvc/view/HtmlView.php)一模一样呢。有几点要说明：

1. wulaphp默认使用Smarty模板引擎。
    * 可以通过[勾子](../../hooks.html)来修改Smarty引擎。
2. wulaphp内置了一些视图，详见[控制器(C)](controller.html#方法-Action)文档中相关部分。

### 模板文件自加载

想让`PhpView`像SmartyView和HtmlView一样自动加载`views`目录下对应的模板文件吗?简单得很,只需要让`PhpView`实现``就可以啦:

```php
use wulaphp\mvc\view\View;
use wulaphp\mvc\view\IModuleView;

class PhpView extends View implements IModuleView {
    ...
}
```

## 接下来

视图是给控制器用的，对于前端页面，wulaphp使用[主题(T)](theme.html)来搞定。