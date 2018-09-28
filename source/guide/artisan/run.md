---
title: 并行脚本
type: guide
order: 703
---

## 场景

假如你有大量的数据要处理，且这些数据间无任何关联(每条数据都是独立的)，那你最佳选择无非是搞N多个进程同时处理。
`run`命令就是为此而生的。

> 使用此命令时，请自行保证不会有多个进程处理同一条数据:
> 1. 使用锁
> 2. 使用信号机制
> 3. 等等等

## 用法

在命令行中运行`php artisan run`:

<pre>
parallel run a script in background

Usage: #php artisan run [options] &lt;script&gt; [start|stop|status|help]

Options:
  -n [number]      Number of worker to run the script(4)
  -l [logfile]     log file
</pre>

1. `<script>`即为要并行运行的脚本文件。
2. `-n` 同时运行的多个进程
3. `-l` 日志文件

## 脚本返回值

`run`命令会处理脚本进程的退出`exit`值以优化性能:

1. `0`：此时脚本监控进程不退出，而是`sleep(1)`后再次运行脚本进程。
2. `2`：此时脚本监控进程重启以释放资源，然后再运行脚本进程。

<p class="tip">
`run`命令会保证脚本进程的存活，一旦脚本进程死掉，`run`命令会立即创建一个新的脚本进程。
</p>
