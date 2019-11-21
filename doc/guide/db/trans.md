---
title: 事务
showToc: 0
index: 事务 数据库 trans
keywords: 事务 数据库 transaction mysql事务 开启事务 提交事务 回滚事务
desc: 在wulaphp中使用数据库事务是一件轻松愉悦的事,无论开启、提交还是回滚都是那么简单
---

{$toc}

如果你需要事务支持，请认真阅读本文档. 总体来说在wulaphp中使用事务是一件轻松愉悦的事!

## 简单事务 {#trans}

1. 自己动手处理（开启，提交，回滚）

    ```php
    $db = App::db();
    if ($db->start()) {
        $affected = $db->cud("INSERT INTO `user` (username,nickname,`hash`) VALUES
         ('%s','%s','%s')", 'Leo', 'user100', md5('123321'));

        if ($affected) {
            $db->commit();
        } else {
            $db->rollback();
        }
    }
    ```

    > 切记也要手动`commit`或`rollback`事务

2. 自动处理（通过捕获异常实现回滚）

    ```php
    $db = App::db();
    $rst = $db->trans(function (DatabaseConnection $con) {
        $rtn =  $con->cud("INSERT INTO `user` (username,nickname,`hash`) VALUES ('%s','%s','%s')"
        , 'Leo', 'user100', md5('123321'));
        if(!$rtn){
            throw new Exception('更新失败');
        }
        return $rtn;
    });
    ```

关键是`trans`方法.详细请阅读[DatabaseConnection](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/DatabaseConnection.php)的源代码:

```php
/**
 * 在事务中运行.
 * 事务过程函数返回非真值[null,false,'',0,空数组等]或抛出任何异常都将导致事务回滚.
 *
 * @param \Closure $trans 事务过程函数,声明如下:
 *                        function trans(DatabaseConnection $con,mixed $data);
 *                        1. $con 数据库链接
 *                        2. $data 锁返回的数据.
 * @param string   $error 错误信息
 * @param ILock    $lock  锁.
 *
 * @return mixed|null  事务过程函数的返回值或null
 */
public function trans(\Closure $trans, &$error = null, ILock $lock = null)
```

`$lock`为锁，详细请参考[TableLocker](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/TableLocker.php)

## 模型与事务 {#mtrans}

在模型类中实现事务非常之简单,简单地改写一下`UserTable`的[updateUserByGid](model.md#update2):

```php
public function updateUserByGid($cid, $gid) {
    $rst = $this->trans(function ($db) use ($cid, $gid) {
        $sql = $this->update()->set(['cid' => $cid])->where(['gid' => $gid]);
        $sql->asc('cid')->limit(0, 2);

        return $sql->exec();
    }, $this->errors);

    return $rst;
}
```

需要解释么?

> 特别解释:`$sql->asc('cid')->limit(0, 2);` 这句与事务无关哦。
>
> 请重点放在`$this->trans`上。

`Table`类供的`trans`方法声明如下:

```php
/**
 * 在事务中运行.
 *
 * @param \Closure                       $fun
 * @param \wulaphp\wulaphp\db\ILock|null $lock
 *
 * @return mixed|null
 */
protected function trans(\Closure $fun, ILock $lock = null) {
    return $this->dbconnection->trans($fun, $this->errors, $lock);
}
```

就是DataConnection的trans简单封装^_^

## 事务嵌套 {#em}

假设你有几个函数（方法）,它们之间的调用关系大概如下:

```php
//新增用户
function addUser($username){
    $db = App::db();
    $rst = $db->trans(function ($con) use($username) {
        // 创建一个用户
        $uid = ...;
        $rst = $uid && changeUserLevel($uid,10);
        $rst = $rst && changeUserRole($uid,1);
        return $rst;
    });
}
//修改用户级别
function changeUserLevel($uid,$level){
    $db = App::db();
    $rst = $db->trans(function ($con) use($uid,$rid) {
        // 变更用户等级操作
        $rst = ...;
        return $rst;
    });
}
//修改用户角色
function changeUserRole($uid,$rid){
    $db = App::db();
    $rst = $db->trans(function ($con) use($uid,$rid) {
        // 变更用户角色操作
        $rst = ...;
        return $rst;
    });
}
```

这种情况就属于**事务嵌套**(只能在同一个数据库连接中)，wulaphp已经妥善处理了这种情况，不用担心数据会不一致。
当我们调用`addUser()`时，wulaphp保证:

1. 要么用户被创建且等级修改为`10`、角色设为`1`。
2. 要么用户创建失败且等级和角色都不会修改。
    * 决不会出现用户创建成功且等级修改成功但角色设为失败的情况。

当我们单独调用`changeUserLevel()`或`changeUserRole()`时也处于事务中。
所有请在需要事务的地方就开启事务吧，剩下的交给wulaphp。

## 异常处理 {#exception}

当我们将代码封装在`trans`或`Table::trans`里时，代码抛出的一般异常被视为事务处理失败需要回滚的标志，
`trans`抓到这个异常后就会回滚事务，但并不会把它抓到异常抛出再次抛出，一般情况下这没问题。
But，假如我们真的需要这个异常呢? wulaphp提供了一个超简单的解决方案，可以让`trans`自动回滚事务的同时
并把异常再次抛出，只需要这个异常实现`wulaphp\db\IThrowable`接口。嗯，只需要向下边这样定义异常:

```php
class MyException extends Exception implements IThrowable{
    ...
}
```

如果你确定你的代码有可能抛出`IThrowable`类型的异常，请一定要这样调用`trans`或`Table::trans`:

```php
try{
    $db = App::db();
    $db->trans(function ($con) use($uid,$rid) {
        // 变更用户角色操作
        $rst = ...
        if(!$rst){
            throw new MyException();
        }
        return $rst;
    });
}catch(MyException $e){
    // 你的异常处理代码
}
```

### 已知可抛出异常 {#ve}

`\wulaphp\validator\ValidateException` 数据校验异常
