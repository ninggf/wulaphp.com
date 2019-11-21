---
title: 查询
showToc: 1
index: query select
keywords: query select 数据库查询 mysql 选择语句 mysql查询 数据库操作
type: guide
order: 15
desc: 优雅的数据库（mysql）查询(query,select)操作方式
---


在[数据库连接](index.md)中使用数据库连接直接进行数据库操作，实在是太暴力。本文档提供一个不那么暴力的简单访问方式。

## SimpleTable {#simple}

她是[View](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/View.php)的子类，仅提供查询功能，想对数据库进行『增删改』请传送至[模型](model.md)。

获取SimpleTable实例的两种方式:

1. `$table = App::table('tablename'[,$db])`
2. `$table = new SimpleTable('tablename'[,$db])`

> $db为可选参数，默认为'default'数据库连接。

有了SimpleTable实例，请尽情玩耍吧。

## 查询初探 {#start}

wulaphp使用看上去还不错的链式查询大概如下:

```php
$table = \wulaphp\app\App::table('user');

$query = $table->select('USER.*, GP.*, CLASS.name AS class_name')
    ->join('{usergroup} AS GP', 'User.gid = GP.id')
    ->join('{classes} AS CLASS', 'User.cid=CLASS.id')
    ->where(['User.id >' => 1,'GP.id'=>2])
    ->asc('CLASS.id');
```

对应的SQL：

```sql
SELECT User.*, GP.*, CLASS.name AS class_name 
    FROM user AS User
    LEFT JOIN usergroup AS GP ON User.gid = GP.id
    LEFT JOIN classes AS CLASS ON User.cid = CLASS.id
    WHERE User.id > 1 AND GP.id = 2
    ORDER BY CLASS.id ASC
```

可以通过`$query->getSqlString()`得到wulaphp生成的SQL:

```sql
SELECT `User`.*,`GP`.*,`CLASS`.`name` AS `class_name`
    FROM user AS User
    LEFT JOIN  usergroup AS GP ON (User.gid = GP.id)
    LEFT JOIN  classes AS CLASS ON (User.cid=CLASS.id)
    WHERE `User`.`id` > :User_id_0 AND `GP`.`id` = :GP_id_0
    ORDER BY `CLASS`.`id` ASC
```

> 说明:
>
> `:User_id_0`和`:GP_id_0`是通过`PDO::prepare`生成的`prepareStatement`的参数，在将执行时赋值。wulaphp使用prepareStatement以防止SQL注入攻击。
>
> 链式调用的好处是调用顺序与SQL表达很像，心中所想即为调用所写，信手拈来。

### 结果获取 {#result}

上例中的`$query`是[Query](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/sql/Query.php)类的实例，
她代表一个查询，可以通过她的以下方法获取结果:

1. 直接通过`foreach`循环遍历结果集

    ```php
    foreach ($query as $row){
        $data = $row->ary();
    }
    ```

2. `toArray`将查询到的结果集转换为数组

    ```php
    $rows = $query->toArray()
    ```

3. 以数组的方式获取记录（数组）

    ```php
    $data = $query[1];
    ```

4. 直接获取第一条结果中字段值

    ```php
    $value = $query['class_name'];
    ```

5. 以属性方式获取第一条结果中的字段值

    ```php
    $value = $query->class_name;
    ```

6. 通过`get`方法获取指定记录结果中的字段值

    ```php
    $className = $query->get(2,'class_name');
    ```

7. 通过`total`方法获取满足条件的记录总数

    ```php
    $total = $query->total('User.id');
    ```

8. 通过`count`方法获取满足条件的记录总数(不是本次查询到的记录总数)

    ```php
    $total = count($query);
    ```

9. 通过`first`获取第一条记录（数组）

    ```php
    $data = $query->first();
    ```

10. 通过`implode`将结果记录中对应字段连接起来

    ```php
    $class_names = $query->implode('class_name', ',', function ($className) {
        return strtoupper($className);
    });
    ```

11. 通过`ary`将当前(通过foreach遍历时)记录或第一条记录转换为数组

    ```php
    $data = $query->ary();
    ```

12. 通过`recurse(&$crumbs, $idkey = 'id', $upkey = 'upid')`递归生成结果数组

    ```php
        $crumbs = [];
        // 适用于通过upid树型结构设计的表
        $query->recurse($crumbs);
    ```

13. 通过`exist`判断符合条件的结果存不存在

    ```php
        if($query->exist('User.id')){
            // 存在时要干的事
        }
    ```

14. 通过`tree`生成树型SELECT选项

    ```php
    $options = [];
    // 适用于通过upid树型结构设计的表
    $query->treeKey('id')->treepad(true)->tree($options,'id','upid','name');
    ```

15. 通过`forupdate`获取第一条结果记录并锁定表(需要在[事务](trans.html)中)

    ```php
    //开始事务，forupdate需要在事务中调用.
    $table->db()->start();
    $data = $query->forupdate();
    // 其它操作
    $table->db()->commit();
    ```

