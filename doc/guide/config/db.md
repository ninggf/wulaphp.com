---
title: 数据库配置
index: db database
desc: 教你如何配置数据库以便连上数据库
---

`wulaphp`使用[PDO](http://php.net/manual/zh/class.pdo.php)连接数据库并进行数据库操作，所以数据库的配置也就相对简单了，只要配置PDO需要的信息。

## 默认配置

数据库配置大体上和基本配置一样，区别如下:

1. `dbconfig.php`是默认数据库配置文件。
2. 其它配置组的文件名以`_dbconfig.php`为结尾，如`newdb_dbconfig.php`为`newdb`数据库配置。
3. 配置文件要返回[DatabaseConfiguration](https://github.com/ninggf/wulaphp/blob/master/wulaphp/conf/DatabaseConfiguration.php)实例（PDO相关配置信息）。

默认数据库配置文件`conf/dbconfig.php`:

```php
<?php
/**
 * 数据库配置。
 */
$config = new \wulaphp\conf\DatabaseConfiguration('default');
$config->driver(env('db.driver', 'MySQL'));
$config->host(env('db.host', 'localhost'));
$config->port(env('db.port', '3306'));
$config->dbname(env('db.name', ''));
$config->encoding(env('db.charset', 'UTF8MB4'));
$config->user(env('db.user', 'root'));
$config->password(env('db.password', ''));
$options = env('db.options', '');
if ($options) {
    $options = explode(',', $options);
    $dbops   = [];
    foreach ($options as $option) {
        $ops = explode('=', $option);
        if (count($ops) == 2) {
            if ($ops[1][0] == 'P') {
                $dbops[ @constant($ops[0]) ] = @constant($ops[1]);
            } else {
                $dbops[ @constant($ops[0]) ] = intval($ops[1]);
            }
        }
    }
    $config->options($dbops);
}
return $config;
```

PDO的[属性](http://php.net/manual/zh/pdo.setattribute.php)通过`DatabaseConfiguration::options`方法配置,比如设置`PDO::ATTR_STRINGIFY_FETCHES`(提取的时候将数值转换为字符串):

```php
$config->options([PDO::ATTR_STRINGIFY_FETCHES=>true]);
```

> 1. 目前支持的数据库驱动:`MySQL`、`SQLite`和`Postgres`。
> 2. 请根据具体数据库的`DSN`进行配置。

## 连接不同库

`wulaphp`提供了同时连接多个数据库的能力且只需要简单的添加一个数据库配置即可。如，添加配置文件`conf/newdb_dbconfig.php`:

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

1. 通过`App::db('newdb')`直接获取数据库连接然后进行[数据库操作](../db/index.md#CRUD)。
2. 通过[模型](../db/model.md#use)方式: `$table = new UserTable('newdb')`。

如果这样的配置方式你不喜欢，或满足不了你的要求(**比如需要从第三方配置系统加载配置**)，你可以自定义[数据库配置加载器](../advance/cfg-loader.md#db)。
