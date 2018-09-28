---
title: Redis
type: guide
order: 601
---

wulaphp提供了俩类供你快速地使用`Redis`:

1. [RedisClient](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/util/RedisClient.php)类，通过它可以方便的获取一个[Redis](https://github.com/phpredis/phpredis/)实例:
    ```php
    $redis = RedisClient::getRedis();
    ```
    获取`Redis`实例后，随便你耍。
2. [RedisLock](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/util/RedisLock.php)类，基于Redis实现的简单的分布式锁
    ```php
    RedisLock::nblock('my-lock',function(){
        //锁住之后你要干啥?
    },120);
    ```

看上去简单，使用起来好像也不难。But~~~，你得配置它。

## 配置

通过`conf/redis_config.php`来配置Redis:

```php
<?php

$config = new \wulaphp\conf\RedisConfiguration();
$config->addRedisServer('127.0.0.1', 6379, 1, 5);

return $config;
```

简化版配置(直接返回配置数组):

```php
<?php

return ['host'=>'localhost','port'=>6379,'db'=>0,'auth'=>'','timeout'=>5];
```

> `addRedisServer`参数/配置数组说明如下:
> 1. host - 服务器IP/域名
> 2. port - 端口(默认6379)
> 3. database - 缓存在哪个库(默认0)
> 4. timeout - 连接超时(默认1)
> 5. auth - 认证密码（默认为空）

配置就这么简单.

## RedisClient

它只有一个方法`getRedis`，获取一个Redis实例供你驱驶，请看:

```php
/**
 * 获取一个Redis实例.
 *
 * @param string|array|null|int $cnf
 *
 * Redis服务器地址:
 * 1. string: Redis服务器地址
 * 2. array: 配置数组
 *  $cnf = [0=>$host,1=>$port,2=>$timeout,3=>$auth,4=>$db]
 * 3. null： 从配置文件redis_config.php中读取：
 *  return ['host'=>'localhost','port'=>6379,'db'=>0,'auth'=>'','timeout'=>5]
 * 4. int: 从配置文件redis_config.php中读取,并将数据库替换为`$cnf`指定的库.
 *
 * @param  int|null             $db     数据库，不为null时将替换配置中的数据库
 * @param string                $prefix key前缀.
 * 
 * @return \Redis
 * @throws \Exception when the redis extension is not installed.
 */
public static function getRedis($cnf = null, $db = null, $prefix = '') 
```

`$cnf`参数详解(因为这个参数太神奇)，它有4种格式:

1. string - 如果你传的是字符串，那么它一定是Redis服务器的IP或域名(主机地址).
2. array  - 如果你传的是数组，那么格式是下边这样的:
    * `[0=>$host,1=>$port,2=>$timeout,3=>$auth,4=>$db]`
3. null - 如果你传了null(使用默认值),那么使用`redis_config.php`配置。
4. int  - 如果你传的是整数，那么使用`redis_config.php`的配置但是数据库使用你传的整数.

## RedisLock

RedisLock类提供了四个静态方法实现基于Redis的简单锁:

1. `RedisLock::nblock($lock, \Closure $callback, $timeout = 120)`:
    * 非阻塞锁，锁住就执行$callback并返回其返回值，锁不住就返回false。
    * $lock - 锁名
    * $callback - 锁住后要执行的回调
    * $timeout - 锁自动释放时间,默认为120秒
2. `RedisLock::lock($lock, \Closure $callback, $timeout = 30)`:
    * 阻塞锁，无法获取锁时返回false，成功获取锁后返回$callback的返回值.
    * $lock - 锁名。
    * $callback - 锁住后要执行的回调。
    * $timeout - 多久锁不住返回false。
3. `RedisLock::ulock($lock, $timeout = 30, &$wait = null)`:
    * 用户锁，不自动释放，需要用户手动释放.
    * $lock - 锁名
    * $timeout - 获取锁超时
    * $wait - 是否等待了锁(有些时候不需要等可以立即获到锁那么此时`$wait=false`).
4. `RedisLock::uunlock($lock)`:
    * 释放通过`RedisLock::ulock`获取到的锁.
    * $lock - 锁名

关于Redis就说这么多了。