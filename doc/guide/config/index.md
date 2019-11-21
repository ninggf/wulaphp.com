---
title: 配置详解
index: config conf
keywords: config conf 配置管理 wulaphp配置 配置功能
showToc: 0
desc: 让wulaphp按你的配置运行，一切如你所愿
---

{$toc}

`wulaphp`默认的[配置加载器](../advance/cfg-loader.md)可以加载以下两类配置:

1. [普通配置](#base)
2. [数据库配置](#db)

默认配置加载器加载的配置，不管是哪种类型的配置都是`conf`目录(可通过`CONF_DIR`常量修改)下一个普通的php文件。
本文档基于默认配置加载器。如果有需要你可以自己实现配置加载器，你想怎么加载就怎么加载。

## 普通配置 {#bse}

`wulaphp`的默认配置加载器提供了简化的配置方法，只需要在配置文件中返回配置数组即可。如`conf/config.php`:

```php
return [
    'debug'=>DEBUG_DEBUG
];
```

`conf/config.php`文件是默认配置组(`default`)的配置文件,
`wulaphp`支持将配置分组，分组配置文件名的格式: `分组名_config.php`。
如`cache`(缓存)组的配置文件名为`cache_config.php`。

### 读取普通配置

可以通过以下方式读取普通配置:

1. `App::bcfg($name, $default = false)`:读取`bool`型配置
2. `App::icfg($name, $default = 0)`:读取`int`型配置
3. `App::icfgn($name, $default = 0)`:
    * 读取`int`型配置
    * 如果配置值为0或为空或未配置则返回`$default`
4. `App::acfg($name, $default = [])`:加载`array`型配置
5. `App::cfg($name = '@default', $default = '')`:
    * 调用`App::cfg()`时返回默认配置(Configuration)实例.
    * 调用`App::cfg('@hello')`时返回`hello`配置实例.
    * 调用`App::cfg('name@hello')`时返回`hello`配置中`name`配置项的值.

更多配置信息请传送到[默认配置](base.md)。

## 数据库配置 {#db}

数据库配置大体上和基本配置一样，区别如下:

1. `dbconfig.php`是默认数据库配置文件。
2. 其它配置组的文件名以`_dbconfig.php`为结尾，如`newdb_dbconfig.php`为`newdb`数据库配置。
3. 配置文件要返回[DatabaseConfiguration](https://github.com/ninggf/wulaphp/blob/master/wulaphp/conf/DatabaseConfiguration.php)实例（PDO相关配置信息）。

更多信息请传送至[数据库配置](db.md)。

## 特殊配置

`wulaphp`目前定义了几个特殊的配置:

1. [缓存](cache.md) - 配置后可直接使用wulaphp提供的缓存功能。
2. [集群](cluster.md) - 配置后分分钟系统可以分布式部署。
3. [Redis](redis.md) - 配置后可直接使用基于Redis的一切功能。
4. [Service](service.md) - 详见`service`命令。

## .env 环境变量

在配置文件中可以通过`evn`函数读取`conf/.env`文件中的环境变量(如果.env文件存在)。`.env`文件示例如下:

```ini
[app]
debug = 1
resource.combinate = 0
```

配置文件(如`config.php`)调用示例如下:

```php
return [
    'debug' => env('debug', 0);
]
```

上边的代码表示如果在`.env`文件中配置了`debug`，那么使用`.env`文件中的配置，不然使用`0`。
`.env`文件存在的目的主要是为了方便团队开发，团队里只要有一个人维护配置文件即可。

## 运行模式

`wulaphp`默认运行在`dev`(开发)模式，可以通过以下几种方式定义运行模式:

1. 在`bootstrap.php`文件中定义APP_MODE常量
2. 定义web服务器的环境变量APPMODE
3. 在`conf/.env`文件中添加`app_mode=[pro|test|dev|...]`

> **pro**是wulaphp定义的生产模式。只有运行在**pro**模式下，才会启用以下功能:
>
> * 运行时缓存(需要yac、apc、xcache等扩展支持)
> * 模板缓存
>
> 产品上线后，强烈建议将运行模式设为`pro`。

### 模式配置加载

`wulaphp`可以根据运行模式智能地加载与运行模式相对应的配置，假设当前运行模式为`test`，此时
我们调用`App::cfg('name@hello')`读取`hello`组的`name`值，wulaphp是这样加载配置的:

1. 加载`conf/hello_config.php`中的配置

   ```php
    return ['name'=>'bad name'];
   ```

2. 如果`conf/hello_config_test.php`文件存在，则加载它的配置并覆盖上一步中加载的配置。

   ```php
   return ['name'=>'一枝花','age'=>18];
   ```

`App::cfg('name@hello')`返回`一枝花`；`App::cfg('age@hello')`返回`18`。

> 在所有配置文件中，还是可以使用`env`函数从`.env`文件中加载配置的。

如果`wulaphp`的这种配置方案满足不了你，请自定义一个[配置加载器](../advance/cfg-loader.md)，随便你怎么加载配置。
