---
title: 定时任务
type: guide
order: 702
---

搞一此东西在后台每隔一定时间运行一次，就这是定时任务。
当然可以通过系统提供的定时任务(crontab)来完成，但是系统定时任务的最小时间间隔是1分钟。
如果你需要更小的时间间隔可以尝试wulaphp提供的`cron`命令。
运行`php artisan help cron`获取帮助信息:
<pre>
run a crontab job in background

Usage: #php artisan cron [options] &lt;job&gt; [start|stop|status|help]

Options:
  -i [interval]     the interval in seconds, default is 1 second.
  -s [second]       start at second(0-59)
  -f                run in fixed interval.
</pre>

需要为`cron`命令提供一个`job`，通过:

1. `-i`选项指定运行间隔（单位为秒）
2. `-s`选项让任务在指定的秒启动
3. `-f`选项让任务以固定间隔执行。

`job`可以是一个实现[ICrontabJob](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/util/ICrontabJob.php)接口的类，也可以是一个脚本文件。

比如弄个`job`每隔10秒把当前时间戳写到文件`logs/t.log`中(以扩展方式提供这个`job`)

### Job类

```php
<?php
namespace hello;

use wulaphp\util\ICrontabJob;

class TestCron implements ICrontabJob {
    public function run() {
        file_put_contents(LOGS_PATH . 't.log', date('Y-m-d H:i:s') . "\n",FILE_APPEND);
    }
}
```

实现`IContabJob::run`方法即可(这个示例确实有点简单了):

1. 通过`php artisan cron -i 10 "hello\TestCron" start`运行，然后观察`storage/logs/t.log`文件内容.
2. 通过`php artisan cron "hello\TestCron" stop`停止`job`。
3. 通过`php artisan cron "hello\TestCron" status`查看`job`状态。

### 脚本

假设脚本文件位于`crontab`目录，文件名为`job1.php`。

```php
include '../bootstrap.php';

file_put_contents(LOGS_PATH . 't.log', date('Y-m-d H:i:s') . "\n", FILE_APPEND);
```

然后:

1. 通过`php artisan cron -i 10 crontab/job1.php start`运行，然后观察`storage/logs/t.log`文件内容.
2. 通过`php artisan cron crontab/job1.php stop`停止`job`。
3. 通过`php artisan cron crontab/job1.php status`查看`job`状态。

如果你有很多定时任务要运行，推荐使用[service](service.html)命令来管理。

<p class="tip">
`cron`命令会保证任务进程的存活，一旦任务进程死掉，`cron`命令会立即创建一个新的任务进程。
</p>