16. 通过ORM机制获取相关表的字段，请传送至[ORM](orm.md)

### 动态添加字段 {#dyfield}

通过[Query](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/sql/Query.php)的`field`方法可以随时添加一个查询字段:

```php
$query->field('CLASS.master', 'teacher');
```

添加classes表的master字段到查询语句，结果如下:

```sql
SELECT User.*, GP.*, CLASS.name AS class_name, CLASS.master AS teacher
```

> 字段是一个[子查询](#subquery)时特别有用.

## 分页查询 {#pagination}

1. 最原生的最形象的方式(从第10条记录开始获取100条):

    ```php
    $query = $table->select('USER.*, GP.*, CLASS.name AS class_name')
        ->join('{usergroup} AS GP', 'User.gid = GP.id')
        ->join('{classes} AS CLASS', 'User.cid=CLASS.id')
        ->where(['User.id >' => 1,'GP.id'=>2])
        ->asc('CLASS.id')
        ->limit(10,100);
    ```

2. 或者用`page`读取第一页的20条记录（0-20）:

    ```php
    $query->page(1,20);
    ```

    使用用户通过GET或POST方法传来的参数pager[page],pager[limit]

    ```php
    //不给参数就可以了^_^
    $query->page();
    ```

    > page方法的第二个参数为分页大小，默认是20条记录。

## 分组查询 {#groupby}

上代码

```php
$query->groupBy('CLASS.id')->groupBy('GP.id');
```

## 排序 {#orderby}

### asc升序 {#asc}

```php
$query->asc('f1')->asc('f2');
```

### desc降序 {#desc}

```php
$query->desc('f1')->asc('f2')
```

### sort自定义 {#sort}

1. 指定字段（多个字段用逗号分隔,a升序，d降序）

    ```php
    $query->sort('f1,f2','a,d');
    ```

2. 使用用户通过GET或POST方法传来的参数`sort[name]`、`sort[dir]`

    ```php
    $query->sort();
    ```

> sort方法的第二个参数为排序方向，默认为a升序。

## JOIN {#join}

`join`方法你看到喽，`join`默认是左连接(LEFT JOIN)。通过第三个参数来改变连接方式如下:

```php
//左
$query->join('{abc} AS ABC','T.id = ABC.id');
//右
$query->join('{abc} AS ABC','T.id = ABC.id',Query::RIGHT);
//INNER
$query->join('{abc} AS ABC','T.id = ABC.id',Query::INNER);
```

右连接的快捷方式:

```php
$query->right('{abc} AS ABC','T.id','ABC.id');
```

INNER连接的快捷方式:

```php
$query->inner('{abc} AS ABC','T.id','ABC.id');
```

左连接的快捷方式:

```php
//真需要我写出来吗？
$query->left('{abc} AS ABC','T.id','ABC.id');
```

## HAVING {#having}

查出学生数量大于10的班级：

```sql
SELECT COUNT(User.cid) AS total, CLASS.*
    FROM user AS User
    LEFT JOIN classes AS CLASS ON User.cid = CLASS.id
    GROUP BY User.cid
    HAVING total > 10
```

代码如下:

```php
$table = \wulaphp\app\App::table('user');
$query = $table->select('CLASS.*')
               ->join('{classes} AS CLASS', 'User.cid=CLASS.id');
$query->field(imv('COUNT(User.cid)'), 'total');//HAVING字段
$query->groupBy('User.cid');
$rst   = $query->having('total > 10');
```

> **特别说明**
>
> `imv`函数用于生成SQL内部表达式，比如此例中的COUNT函数，更多的还有:
>
> 1. `UPDATE abc SET num=num+1`语句中的`num+1`。
> 2. `SELECT * FROM abc LEFT JOIN def ON abc.fid = def.id WHERE abc.name = def.name`语句中的`def.name`。
> 3. 其它更多的表达式都需要通过imv函数生成不然会报错地!!!

## 子查询 {#subquery}

通过子查询方式查出学生数量大于10的班级：

```sql
SELECT *,
    (SELECT COUNT(*) FROM `user` AS User WHERE User.cid = C.id) AS total
    FROM classes AS C
    HAVING total > 10
```

上代码:

```php
$tableClass = \wulaphp\app\App::table('classes');
$tableUser  = \wulaphp\app\App::table('user');
//主查询
$query = $tableClass->alias('C')->select('*');
//子查询
$subQuery = $tableUser->select(imv('COUNT(*)'))->where(['cid' => imv('C.id')]);
//子查询做为主查询的一个字段
$query->field($subQuery, 'total');
//添加条件
$query->having('total > 6');
```

> **再次强调**
>
> `imv`函数用于生成SQL内部表达式。
>
> 1. `COUNT(*)` 是函数调用，不是字符.
> 2. `WHERE cid = C.id`中的C.id是主表的字段，不是字符。

## 查询条件 {#where}

将数组丢给`where`就可以了，还算简单吧。

### 等于 {#eq}

```php
$where['name'] = 'Leo';
```

### 不等于 {#ne}

```php
$where['name !='] = 'Leo';
//或者
$where['name <>'] = 'Leo';
```

### 大于，小于 {#lg}

```php
// 大于
$where['age >'] = 10;
// 小于
$where['age <'] = 50;
```

### 大于等于，小于等于 {#lge}

```php
//懒得提供示例
```

### IN/NOT IN {#in}

```php
$where['cid IN']  = [1,2,3];
$where['cid @']   = [1,2,3];

$where['gid !IN'] = [4,5,6];
$where['gid !@'] = [4,5,6];
```

### LIKE/NOT LIKE {#like}

```php
$where['name LIKE'] = '%Leo%';
$where['name %']    = '%Leo%';

$where['name !LIKE'] = '%Leo%';
$where['name !%'] = '%Leo%';
```

### NULL/NOT NULL {#null}

```php
// image IS NULL
$where['image $'] = null;
// image IS NOT NULL
$where['image $'] = true;
```

### BETWEEN/NOT BETWEEN {#between}

```php
$where['age #']  = [10,50];
$where['age !#'] = [10,50];
```

### EXISTS/NOT EXISTS {#exists}

```php
$query = $table->select();
//EXISTS
$where['@'] = $query;
//NOT EXISTS
$where['!@'] = $query;
```

### 正则(不是所有数据库都支持) {#regex}

```php
//匹配
$where['name ~'] = '^Le.+$';
//不匹配
$where['name !~'] = '^Le.+$';
```

### 全文匹配(不是所有数据库都支持) {#fulltext}

```php
$where['content *'] = 'Abc';
```

### 且(abc = 1 AND def = 1) {#and}

```php
$where['abc'] = 1;
$where['def'] = 2;
```

### 或(abc = 1 OR abc = 2) {#or}

```php
$where['abc'] = 1;
$where['||abc'] = 2;
```

### 或((abc = 1 AND def = 1) OR (abc =2 AND def = 2)) {#or2}

```php
$w1['abc'] = 1;
$w1['def'] = 1;

$w2['abc'] = 2
$w2['def'] = 2;

$where[] = $w1;
$where['||'] = $w2;
```

更多的查询条件，请看[Condition类的源代码](https://github.com/ninggf/wulaphp/blob/master/wulaphp/db/sql/Condition.php)吧。

## 快捷查询 {#quick}

### find - 获取列表 {#find}

```php
/**
 * 获取列表.
 *
 * @param array       $where  条件.
 * @param array|mixed $fields 字段或字段数组.
 * @param int|null    $limit  取多少条数据，默认10条.
 * @param int         $start  开始位置
 *
 * @return Query 列表查询.
 */
public function find($where = null, $fields = null, $limit = 10, $start = 0)
```

### findAll - 获取全部数据列表(数据量大时不要用哦) {#findAll}

```php
/**
 * 获取全部数据列表.
 *
 * @param array       $where  条件.
 * @param array|mixed $fields 字段或字段数组.
 *
 * @return Query
 */
public function findAll($where = null, $fields = null)
```

### map - 获取key/value数组 {#map}

```php
/**
 * 获取key/value数组.
 *
 * @param array  $where      条件.
 * @param string $valueField value字段.
 * @param string $keyField   key字段.
 * @param array  $rows       初始数组.
 *
 * @return array 读取后的数组.
 */
public function map($where, $valueField, $keyField = null, $rows = [])
```

### count - 符合条件的记录总数 {#count}

```php
/**
 * 符合条件的记录总数.
 *
 * @param array  $con 条件.
 * @param string $id  字段用于count的字段,默认为*.
 *
 * @return int 符合条件的记录总数.
 */
public function count($con, $id = null)
```

### exist - 是否存在满足条件的记录 {#exist}

```php
/**
 * 是否存在满足条件的记录.
 *
 * @param array  $con 条件.
 * @param string $id  字段.
 *
 * @return boolean 有记数返回true,反之返回false.
 */
public function exist($con, $id = null)
```

### get - 取一条记录 {#get}

```php
/**
 * 取一条记录.
 *
 * @param int|array $id
 * @param string    $fields 字段,默认为*.
 *
 * @return Query 记录.
 */
public function get($id, $fields = '*')
```

### json_decode - 将json格式的字段值解析为array {#json}

```php
/**
 * 将json格式的字段值解析为array.
 *
 * @param int|array $id    主键或条件.
 * @param string    $field 字段.
 *
 * @return array
 */
public function json_decode($id, $field)
```

## 接下来 {#next}

查询搞得不丑，『增删改』哪儿去了？请立即传送至[模型](model.md)。
