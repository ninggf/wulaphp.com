---
title: 服务管理
type: guide
order: 710
---

当项目有太多的[定时任务](cron.html)、[并行脚本](run.html)或[Gearman](gearman.html) Worker，单单使用`cron`、`run`、`gearman`命令就显得非常繁杂，且大大增加了维护的难度，所以wulaphp提供了`service`服务管理命令。

通过`service`命令，可以很方便的将上述三种命令通过配置管理管理起来。

## 使用

在命令行中运行`php artisan run`:
<pre>
run services in background

Usage: #php artisan service &lt;start|stop|status|restart|reload|ps&gt; [service]
</pre>

子命令:

1. `start` 启动服务管理进程，或启动`service`。
2. `stop` 停止服务管理进程，或停止`service`。
3. `status` 状态
4. `restart` 重启
5. `reload` 重新加载配置
6. `ps` 查看进程

## 支持的服务

目前支持三种服务：定时任务`cron`，并行脚本`script`，Gearman Worker `gearman`(需要安装`gearman扩展`), 要运行这些服务，需要在`service_config.php`对他们进行相关配置。

## 配置

`service`命令的配置文件为`service_config.php`:

```php
return [
    'verbose'=>'vvvvv',
    'bind'=>'',
    'services'=>[
        's1'=>[
            'type'=>'cron'
            ...
        ],
        ....
    ]
];
```

### 全局配置
