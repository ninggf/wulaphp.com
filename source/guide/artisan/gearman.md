---
title: Gearman
type: guide
order: 704
---

## 场景

当你使用`gearman`做任务队列来处理大量非及时任务时，你会发现编写、管理`Gearman Worker`是一项极其艰难的工作。
wulaphp提供`gearman`命令来简化此工作。

<p class="tip">
安装`gearman`扩展后方可使用哦([下载](https://github.com/wcgallego/pecl-gearman/releases)并安装)。
`gearman server`可以点[这里下载](https://github.com/gearman/gearmand/releases)，关于`gearman`更多信息，请[传送](http://gearman.org/)。
</p>

## 用法

在命令行运行`php artisan gearman -h`:
<pre>
do gearman jobs in background

Usage: #php artisan gearman [options] &lt;script&gt; &lt;start|stop|restart|status|help&gt;

Options:
  -H [hosts]        gearman server hosts
  -p [port]         gearman server port
  -t [timeout]      timeout in seconds
  -n [number]       number of worker to do job(1)
  -c [count]        number of jobs for worker to run before exiting(100)
  -f &lt;function&gt;     function name to use for jobs
</pre>

1. `<script>` Worker处理任务的脚本文件
2. `-H` `Gearman Server`服务的主机地址，默认为`localhost`
3. `-p` `Gearman Server`服务的端口，默认为`4730`
4. `-t` 连接超时（单位秒），默认为`5`秒
5. `-n` Worker的个数，默认为`1`个
6. `-c` 一个Worker处理多少个任务后重启，默认为`1000`个。
7. `-f` 任务名，这个是必须的

> 可以通过服务管理命令`service`来管理[Gearman Worker](service.html#Gearman-Worker)。

## 示例

<p class="tip">
开始示例之前，请保证你已经安装`gearman`扩展且`gearmand`服务已经开启。
</p>

### Worker脚本

Worker需要一个处理任务的脚本(假设脚本文件名为`modules/app/worker/testx.php`)：

```php
<?php
include __DIR__ . '/../../../bootstrap.php';
/**
 * 定义一个GearmJob来处理任务.
 */
class TestxJob extends \wulaphp\artisan\GearmJob {
    protected function doJob($workload) {
        //将接收到的字符反转然后输出
        $this->output(strrev($workload));
        $this->output("\n");

        return true;
    }
}
// 实例化任务类
$testx = new TestxJob();
// 运行
exit($testx->run(false));
```

这段代码功能很简单，将接收到的字符串反转后返回(通过`$this->output()`)。
实现Worker脚本的三步走:

1. 继承`\wulaphp\artisan\GearmJob`类实现任务处理类.
2. 实例化这个类
3. 调用`run`方法，并`exit`其返回值.

#### doJob

处理任务，如需要将处理过程中产生的数据返回请通过`output()`函数输出。

**参数:**

1. `string|array $workload` 任务数据，当`run`方法的第一个参数为`true`时其类型为关联数组。

**返回值:**

`bool` 任务处理失败时返回`false`。

#### run

运行任务处理工作,它会在调用`doJob`方法之前对`$workload`和输出(`output`函数)进行处理。

**参数:**

1. `bool $workloadIsJson` 为`true`时`$workload`为关联数组，默认为`true`。
2. `bool $output` 为`true`时`output()`直接输出数据，默认为`true`。

**返回值:**

`int`型，任务处理失败返回`1`，反之返回`0`。

<p class="tip">
强烈建议将任务类单独写在一个类文件中，不要直接写在脚本里，这样就可以通过`phpunit`对其进程测试啦。

<strong>大大大大大写的提示:</strong> 要以绝对路径`include` `bootstrap.php`文件。
</p>

### 启动Worker

在命令行执行`./artisan gearman -n2 -f testx modules/app/worker/testx.php start`就可以启动处理`testx`任务的Worker了。
通过命令`gearadmin --workers`查看注册到`gearmand`的Worker信息如下:
<pre>
22 127.0.0.1 testx@65684 : testx
22 127.0.0.1 testx@65685 : testx
</pre>

**testx@65685**为worker的ID，其中`65684`，`65685`为Worker进程的`PID`。

通过命令`gearadmin --status`可以查看`gearmand`的状态:
<pre>
testx   0       0       2
</pre>

`testx`的任务处理Worker有2个。

### 验证

在命令行执行`gearman -f testx 'hello world!'`，你将看到:
<pre>
!dlrow olleh
</pre>