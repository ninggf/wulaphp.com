---
title: 服务管理
type: guide
order: 710
---

当项目有太多的[定时任务](cron.html)、[并行脚本](run.html)或[Gearman](gearman.html) Worker，单单使用`cron`、`run`、`gearman`命令就显得非常繁杂，且大大增加了维护的难度，所以wulaphp提供了`service`服务管理命令。
通过`service`命令，可以很方便的将上述三种命令通过配置管理管理起来。
使用`service`命令有以下好处:

1. 后台服务维护简单。
2. 服务进程监控。
3. 统一管理接口。

## 命令概述

在命令行中运行`php artisan service`:
<pre>
run services in background

Usage: #php artisan service &lt;start|stop|status|restart|reload|ps&gt; [service]
</pre>

**子命令:**

1. `start` 启动服务管理进程，或启动`service`。
2. `stop` 停止服务管理进程，或停止`service`。
3. `status` 状态
4. `restart` 重启
5. `reload` 重新加载配置
6. `ps` 查看进程

目前支持三种服务：定时任务`cron`，并行脚本`script`，Gearman Worker `gearman`(需要安装`gearman扩展`), 要运行这些服务，需要在`service_config.php`对他们进行相关配置。

## 配置

`service`命令的配置文件为`service_config.php`:

```php
return [
    'user'     => 'leo',
    'group'    => 'staff',
    'verbose'  => 'vvvv',//v=>info,vv=error,vvv=warn,vvvv=debug
    'services'=>[
        's1'=>[
            'type'=>'cron'
            ...
        ],
        's1223'=>[
            'type'=>'script'
            ...
        ],
        'xewwe'=>[
            'type'=>'gearman'
            ...
        ],
        ....
    ]
];
```

### 全局配置

1. `user`: 运行服务的用户，不填写时使用执行`service`命令的用户。
2. `group`: 运行服务的用户组，不填写时使用执行`service`命令的用户组。
3. `verbose`: [日志](#日志)级别
4. `services`: 服务组配置

### 通用配置

`services`服务配置项是一个关联数组，其`key`为服务ID:`$id`,其值为该服务的配置，通用配置项如下:

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|verbose|string|N|v|日志级别，详见[日志](#日志)|
|type|string|Y|script|服务类型，`script`,`cron`,`gearman`中的一种|
|env|array|N|[]|定义脚本的环境变量|
|status|string|N|enabled|服务是否启动，可选值: `enabled`,`disabled`|

## 日志

`service`命令会为每个服务生成日志文件，命名规则为`servcie.{$id}.log`。
`service.monitor.log`为监控进程日志(不要用`monitor`做为服务ID哦)。
日志级别通过`verbose`定义，其值意义如下:

* v:info
* vv:error
* vvv:warn
* vvvv:debug

## 定时任务

将`type`设为`cron`的服务是定时任务，配置如下:

```php
[
    'services'=>[
        'cron_service'=>[
            'verbose'  => 'vvvv',
            'type'     => 'cron',
            'interval' => 10,
            'fixed'    => true,//true or false
            'script'   => 'test2.php',
            'status'   => 'disabled'
        ]
    ]
]
```

**配置说明:**

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|interval|int|N|10秒|运行间隔,配置`cron`后无效|
|cron|string|N|N/A|精确到秒的[crontab](#crontab)|
|fixed|bool|N|false|是否以固定间隔运行，仅在配置`interval`时有效|
|script|string|Y|N/A|定时运行的脚本，见[cron](cron.html#脚本)命令.|

### crontab

精确到秒的`crontab`比类`unix`系统的crontab定义多一段以表示秒:

<pre>
.------------------------ 秒(0 - 59)
|   .-------------------- 分(0 - 59)
|   |   .---------------- 时(0 - 23)
|   |   |   .------------ 日(1 - 31)
|   |   |   |   .-------- 月(1 - 12)
|   |   |   |   |   .---- 周(0 - 6)（星期日是0）
|   |   |   |   |   |
*   *   *   *   *   *
</pre>

每天早上7:00到7:59以每隔10秒执行一次要向下边这样配置`cron`:

`*/10   *   7   *   *   *`

## 并行脚本

将`type`设为`script`的服务是并行脚本服务，配置如下:

```php
[
    'services'=>[
        'parallel_service'=>[
            'type'   => 'script',
            'worker' => 2,
            'sleep'  => 15,
            'script' => 'test.php'
        ]
    ]
]
```

**配置说明:**

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|sleep|int|N|10秒|休息秒数，详见[sleep](#sleep)|
|worker|int|N|1|同时运行进程个数|
|script|string|Y|N/A|PHP脚本文件|

### sleep

PHP脚本的退出(`exit($val)`)值将对`sleep`产生以下影响:

1. `$val`为`2`时`sleep`参数值被强制设为0，即立即开启一个新的进程执行脚本(如果任务未完成，但是要释放资源时可以`exit(2)`)。
2. `$val`不为`0`时，并行脚本停止运行，并显示错误(`error`)状态。

## Gearman Worker

将`type`设为`gearman`的服务是`Gearman`服务，配置如下:

```php
[
    'services'=>[
        'gmw1' => [
            'worker'   => 2,
            'type'     => 'gearman',
            'host'     => '127.0.0.1',
            'jobClass' => '\app\classes\TestxJob',
            'job'      => 'testy'
        ],
        'gmw2' => [
            'worker'   => 5,
            'type'     => 'gearman',
            'jobClass' => 'modules/app/worker/testx.php',
            'job'      => 'testx'
        ]
    ]
]
```

**配置说明:**

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|worker|int|N|1|同时运行进程个数|
|jobClass|string|Y|N/A|PHP脚本文件或任务类的全类名,详见[Job Class](#Job-Class)|
|job|string|Y|N/A|任务名|
|host|string|N|localhost|gearman server主机地址|
|port|int|N|4370|gearman server 端口|
|timeout|int|N|5|超时时间，单位秒|
|count|int|N|100|处理多少个任务后重启|
|json|bool|N|true|workload为json格式|

### Job Class

与`gearman`命令不同，`service`命令中的`jobClass`支持两类型:

1. 任务处理脚本，此脚本文件同`gearman`的[处理脚本](gearman.html#Worker脚本)。
2. 任务处理类名(带命名空间)，它是`\wulaphp\artisan\GearmJob`的子类:
    ```php
    class TestyJob extends \wulaphp\artisan\GearmJob {
        protected function doJob($workload) {
            //do your work here
            return true;
        }
    }
    ```
    `$workload`的数据类型由配置`json`控制。当`json`为`true`时`$workload`的数据类型为`array`。
