---
title: 集群配置
type: guide
order: 203
---

wulaphp基于`Redis`提供分布式缓存。分布式缓存不需要显式的使用，它是wulaphp内部使用的缓存，只需要通过`conf/cluster_config.php`配置:

```php
<?php
/*
 * 集群运行时配置
 *
 *
 * 如果要使用此配置，请在bootstrap.php文件中取消
 * define('RUN_IN_CLUSTER', true)前的注释.
 */
$config = new \wulaphp\conf\ClusterConfiguration();

$config->enabled(false);
$config->addRedisServer('localhost',6379, 8, 1);

return $config;
```

`addRedisServer`参数说明如下:

1. host - 服务器IP/域名
2. port - 端口(默认6379)
3. database - 缓存在哪个库(默认0)
4. timeout - 连接超时(默认1)
5. auth - 认证密码（默认为空）

配置完成后，在`bootstrap.php`添加常量`RUN_IN_CLUSTER`开启分布式部署:

```php
define('RUN_IN_CLUSTER', true);
```

Done! O了。