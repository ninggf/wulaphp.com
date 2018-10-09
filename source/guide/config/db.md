---
title: 数据库配置
type: guide
order: 202
---

wulaphp使用[PDO](http://php.net/manual/zh/class.pdo.php)连接数据库并进行数据库操作，所以数据库的配置也就相对简单了，只要配置PDO需要的信息就成。

## 默认配置

数据库配置大体上和基本配置一样，区别如下:

1. `dbconfig.php`是默认数据库配置文件。
2. 其它配置组的文件名以`_dbconfig.php`为结尾，如`newdb_dbconfig.php`为`newdb`数据库配置。
3. 配置文件要返回[DatabaseConfiguration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/DatabaseConfiguration.php)实例（PDO相关配置信息）。

默认数据库配置文件`conf/dbconfig.php`:

```php
<?php
/**
 * 数据库配置。
 */
$config = new \wulaphp\conf\DatabaseConfiguration('default');
//数据库驱动，目前支持MySQL与SQLite
$config->driver('MySQL');
//数据库所在主机的域名或IP
$config->host('localhost');
//数据库运行端口
$config->port('3306');
//数据库名称
$config->dbname('demo_db');
//数据库编码
$config->encoding('UTF8');
//用户名
$config->user('leo');
//密码
$config->password('888888');
return $config;
```

PDO的[属性](http://php.net/manual/zh/pdo.setattribute.php)通过`DatabaseConfiguration::options`方法配置,比如设置`PDO::ATTR_STRINGIFY_FETCHES`(提取的时候将数值转换为字符串):

```php
$config->options([PDO::ATTR_STRINGIFY_FETCHES=>true]);
```

> 1. 目前支持的数据库驱动:`MySQL`与`SQLite`。
> 2. 请根据具体数据库的`DSN`进行配置。
> 3. 欢迎您为wulaphp提供其它数据库驱动，具体参与方式请[传送](https://github.com/ninggf/wulaphp/blob/v2.0/README.md#%E8%B4%A1%E7%8C%AEcontribution)。

## 连接不同库

有些时候吧需要同时连接好多个数据库（感觉是个大项目）。wulaphp提供了此项能力且只需要简单的添加一个数据库配置即可。添加配置文件`conf/newdb_dbconfig.php`:

```php
<?php
$config = new \wulaphp\conf\DatabaseConfiguration('mynew_db');
//数据库驱动，目前只支持MySQL
$config->driver('MySQL');
//数据库所在主机的域名或IP
$config->host('192.168.1.111');
//数据库运行端口
$config->port('3307');
//数据库名称
$config->dbname('xx_new_db');
//数据库编码
$config->encoding('UTF8');
//用户名
$config->user('leo');
//密码
$config->password('888888');
return $config;
```

代码中使用方法有两种:

1. 通过`App::db('newdb')`直接获取数据库连接然后进行[数据库操作](../db/index.html#CRUD)。
2. 通过[模型](../db/model.html#使用模型)方式: `$table = new UserTable('newdb')`。

## 自定义数据库配置加载器

如果这都满足不了你，你是要[上天](../advance/cfg-loader.html#自定义加载器)啊。
