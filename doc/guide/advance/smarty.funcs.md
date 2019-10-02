---
title: Smarty 标签
showToc: 0
index: 1
---

{$toc}

wulaphp利用Smarty的扩展特性为其增加了一些函数，有了这些函数，让wulaphp更强大更灵活了呢。

## {cts} {#cts}

`{cts}`通过数据源获取数据集，并根据`loop`值决定是否遍历这个数据集。
`{cts}`与Smarty的`{foreach}`很像，除了以下三点不同，其它用法与`{foreach}`相同:

* 遍历的对象由数据源提供。
* 可通过设置`loop`属性为`false`关闭遍历功能。
* `{ctselse}`处理无可遍历数据情况

### 属性 {#pp}

|参数名称|类型|必选参数|默认值|说明|
|---|---|---|:---:|---|
|var|string|Y|N/A|数据集变量名|
|from|string|Y|N/A|[数据源](#数据源)ID|
|loop|bool|N|true|是否遍历这个数据集|
|`...`|mixed|N|N/A|数据源需要的属性|

### 数据源 {#ds}

所有继承[CtsDataSource](https://github.com/ninggf/wulaphp/blob/master/wulaphp/mvc/model/CtsDataSource.php)类并通过勾子`tpl\regCtsDatasource`将其实例注册到数据源管理器的类都可以做为`{cts}`的数据源为`{cts}`提供数据集。
每个数据源都可以有自己的属性，以便准确提供数据，只是要注意一点这些属性不能与`{cts}`的标准属性重名！
系统内置了一个超级简单的数据源`split`:

```php
class SplitDataSource extends CtsDataSource {
    public function getName() {
        return '分隔数据';
    }
    /**
    * @param array                          $con 属性数组
    * @param \wulaphp\db\DatabaseConnection $db  数据库连接
    * @param \wulaphp\router\UrlParsedInfo  $pageInfo 分页信息
    * @param array                          $tplvar 已经传到模板的变量
    *
    * @return \wulaphp\mvc\model\CtsData
    */
    protected function getData($con, $db, $pageInfo, $tplvar) {
        $content = aryget('content',$con);
        if (!$content) {
            return new CtsData([], 0);
        }
        $sp = aryget('sp', $con, ',');
        if (isset($con['r']) && $con['r']) {
            $content = @preg_split('#' . $con['r'] . '#', $content);
        } else {
            $content = @explode($sp, $content);
        }
        $contents = [];
        foreach ($content as $c) {
            $contents[] = ['val' => $c];
        }

        return new CtsData($contents, count($contents));
    }
}
```

根据上述代码，可以发现`splite`数据源自定义了三个属性:

1. `content`要分隔的内容
2. `sp`分隔字符，默认为','
3. `r`是否使用正则

实现一个数据源是不是很简单？！请按需实现你自己的数据源.

### 示例 {#example}

模板文件(使用`splite`数据源):

```html
<ul>
{cts var=tag from=splite sp=',' content="PHP,MVC,ORM"}
<li>{$tag.val}</li>
{/cts}
</ul>
```

结果输出:

```html
<ul>
<li>PHP</li>
<li>MVC</li>
<li>ORM</li>
</ul>
```

## {ctsp} {#ctsp}

`{ctsp}`用来对数据集(`CtsData`)进行分页,数据集可以是通过`{cts}`获取到的也可以是直接以变量名`_cts_{$var}_data`({$var}即`var`属性值)传递到模板的`CtsData`实例.

### 属性 {#ctspp}

|参数名称|类型|必选参数|默认值|说明|
|---|---|---|:---:|---|
|var|string|Y|N/A|分页数据变量名|
|for|string|N|N/A|`{cts}`的[`var`属性](#属性)|
|loop|bool|N|true|是否遍历分页数据|
|limit|int|N|10|每页条数|
|pp|int|N|10|一共显示多少页|

### 分页数据 {#ctspds}

|KEY|说明|
|---|---|
|total|总页数|
|ctotal|总条数|
|first|第一页URL|
|prev|上一页URL|
|next|下一页URL|
|last|最后一页URL|
|pages|页面列表，仅当`loop`为`false`时出现|
|1|页码`1`对应的URL|
|2|页码`2`对应的URL|
|...|页码...对应的URL|
|n|页码`n`对应的URL|

### 示例 {#example1}

模板文件:

```html
<h3>新闻</h3>
<ul>
{cts var=news from=page model=article limit='0,10'}
<li> <a href="{$news.url|url}">{$news.title}</a></li>
{/cts}
</ul>
<div>
分页:
{ctsp var=pp for=news limit=10 loop=0}
<ul>
    <li>{$_cp}/{$pp.total}</li>
    <li><a href="{$pp.first}">第一页</a></li>
    <li><a href="{$pp.prev}">上一页</a></li>
    {foreach $pp.pages as $pg=>$purl}
    <li><a href="{$purl}">{$pg}</a></li>
    {/foreach}
    <li><a href="{$pp.next}">下一页</a></li>
    <li><a href="{$pp.last}">最后页</a></li>
</ul>
{/ctsp}
</div>
```

模板文件2(遍历模式):

```html
<h3>新闻</h3>
<ul>
{cts var=news from=page model=article limit='0,10'}
<li> <a href="{$news.url|url}">{$news.title}</a></li>
{/cts}
</ul>
<div>
分页:
<ul>
{ctsp var=pp for=news limit=10}
    {if $pp@key=='total'}
    <li>{$_cp}/{$pp.total}</li>
    {elseif $pp@key=='prev'}
    <li><a href="{$pp}">上一页</a>
    {elseif $pp@key=='next'}
    <li><a href="{$pp}">下一页</a></li>
    {elseif $pp@key=='first'}
    <li><a href="{$pp}">第一页</a>
    {elseif $pp@key=='last'}
    <li><a href="{$pp}">最后页</a></li>
    {elseif is_numeric($pp@key)}
    <li><a href="{$pp}">{$pp@key}</a></li>
    {/if}
{/ctsp}
</ul>
```

## {combinate} {#combinate}

`{combinate}`可以将多个JS或CSS文件合并成一个文件.

### 属性 {#pp1}

|参数名称|类型|必选参数|默认值|说明|
|---|---|---|:---:|---|
|type|string|Y|N/A|文件类型,可选`js`、`css`|
|ver|string|N|1|版本号|

### 示例 {#example1}

模板文件:

```html
{combinate type=js ver="1.0"}
<script src="{'jquery.js'|assets}"></script>
<script src="{'common.js'|assets}"></script>
<script src="{'bootstrap.js'|assets}"></script>
{/combinate}
```

结果:

```html
<script src="/files/adsfaeadfasdfasdfadsfaafaas.js?ver=1.0"></script>
```

> 说明:
>
> 1. 需要在配置中开启合并功能`['resource'=>['combinate'=>1]]`
> 2. 可以通过`combinater\getPath`勾子修改合并后文件存储目录，默认为`files`。
> 3. 可以通过`combinater\getURL`勾子修改合并后文件的URL基地址,默认由`WWWROOT`常量定义。

## {minify} {#minify}

`{minify}`可以压缩直接写在模板文件中的JS和CSS代码。

### 属性 {#pp2}

|参数名称|类型|必选参数|默认值|说明|
|---|---|---|:---:|---|
|type|string|Y|N/A|代码类型,可选`js`、`css`|

### 示例 {#example2}

压缩JS:

```html
<script type="text/javascript">
{minify}
var abc = 1;
function add(num1,num2){
    return num1+num2;
}
var def = add(1,abc);
{/minify}
```

压缩CSS:

```html
<style>
{minify css}
body {
    color:red;
}
h1,h3{
    color:blue;
}
...
{/minify}
</style>
```
