---
title: 子模块
showToc: 0
index: 1
desc: 子模块，将大业务分解小业务，每个小业务封装在一个子模块中
---

{$toc}

当你发现某个模块的功能特别，特别多的时候，你可能会想将其拆分。拆分一个模块有两种途径:

1. 拆分成不同的模块(此途径与本文档无关)
    * 不同的模块还是可以属于相同的 `urlGroup`，详见[高级路由](../advance/route.md#urlGroup)
2. 启用子模块支持。

## 启用子模块

启用子模块还是很简单的，只需要为模块类添加一个注解`@subEnabled`即可:

```php
/**
 * ...
 * @subEnabled
 */
class AbcModule extends Module {
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
  │  └─OtherClass.php          #OtherClass
  ├─hooks                      #处理器目录
  ├─sub1                       #子模块sub1
  │  ├─classes                 #子模块的类目录
  │  ├─controllers             #控制器目录
  │  │  └─IndexController.php  #默认控制器
  │  └─views                   #视图目录
  │     └─index                #IndexController的视图目录
  │        ├─index.tpl         #默认视图文件(Smarty)
  │        └─abc.php           #abc方法视图文件(php)
  ├─sub2                       #子模块sub2
  │  ├─controllers             #控制器目录
  │  └─views                   #视图目录
  ├─...                        #更多子模块
  ├─controllers                #控制器目录
  ├─views                      #视图目录
  └─bootstrap.php              #引导文件
</pre>

嗯，对的，子模块就是模块里的一个文件夹，子模块的控制器放在其`controllers`目录，视图放在`views`目录。

> 不要把处理器类放到子模块的`hooks`目录里！！

## URL路由

在模块目录后添加子模块目录名即可，详见[高级路由](../advance/route.md#submodule)。
