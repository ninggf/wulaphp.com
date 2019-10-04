---
title: 管理命令
showToc: 0
index: admin artisan
desc: 简单的管理命令
---

运行`php artisan admin`

<pre>
administrate tool for wulaphp

Usage: #php artisan admin &lt;command&gt;

Options:
  -h, --help        display this help message
  -v                display wulaphp version

Commands:
  module         manage module of wulaphp
  router         diplay registered dispatcher and routes
  hook           print hooks and its handlers

Run '#php artisan admin &lt;command&gt; --help' for more information on a command
</pre>

wulaphp提供的简管理命令，很简单，无需多说，自行尝试。

## 自定义管理命令 {#custom}

可以像[自定义命令](index.md#custom)一样简单地自定义管理命令，
首先你要先有一个命令:

```php
class MyAdminCommand extends ArtisanCommand{
    .....
}
```

然后注册它:

```php
bind('artisan\init_admin_command',function($cmds) {
    $cmds[] = new MyAdminCommand();
    return $cmds;
});
```

然后运行`php artisan admin`:
<pre>
administrate tool for wulaphp

Usage: #php artisan admin &lt;command&gt;

Options:
  -h, --help        display this help message
  -v                display wulaphp version

Commands:
  mycmd             my command
  module            manage module of wulaphp
  router            diplay registered dispatcher and routes
  hook              print hooks and its handlers

Run '#php artisan admin &lt;command&gt; --help' for more information on a command
</pre>

就是这样的简单。
