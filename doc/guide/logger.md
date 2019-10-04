---
title: 日志
index: 1
cate: 基础
showToc: 0
desc: 了解程序的运行情况，在问题出现时进行快速定位排查
---

## 概述 {#intro}

通过日志我们可以了解程序的运行情况，在问题出现时进行快速定位排查。wulaphp的日志系统基于`psr/log`库实现，同时提供了`log_error`, `log_info`,`log_warn`,`log_debug`4个方法以快速记录日志。
wulaphp默认的日志实现以文件的方式记录日志到`storage/logs`目录。

通过实现`prs/log`的`Psr\Log\LoggerInterface`接口并利用勾子`logger\getLogger`替换系统默认的日志器，就可以实现自定义的日志器，按自己的方式记录日志，详见[自定义日志实现](#custom)。

## 日志级别 {#level}

wulaphp的日志级别共分四种:`error`,`warn`,`info`,`debug`，相较于`prs/log`中规定的少了`emergency`,`alert`,`critical`,`notice`。
wulaphp将`emergency`,`alert`,`critical`三个级别合并到`error`,将`notice`合并到`info`。
在[默认配置](config/base.md)文件中设置`debug`为下列值可决定系统使用的日志级别:

1. `DEBUG_DEBUG`: `debug`级别
2. `DEBUG_INFO`: `info`级别
3. `DEBUG_WARN`: `warn`级别
4. `DEBUG_ERROR`: `error`级别
5. `DEBUG_OFF`: 关闭日志，不记录任何日志信息。

## 记录日志

需要记录日志的地方调用:

1. `log_debug`
2. `log_info`
3. `log_warn`
4. `log_error`

进行日志记录，如:

```php
log_debug('this is a debug message');
log_info('this is an info message');
log_warn('warnning warnning');
log_error('system is down');
```

## 日志分组 {#channel}

可以将日志记录到不同的分组里，只需为`log_*`函数提供第二个参数指定分组即可。

```php
log_debug('this ia s debug message','abc');
```

默认的日志实现将日志记录到`storage/logs/abc.log`文件。

## 自定义日志实现 {#custom}

首先继承`\wulaphp\util\CommonLogger`类创建自己的日志实现类:

```php
class MyLogger extends \wulaphp\util\CommonLogger {
    public function log($level,$message,array $content = []){
        //你的代码
    }
}
```

> 说明:
>
> 1. 在log方法中可以`$channel`获取到当前分组。
> 2. $level为int型，可以使用常量`DEBUG_DEBUG`,`DEBUG_WARN`,`DEBUG_INFO`,`DEBUG_ERROR`,`DEBUG_OFF`进行判断级别。
> 3. $content为`debug_backtrace`的数据。

然后通过勾子`logger\getLogger`替换系统的日志实现即可:

```php
class GetLogger extends Alter3 {
    protected abstract function doAlter($value, $level, $channel){
        return new MyLogger($channel);
    }
}
```

## 特别说明

和`psr/log`的不同点如下:

1. 日志级别使用整型表示而不是字符且只保留`debug`,`info`,`warn`,`error`四个。
2. 日志上下文在使用`log_*`函数时，强制使用`debug_backtrace`的返回值，如果要记录上下文信息，只直接将上下文写在日志内容里。
3. 日志分组功能需要自己实现。
