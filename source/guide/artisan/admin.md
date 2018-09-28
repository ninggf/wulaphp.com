---
title: 管理命令
type: guide
order: 701
---

运行`php artisan admin`：

<pre>
administrate tool for wulaphp

Usage: #php artisan admin &lt;command&gt;

Options:
  -h, --help        display this help message
  -v                display wulaphp version

Commands:
  create-module     Create standard module structure
  create-ext        Create standard extension structure
  module            manage module of wulaphp

Run '#php artisan admin &lt;command&gt; --help' for more information on a command
</pre>

wulaphp提供的简管理命令，很简单，无需多说，自行尝试。

## 自定义管理命令

可以像[自定义命令](index.html#自定义命令)一样简单地自定义管理命令，
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
  create-module     Create standard module structure
  create-ext        Create standard extension structure
  module            manage module of wulaphp

Run '#php artisan admin &lt;command&gt; --help' for more information on a command
</pre>

就是这样的简单。