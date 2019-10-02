---
title: Redis 配置
showToc: 0
index: 1
desc: 教你如果配置Redis
---


通过`conf/redis_config.php`来配置Redis:

```php
<?php

$config = new \wulaphp\conf\RedisConfiguration();
$config->addRedisServer('127.0.0.1', 6379, 1, 5);

return $config;
```

简化版配置(直接返回配置数组):

```php
<?php

return ['host'=>'localhost','port'=>6379,'db'=>0,'auth'=>'','timeout'=>5];
```

`addRedisServer`参数/配置数组说明如下:

1. host - 服务器IP/域名
2. port - 端口(默认6379)
3. database - 缓存在哪个库(默认0)
4. timeout - 连接超时(默认1)
5. auth - 认证密码（默认为空）

配置就这么简单.
