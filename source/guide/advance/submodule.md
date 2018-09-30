---
title: 子模块
type: guide
order: 1000
catalog: 高级
---

当你发现某个模块的功能特别，特别多的时候，你可能会想将其拆分。拆分一个模块有两种途径:

1. 拆分成不同的模块(此途径与本文档无关)
    * 不同的模块还是可以属于相同的 `urlGroup`，详见[高级路由](route.html#urlGroup)。
2. 启用子模块支持。

## 启用子模块

启用子模块还是很简单的，只需要:

1. 为模块引导文件中模块类添加一个注解`@subEnabled`:
    ```php
    /**
     * ...
     * @subEnabled
     */
    class AbcModule extends Module
    ```
2. 修改模块引导文件中模块类，添加`hasSubModule()`并返回`true`:
    ```php
    class AbcModule extends Module {
        ....
        public function hasSubModule(){
            return true;
        }
    }
    ```

## 目录结构

启用子模块后，模块的目录结构发生了一点点变化，具体如下:

<pre>
helloword
  ├─assets                     #静态资源目录
  ├─lang                       #I18N语言目录
  │  ├─en.php                  #English
  │  ├─zh-CN.php               #简体中文
  │  └─zh.php                  #所有中文
  ├─classes                    #类目录
  │  ├─ClassOne.php            #ClassOne类
  │  └─OtherClass.php          #OtherClass
  ├─sub1                       #子模块sub1
  │  ├─classes                 #子模块的类目录
  │  ├─controllers             #控制器目录
  │  │  └─IndexController.php  #默认控制器
  │  └─views                   #视图目录
  │     └─index                #IndexController的视图目录
  │        ├─index.tpl         #默认视图文件(Smarty)
  │        └─abc.php           #abc方法视图文件(php)
  ├─sub2                       #子模块sub2
  │  ├─controllers             #控制器目录
  │  └─views                   #视图目录
  ├─...                        #更多子模块
  ├─controllers                #控制器目录
  ├─views                      #视图目录
  └─bootstrap.php              #引导文件
</pre>

嗯，对的，子模块就是一个文件夹，子模块的控制器放在其`controllers`目录，视图放在...。

其它方面就和[模块](../mvc/module.html)一样啦。

### URL