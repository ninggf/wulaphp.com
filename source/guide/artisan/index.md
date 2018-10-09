---
title: 命令行
type: guide
order: 700
catalog: Artisan
---

打开命令行，并切换到项目根目录，然后执行`php artisan`或`./artisan`。你将看到:

<pre>
artisan tool for wulaphp

Usage: #php artisan &lt;command&gt; [options] [args]

Options:
  -h, --help     display this help message
  -v             display wulaphp version

Commands:
  admin          administrate tool for wulaphp
  cron           run a crontab job in background
  run            parallel run a script in background
  service        run services in background

Run  '#php artisan help &lt;command&gt;' for more information on a command.
</pre>

这就是wulaphp提供的命令行工具。 wulaphp默认提供了以下几个命令:

1. [admin](admin.html) 管理命令
2. [cron](cron.html) 运行定义任务命令
3. [run](run.html) 并行运行脚本命令
4. [service](service.html) 后台服务管理命令

<p class="tip">
 `cron`、`run`、`service`命令需要`posix`、`pcntl`和`sockets`扩展支持。
</p>

## 自定义命令

实现一个命令很简单，让我演示一下如何实现一个命令将用户输入的两个数加起来（以扩展提供此命令）:

1. 新建文件`extensions/cmd/cmd.php`:
    ```php
    <?php
    namespace cmd;
    use wulaphp\artisan\ArtisanCommand;
    class AddCommand extends ArtisanCommand {
        public function cmd() {
            return 'add';
        }
        public function desc() {
            return 'add two nums';
        }
        protected function argDesc() {
            return '<num1> <num2>';
        }
        protected function execute($options) {
            $num1  = $this->opt(0);//第一个参数: num1
            $num12 = $this->opt(1);//第二个参数: num2
            echo $num1 + $num12,"\n";
            return 0;
        }
    }

    bind('artisan\getCommands', function ($commands) {
        $commands[] = new AddCommand();
        return $commands;
    });
    ```
2. 执行`php artisan`或`./artisan`，你将看到`add`在可用命令列表中:
    <pre>
    artisan tool for wulaphp

    Usage: #php artisan &lt;command&gt; [options] [args]

    Options:
    -h, --help     display this help message
    -v             display wulaphp version

    Commands:
    add            add two nums
    admin          administrate tool for wulaphp
    cron           run a crontab job in background
    run            parallel run a script in background
    service        run services in background

    Run  '#php artisan help &lt;command&gt;' for more information on a command.
    </pre>
3. 执行`php artisan help add`或`./artisan help add`:
    <pre>
    add two nums

    Usage: #php artisan add &lt;num1&gt; &lt;num2&gt;
    </pre>
4. 执行`./artisan add 1 2`:
    <pre>3</pre>

一个简单的加法命令就这么完成了。

### 几点说明

1. 首先继承[ArtisanCommand](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/artisan/ArtisanCommand.php)类实现你的命令
    * `cmd()` 定义命令
    * `desc()` 命令描述
    * `argDesc()` 命令参数说明.
    * `getOpts()` 定义短选项(标识)，使用格式`-f`或`-f10`或`-f 10`。
        * f=>标识说明 - 开启标识
        * f::flag=>标识说明 - 可选有值短选项
        * f:flag=>标识说明 - 必填有值短选项
    * `getLongOpts()` 定义命令选项，使用格式`--arg`或`--arg 10`
        * arg=>长标识说明 - 开启标识
        * arg:argument=>选项说明 - 必填选项
        * arg::argument=>选项说明 - 可选选项
    * `execute($options)` 实现你的命令
        * 可以使用`opt()`函数获取参数。`-2`表示获取倒数第二个参数，以此类推。默认获取倒数第一个参数.
        * 可以使用`help($message)`提供错误信息
        * 命令执行成功返回`0`，失败返回非`0`值.
2. 然后通过`artisan\getCommands`勾子将命令注册到`artisan`

## 短选项演示

改写上例中的`AddCommand`以添加短选项:

```php
class AddCommand extends ArtisanCommand {
    public function cmd() {
        return 'add';
    }
    public function desc() {
        return 'add two nums';
    }
    protected function argDesc() {
        return '';
    }
    protected function getOpts() {
        return ['a:num1' => 'the first number', 'b:num2' => 'the second number'];
    }
    protected function execute($options) {
        $num1  = aryget('a', $options, 0);
        $num12 = aryget('b', $options, 0);
        echo $num1 + $num12;

        return 0;
    }
}
```

执行`./artisan help add`:
<pre>
add two nums

Usage: #php artisan add [options]

Options:
  -a &lt;num1&gt;                the first number
  -b &lt;num2&gt;                the second number
</pre>

执行`./artisan add -a 1 -b 2`你将得到结果`3`。

## 长选项演示

改写上例中的`AddCommand`以添加长选项:

```php
class AddCommand extends ArtisanCommand {
    public function cmd() {
        return 'add';
    }
    public function desc() {
        return 'add two nums';
    }
    protected function argDesc() {
        return '';
    }
    protected function getLongOpts() {
        return ['num1:' => 'the first number', 'num2:' => 'the second number', 'num3::' => 'the third number'];
    }
    protected function execute($options) {
        $num1  = aryget('num1', $options, 0);
        $num12 = aryget('num2', $options, 0);
        if (isset($options['num3'])) {
            $num3 = $options['num3'];
        } else {
            $num3 = 0;
        }
        echo $num1 + $num12 + $num3;
        return 0;
    }
}
```

执行`./artisan help add`:
<pre>
add two nums

Usage: #php artisan add [options]

Options:
  --num1                   the first number
  --num2                   the second number
  --num3                   the third number
</pre>

执行`./artisan add --num1 1 --num2 2`你将得到结果`3`.

执行`./artisan add --num1 1 --num2 2 --num3 3`你将得到`6`.

执行`./artisan add --num2 2 --num3 3`你将得到:

<pre>
ERROR:
  Missing option: --num1
</pre>

<p class="tip">
长短选项可以混用！
</p>
