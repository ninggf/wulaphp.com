---
title: service 服务管理
showToc: 0
index: service artisan
desc: 可管理的后台服务
---

{$toc}

## 命令概述 {#intro}

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
7. `config` 查看服务配置

目前支持三种服务：定时任务`cron`，并行脚本`script`，Gearman Worker `gearman`(需要安装`gearman扩展`), 要运行这些服务，需要在`service_config.php`对他们进行相关配置。

## 配置 {#config}

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

### 全局配置 {#global}

1. `user`: 运行服务的用户，不填写时使用执行`service`命令的用户。
2. `group`: 运行服务的用户组，不填写时使用执行`service`命令的用户组。
3. `verbose`: [日志](#logger)级别
4. `services`: 服务组配置

### 通用配置 {#common}

`services`服务配置项是一个关联数组，其`key`为服务ID:`$id`,其值为该服务的配置，通用配置项如下:

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|verbose|string|N|v|日志级别，详见[日志](#logger)|
|type|string|Y|script|服务类型，`script`,`cron`,`gearman`中的一种|
|env|array|N|[]|定义脚本的环境变量|
|status|string|N|enabled|服务是否启动，可选值: `enabled`,`disabled`|

## 日志 {#logger}

`service`命令会为每个服务生成日志文件，命名规则为`servcie.{$id}.log`。
`service.monitor.log`为监控进程日志(不要用`monitor`做为服务ID哦)。
日志级别通过`verbose`定义，其值意义如下:

* v:info
* vv:error
* vvv:warn
* vvvv:debug

## 定时任务 {#crontab}

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
|fixed|bool|N|false|是否以固定间隔运行，仅在配置`interval`时有效|
|script|string|Y|N/A|定时运行的脚本|

## 并行脚本 {#script}

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

PHP脚本的退出(`exit($val)`)值将对`sleep`产生以下影响:

1. `$val`为`2`时`sleep`参数值被强制设为0，即立即开启一个新的进程执行脚本(如果任务未完成，但是要释放资源时可以`exit(2)`)。
2. `$val`不为`0`时，并行脚本停止运行，并显示错误(`error`)状态。

## Gearman Worker {#gm}

将`type`设为`gearman`的服务是`Gearman`服务，配置如下:

```php
[
    'services'=>[
        'gmw1' => [
            'worker'   => 2,
            'type'     => 'gearman',
            'host'     => '127.0.0.1',
            'workerClass' => '\app\classes\TestxJob',
            'job'      => 'testy'
        ],
        'gmw2' => [
            'worker'   => 5,
            'type'     => 'gearman',
            'script' => 'modules/app/worker/testx.php',
            'job'      => 'testx'
        ]
    ]
]
```

**配置说明:**

|配置名|类型|必填|默认值|说明|
|---|---|:---:|---|---|
|worker|int|N|1|同时运行进程个数|
|workerClass|string|Y|N/A|工人类的全类名,详见[Worker Class](#Worker-Class)|
|script|string|Y|N/A|Worker脚本文件,详见[Woker Script](#Worker-Script)|
|job|string|Y|N/A|任务名|
|host|string|N|localhost|gearman server主机地址|
|port|int|N|4370|gearman server 端口|
|timeout|int|N|5|超时时间，单位秒|
|count|int|N|100|处理多少个任务后重启|
|json|bool|N|true|workload为json格式|

### Worker Class

`service`命令中的`workerClass`支持两类型:

1. 同`script`，将使用[Worker Script](#Worker-Script)处理任务。
2. 任务处理类名(带命名空间)，它是`\wulaphp\artisan\GmWorker`的子类:

    ```php
    class TestyWorker extends \wulaphp\artisan\GmWorker {
        protected function doJob($workload) {
            //do your work here
            return true;
        }
    }
    ```

    `$workload`的数据类型由配置`json`控制。当`json`为`true`时`$workload`的数据类型为`array`。

### Worker Script

Worker需要一个处理任务的脚本(假设脚本文件名为`modules/app/worker/testx.php`)：

```php
<?php
include __DIR__ . '/../../../bootstrap.php';

class TestxJob extends \wulaphp\artisan\GmWorker {
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

1. 继承`\wulaphp\artisan\GmWorker`类实现任务处理类.
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
