---
title: 配置概述
type: guide
order: 200
catalog: 配置
---

wulaphp默认的[配置加载器](../advance/cfg-loader.html)可以加载以下两类（不要怕，分类是为了更简单）配置:

1. [普通配置](#普通配置)
2. [数据库配置](#数据库配置)

默认配置加载器加载的配置，不管是哪种类型的配置都是`conf`目录(可通过`CONF_DIR`常量修改)下一个普通的php文件。
本文档基于默认配置加载器。如果有需要你可以自己实现配置加载器，你想怎么加载就怎么加载。

## 普通配置

普通配置通过[Configuration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/Configuration.php)类实现。
wulaphp的默认配置加载器提供了简化的配置方法，只需要在配置文件中返回配置数组即可。如`conf/config.php`:

```php
return [
    'debug'=>DEBUG_DEBUG
];
```

默认的配置加载器将自动把数组转换为`Configuration`实例，上述代码等同于:

```php
$conf           = new Configuration();
$conf['debug']  = DEBUG_DEBUG;

return $conf;
```

`conf/config.php`文件是默认配置组(`default`)的配置文件,可以通过以下方式读取普通配置:

1. `App::bcfg($name, $default = false)`:读取`bool`型配置
2. `App::icfg($name, $default = 0)`:读取`int`型配置
3. `App::icfgn($name, $default = 0)`:
    * 读取`int`型配置
    * 如果配置值为0则返回`$default`
4. `App::acfg($name, $default = [])`:加载`array`型配置
5. `App::cfg($name = '@default', $default = '')`:
    * 调用`App::cfg()`时返回默认配置(Configuration)实例.
    * 调用`App::cfg('@hello')`时返回`hello`配置实例.
    * 调用`App::cfg('name@hello')`时返回`hello`配置中`name`配置项的值.

wulaphp支持将配置分组，分组配置文件名的格式: `分组名_config.php`。
如`cache`组的配置文件名为`cache_config.php`。
在配置文件中可以通过`evn`函数读取`conf/.env`文件中的配置(如果.env文件存在)。`.env`文件示例如下:

```ini
[app]
debug = 1
resource.combinate = 0
```

配置文件调用示例如下:

```php
return [
    'debug' => env('debug',0);
]
```

如果在`.env`文件中配置了`debug`，那么使用`.env`文件中的配置，不然使用`0`。
`.env`文件存在的目的主要是为了方便团队开发，团队里只要有一个人维护配置文件即可。

## 数据库配置

数据库配置大体上和基本配置一样，区别如下:

1. 配置文件名以`dbconfig.php`为结尾，如`newdb_dbconfig.php`为`newdb`数据库配置。
2. 配置文件要返回[DatabaseConfiguration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/DatabaseConfiguration.php)实例（PDO相关配置信息）。

更多信息请传送至[数据库配置](db.html)。

## 特殊配置

wulaphp目前定义几个特殊的配置:

1. [缓存配置](cache.html) - 配置后可直接使用wulaphp提供的缓存功能。
2. [分布式配置](cluster.html) - 配置后分分钟系统可以分布式部署。
3. [Redis配置](redis.html) - 配置后可直接使用基于Redis的一切功能。
4. [Service配置](../utils/service.html) - 详见`service`命令。

## 运行模式与配置

wulaphp默认运行在`dev`模式，可以通过以下几种方式定义wulaphp的运行模式:

1. 在`bootstrap.php`文件中定义APP_MODE常量
2. 定义web服务器的环境变量APPMODE(推荐)
3. 在`conf/.env`文件中添加`app_mode=[pro|test|dev|...]`。

wulaphp在加载配置时优先加载的文件是`config_模式.php`。
假设当前wulaphp的运行模式为`test`那么在加载配置文件时先加载`config_test.php`，如果`config_test.php`文件不存在则加载`config.php`。

> `pro`是wulaphp定义的生产模式。wulaphp只有运行在这个模式下，才会启用:
> 1. 运行时缓存
> 2. 模板缓存
> 3. 缓存

> 1. 分组配置文件加载也应用模式规则,如`test`模式下`cache_config_test.php`优于`cache_config.php`。
> 2. 无论在哪个文件，都可以使用`env`函数从`.env`文件中加载配置。

如果wulaphp的这种配置方案满足不了你，请自定义一个[配置加载器](../advance/cfg-loader.html)。