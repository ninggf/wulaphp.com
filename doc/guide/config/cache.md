---
title: 缓存配置
index: cache
showToc: 0
desc: 配置缓存，利用缓存加速你的应用
---


你使用`memcached`还是`redis`还是`xxx`还是`yyy`还是`zzz`？不急咱一个一个来，打开`conf/cache_config.php`文件：

## memcached {#memcached}

```php
$config = new \wulaphp\conf\CacheConfiguration();
$config->enabled(true);
$config->setDefaultCache('memcached');
$config->addMemcachedServer('127.0.0.1', '11211', 50);
$config->addMemcachedServer('192.168.1.100', '11211', 50);
```

1. 可以添加多个`memcached`服务器，并合理分配它们的权重.
2. 如果只有一台`memcached`服务器，权重应为:100
3. `addMemcachedServer`方法有三个参数:
    1. host - 服务器IP/域名
    2. port - 端口(默认11211)
    3. weight - 权重(默认100)

## redis {#redis}

```php
$config = new \wulaphp\conf\CacheConfiguration();
$config->enabled(true);
$config->setDefaultCache('redis');
$config->addRedisServer('localhost',6379, 8, 1);
```

`addRedisServer`有5个参数:

1. host - 服务器IP/域名
2. port - 端口(默认6379)
3. database - 缓存在哪个库(默认0)
4. timeout - 连接超时(默认1)
5. auth - 认证密码（默认为空）

## 友情提示

1. `enabled`启用或停用缓存，没毛病吧
2. `setDefaultCache`设置默认缓存
3. 可以在`conf/cache_config.php`中同时配置`memcached`和`redis`和其它缓存
    * 通过`$config->addConfig($type, $cfg)`
