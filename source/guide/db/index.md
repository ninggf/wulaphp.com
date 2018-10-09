---
title: 数据库连接
type: guide
catalog: 数据库
order: 14
---

**目前wulaphp只支持MySQL和SQLite**,wulaphp的数据库访问是基于PDO的，可以面向对象(Model)地访问数据库也可以直接操作。同时wulaphp还提供了轻量级的ORM实现。

## DB Connection

访问数据库之前，先得连上它以获取一个数据库连接 -- **DB Connection**。
可以参考之前文档中的[配置数据库链接](../database.html#配置数据库)进行快速配置，
详细配置请传送至[数据库配置](../config/db.html)。

配置好了之后我们就可以使用下边的代码直接创建一个默认的**数据库连接**:

```php
$db = \wulaphp\app\App::db();
```

如果我们想使用不同的配置`db2`创建数据库连接可以这样:

```php
$db = \wulaphp\app\App::db('db2');
```

当然我们还可以直接通过配置创建数据库连接:

```php
$db = \wulaphp\app\App::db(['driver' => 'MySQL',
                            'port' => '3306',
                            'host' => 'localhost',
                            'dbname' => 'db name',
                            'user' => 'root',
                            'password' => '888888',
                            'encoding' => 'UTF8']
                         );
```

`$db`是类[\wulaphp\db\DatabaseConnection](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/db/DatabaseConnection.php)的一个实例. 使用它可以进行快速的增删改查(CRUD)和执行原生的SQL。

## CRUD

以下示例以[连接数据库](../database.html)文档中创建的数据库和表为基础:

1. 增，$userId为新增的用户ID
    ```php
    $userId = $db->insert([
        'username' => 'user6',
        'nickname' => '小王',
        'hash'     => md5('123321'),
        'phone'    => '13811111111',
        'email'    => 'abc@aaaa.com'
    ])->into('user')->newId();
    ```
2. 增（批量）, $newId为第一个记录的ID,$affected为新增成功条数
    ```php
    $db      = \wulaphp\app\App::db();
    $users[] = [
        'username' => 'user8',
        'nickname' => '小王八',
        'hash'     => md5('123321'),
        'phone'    => '13811111111',
        'email'    => 'abc@aaaa.com'
    ];
    $users[] = [
        'username' => 'user9',
        'nickname' => '小王九',
        'hash'     => md5('123321'),
        'phone'    => '13811111111',
        'email'    => 'abc@aaaa.com'
    ];
    $userId = $db->inserts($users)->into('user')->newId();
    //或者下边这样的
    //$userId = $db->insert($users, true)->into('user')->newId();
    //或者只取插入成功条数
    //$affected = $db->insert($users, true)->into('user')->affected();
    ```
3. 删,(删除id大于10的用户)，$affected为删除成功条数
    ```php
    $db = \wulaphp\app\App::db();

    $affected = $db->delete()->from('user')->where(['id >' => 10])->affected();
    ```
4. 改, $affected为修改成功条数
    ```php
    $db = \wulaphp\app\App::db();

    $affected = $db->update('user')->set(['nickname' => '王小二'])->where(['username' => 'user8'])->affected();
    ```
5. 原生『增删改』，$affected为删除成功条数
    ```php
    $db = \wulaphp\app\App::db();
    //改
    $affected = $db->cud("UPDATE `user` SET nickname='%s' WHERE id = %d", 'Leo', 1);
    //增
    $affected = $db->cud("INSERT INTO `user` (username,nickname,`hash`) VALUES ('%s','%s','%s')", 'Leo', 'user100', md5('123321'));
    //删除
    // 自动写一个呗
    ```
6. 查（原生SQL）, $row为结果数组
    ```php
    $db  = \wulaphp\app\App::db();
    $row = $db->query('SELECT * FROM user where id = %d',1);
    ```
7. 查（拼装SQL），$row为结果数组（ary方法将结果转换为数组）
    ```php
    $db = \wulaphp\app\App::db();

    $row = $db->select('id', 'username', 'nickname AS nk')->from('user')->where(['id' => 1])->ary();
    //或者下边这种写法 
    $row = $db->select('id,username,nickname AS nk')->from('user')->where(['id' => 1])->ary();
    ```
8. 查（联接查询），假如一个组(group)可以有多个用户，一个用户只能属于一个组.
    ```php
    $db = \wulaphp\app\App::db();

    $row = $db->select('USER.*,GP.name AS group_name')->from('user AS USER')->join('group AS GP', 'USER.gid = GP.id');
    ```
9. DDL语句
    ```php
    $affected = $db->exec("DROP DATABASE abc");
    $affected = $db->exec("ALTER TABLE ....");
    $affected = $db->exec("CREATE TABLE `tablename` ...");
    ```

更多的[DatabaseConnection](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/db/DatabaseConnection.php)用法，请参考源代码^_^

## 接下来

**其实上边的示例用法是wulaphp最不推荐的用法**，因为没人希望对数据库的『增删改』散落在代码的各个角落。wulaphp提供[模型](model.html)以集中数据库访问。
