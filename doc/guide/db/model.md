---
title: 数据模型
index: 模型 model
keywords: 模型 model 数据库模块 datamodel DAO
desc: 利用数据模型进行高效的数据库操作
---

项目大了，数据库操作复杂了，散落在代码中的数据库操作(很多人特别喜欢直接在控制器里干这事)让项目变得几乎不可维护。
所以有了DAO（Database Access Object）, 所以有了模型(Model)，它们把数据库的『增删改查』集中到一起便于维护，这便是MVC中的M（Model）。
每个MVC框架实现的模型机制可能都不一样，八仙过海各显神通。在wulaphp框架里通过继承[View](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/View.php)类与[Table](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/Table.php)类定义一个模型.

## 定义 {#define}

模型类的命名规则: `<TableName>[Table|View|ModelForm]`。 其中`TableName`为表名(表名约定为小写)的驼峰表示法,如:

1. `user`表的合法模型类名为`UserTable`、`UserView`、`UserModel`或`User`
2. `user_group`表的合法模型类名为 `UserGroup[Table|View|Model]`
3. `usergroup`表的合法模型类名为`Usergroup[Table|View|Model]`

可以通过继承[View](#view)或[Table](#table)实现数据模型。

### View类 {#view}

View类是视图模型基类，定义了所有[查询相关](query.md)的操作（只有查询没有增删改）比如在[连接数据库](../db.md)文档中创建的user表，它的模型定义如下:

```php
class UserTable extends \wulaphp\db\View {
}
```

### Table类 {#table}

Table类是表模型基类，提供『增删改查』全功能的基础模型, 定义如下:

```php
class UserTable extends \wulaphp\db\Table {
}
```

### 指定表名 {#tbname}

如果想自定义模型类对应的表名(遗留系统可能会有这样的需求)则可通过如下代码实现模型类与表的对应：

```php
class UserAbcModel extends \wulaphp\db\View {
    public $table = 'user';
}
```

只需要用`$table`变量定义真实表名即可。

## 使用模型 {#use}

使用模型前首先要创建模型的实例：

1. 使用默认数据库配置.

    ```php
    $user = new UserTable();
    ```

2. 使用其它数据库配置,更多关于[数据库配置](../config/db.md).

    ```php
    $user = new UserTable('cfg_name');
    ```

## 查询 {#query}

详见[查询](query.md)。

## 新增 {#create}

通过[Table](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/Table.php)基类提供的`insert`、`update`和`delete`方法可以很方便的对数据库进行『增删改』。只是这些方法都是`protected`（受保护）的，只能在子类中被访问。
新增数据有两个方法:

1. 单个新增使用`insert`方法
2. 批量新增使用`inserts`方法

### 单个新增 {#create1}

在`UserTable`(继承自Table的那个)类新增方法`addUser`:

```php
public function addUser($user) {
    $userId = $this->insert($user);

    return $userId;
}
```

调用如下:

```php
$userTable = new UserTable();
$user = [
    'username' => 'user6',
    'nickname' => '小王',
    'hash'     => md5('123321'),
    'phone'    => '13811111111',
    'email'    => 'abc@aaaa.com'
];
$id = $userTable->addUser($user);
```

就这样。`insert`的声明如下:

```php
/**
 * 创建记录.
 *
 * @param array    $data 数据.
 * @param \Closure $cb   数据处理函数.
 *
 * @return bool|int 成功返回true或主键值,失败返回false.
 * @throws
 */
protected function insert($data, $cb = null)
```

可以通过`$cb`对数据进行清洗哦。

### 批量新增 {#create2}

在`UserTable`(继承自Table的那个)类新增方法`addUsers`:

```php
public function addUsers($users) {
    return $this->inserts($users);
}
```

调用如下:

```php
$userTable = new UserTable();
$users[] = [
    'username' => 'user6',
    'nickname' => '小王',
    'hash'     => md5('123321'),
    'phone'    => '13811111111',
    'email'    => 'abc@aaaa.com'
];
$users[] = [
    'username' => 'user7',
    'nickname' => '小王七',
    'hash'     => md5('123321'),
    'phone'    => '13811111111',
    'email'    => 'abc@aaaa.com'
];
$rtn = $userTable->addUsers($users);
```

就这样。`inserts`的声明如下:

```php
/**
 * 批量插入数据.
 *
 * @param array    $datas 要插入的数据数组.
 * @param \Closure $cb
 *
 * @return bool|array 如果配置了自增键将返回自增键值的数组.
 * @throws
 */
protected function inserts($datas, \Closure $cb = null)
```

可以通过`$cb`对数据进行清洗哦。

## 删除 {#delete}

删除数据有两个方法:

1. 软删使用`recycle`方法（将deleted字段置为1）
2. 彻底删除`delete`方法

根据用户ID(主键)删除用户:

```php
public function deleteUserById($id) {
    return $this->delete($id);
}
```

根据用户账户删除用户:

```php
public function deleteUserByUsername($username) {
    $where['username'] = $username;

    return $this->delete($where);
}
```

### 高级删除 {#delete2}

不给`delete`方法提供参数时它将返回一个[DeleteSQL](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/sql/DeleteSQL.php)实例。通过这个实例，可以完成一些高难度的删除操作。

**仅删除一条记录,SQL语句是这样的:**

```sql
DELETE FROM user WHERE cid = 1 ORDER BY gid ASC LIMIT 1;
```

在`UserTable`类添加方法`deleteOneUserByCid`:

```php
public function deleteOneUserByCid($cid) {
    $sql = $this->delete()->where(['cid' => $cid])->asc('gid')->limit(0, 1);

    return $sql->exec();
}
```

**删除班主任是王老师的所有学生,SQL语句是这样的:**

```sql
DELETE user
    FROM user AS User
    LEFT JOIN classes AS C ON (User.cid = C.id)
    WHERE C.master = '王老师'
```

在`UserTable`类添加方法`deleteUserByMaster`:

```php
public function deleteUserByMaster($master) {
    $sql = $this->delete();
    $sql->left('{classes} AS C', 'User.cid', 'C.id');
    $sql->where(['C.master' => $master]);

    return $sql->exec();
}
```

### 软删除 {#recycle}

`recycle`方法请直接看源代码:

```php
/**
 * 回收内容，适用于软删除(将deleted置为1).
 * 所以表中需要有deleted的字段,当其值为1时表示删除.
 * 如果uid不为0,则表中还需要有update_time与update_uid字段,
 * 分别表示更新时间与更新用户.
 *
 * @param array    $where 条件.
 * @param int      $uid 如果大于0，则表中必须包括update_time(unix时间戳)和update_uid字段.
 * @param \Closure $cb  回调.
 *
 * @return boolean 成功true，失败false.
 * @throws
 */
protected function recycle($where, $uid = 0, $cb = null)
```

## 修改 {#update}

通过`update`方法实现数据库修改操作。

根据用户ID修改用户信息,在`UserTable`中添加方法`updateUserById`:

```sql
UPDATE user SET username = 'new User Name' WHERE id = 1
```

```php
public function updateUserById($name, $id) {
    return $this->update(['username' => $name], $id);
}
```

就这样。`update`方法声明如下:

```php
/**
 * 更新数据或获取UpdateSQL实例.
 *
 * @param array|null $data 数据.
 * @param array|null $con  更新条件.
 * @param \Closure   $cb   数据处理器.
 *
 * @return bool|UpdateSQL 成功true，失败false；当$data=null时返回UpdateSQL实例.
 * @throws
 */
protected function update($data = null, $con = null, $cb = null)
```

同『增』一样可以通过`$cb`对数据进行清洗哦。

### 高级修改 {#update2}

不给`update`方法提供参数时它将返回一个[UpdateSQL](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/sql/UpdateSQL.php)实例。通过这个实例，可以完成一些高难度的修改操作。

1. 只更新满足条件的前2条记录

    ```sql
    UPDATE user SET cid = 3 WHERE gid = 1 ORDER BY cid ASC limit 2
    ```

    在`UserTable`类添加方法`updateUserByGid`:

    ```php
    public function updateUserByGid($cid, $gid) {
        $sql = $this->update()->set(['cid' => $cid])->where(['gid' => $gid]);
        $sql->asc('cid')->limit(0, 2);

        return $sql->exec();
    }
    ```

2. 把王老师班上的学生都调整到第三组

    ```sql
    UPDATE user AS User, classes AS C
        SET User.gid = 3
        WHERE User.cid = C.id AND C.master = '王老师'
    ```

    在`UserTable`类添加方法`updateUserByMaster`:

    ```php
    public function updateUserByMaster($gid, $master) {
        $sql = $this->update()->from('{classes} AS C')->set(['User.gid' => $gid]);
        $sql->where(['User.cid' => imv('C.id'), 'C.master' => $master]);

        return $sql->exec();
    }
    ```

    > 1. 因为更新user表需要使用到classes表，所有要通过`from`方法将`classes`表引入。
    > 2. `imv`相关内容请传送至[简单访问](query.md#having)HAVING和子查询。

### 批量更新 {#update3}

仅适用于场景:SQL结构相同（更新的字段相同，条件字段相同，只是他们的值不同）。

```sql
UPDATE user SET phone = '1' WHERE username = 'user1';
UPDATE user SET phone = '2' WHERE username = 'user2';
UPDATE user SET phone = '3' WHERE username = 'user3';
UPDATE user SET phone = '4' WHERE username = 'user4';
```

添加一个更新方法`updatePhoneByUsername`:

```php
public function updatePhoneByUsername($phones) {
    $sql = $this->update();
    $sql->set($phones, true);

    return $sql->exec();
}
```

代码很简单，关键看调用:

```php
$userTable = new UserTable();
$phones[] = [['phone'=>1],['username'=>'user1']];
$phones[] = [['phone'=>2],['username'=>'user2']];
$phones[] = [['phone'=>3],['username'=>'user3']];
$phones[] = [['phone'=>4],['username'=>'user4']];

$rst = $userTable->updatePhoneByUsername($phones);
```

> 传给`set`的数据格式定义如下: `[[[要修改的数据],[条件]],[要修改的数据],[条件]]]`

## 增改进阶 {#more}

`insert`、`inserts`和`update`都有一个匿名函数类型的参数`$cb`，用户可以通过此函数对数据进行修改。
这个`$cb`是每个具体调用方法的指定过滤器，每个方法都可以不同。Table类还有一个全局的数据过滤处理器`filterFields`。声明如下:

```php
/**
 * 过滤数据.
 *
 * @param array $data 要过滤的数据.
 */
protected function filterFields(&$data) {
}
```

它能干啥？举个例子，假设user表新增加了二个字段`update_time`更新时间和`update_uid`更新用户。如果每次新增或更新时都手动填写这二个字段有点傻傻的，可以将下边代码添加到`UserTable`类中完美解决这个问题:

```php
protected function filterFields(&$data) {
    if (!isset($data['update_time'])) {
        $data['update_time'] = time();
    }
    if (!isset($data['update_uid'])) {
        $data['update_uid'] = 0;
    }
}
```

> **特别强调**
>
> 此方法不适用于**新增与修改的高级用法**。

### 主键与自增 {#pk}

当我们执行`delete(1)`或`update(['name'=>'1'],1)`这样的操作时默认使用`id`作为模型（表）的主键。
当我们在新增数据时返回的数值也是默认把id做为自增字段处理的。
如果表的主键不是`id`或者主键不是自增的，我们可以通过下边的代码进行修改:

```php
//将主键修改为user_id
protected $primaryKeys = ['user_id'];
//主键不可自增
protected $autoIncrement = false;
```

如果一个表的主键是复合主键，需要像下边这样修改:

```php
//将主键修改为user_id,role_id
protected $primaryKeys = ['user_id','role_id'];
```

### 数据校验 {#validate}

如果你向下边这样定义模型，那么wulaphp在“增改”操作的时候还会自动为你做数据校验哦:

```php
class UserTable extends \wulaphp\db\Table {
    use \wulaphp\validator\Validator;
    /**
     * @required 这个字段是必须的
     */
    public $username;
    /**
     * @minlength (6) => 怎么着也要有6个字符吧
     */
    public $nickname;
    /**
     * @phone
     */
    public $phone;
    /**
     * @email 正确的邮箱来一个
     */
    public $email;
    /**
     * @passwd (3) => 密码强度不够哦
     */
    public $hash;
}
```

关于数据检验，请传送到[数据检验](../advance/validator.md)

## WHERE条件 {#where}

到[查询条件](query.md#where)处复习一下。
