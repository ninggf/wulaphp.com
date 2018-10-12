---
title: 公共函数库
type: guide
order: 607
---

最喜欢PHP了，不仅支持面向对象编程，还支持面向过程编程，wulaphp提供的[wula/common](https://github.com/ninggf/wula-common/blob/master/common.php)包(可独立使用)里有些好用的函数(你可以直接读代码)，供君享用:

1. `aryget($name, $array, $default = '')` 从数组取值，如果数组中无指定key，则返回默认值.
    * $name - key
    * $array - 从这里取值
    * $default - 默认值
2. `pure_comman_string($string)` 将以',',' ','　','-',';',';','－'分隔的字符串转换成以逗号分隔的字符.
3. `in_atag($content, $tag)` 判断$tag是否在A标签中或是某个标签的属性.
    * $content - html代码
    * $tag - 标签
    ```php
    $rst = in_atag('这是一篇关于<a href="/">wulacms</a>的文档','wulacms');
    // $rst = true;
    ```
4. `the_media_src($url)` 生成图片（特指用户上传的图片）URL。
5. `trailingslashit($string)` 在$string添加'/'
6. `untrailingslashit($string)` 删除$string尾部的'/'或'\\'
7. `sanitize_file_name($filename)` 去除文件名中不合法的字符.
8. `unique_filename($dir, $filename, $unique_filename_callback = null)` 获取$dir目录下唯一的文件名.
9. `find_files($dir = '.', $pattern = '', $excludes = [], $recursive = 0, $stop = 0)` 在目录$dir查找文件.
    * $dir - 在哪个目录查的
    * $pattern - 查找规则
    * $excludes - 排除规则
    * $recursive - 是否递归查找
    * $stop - 递归层数
10. `rmdirs($dir, $keep = true)` 删除目录下的所有内容
    * $dir - 要删除的目录
    * $keep - 目录里的内容删除后是否保留$dir
11. `keepargs($url, $include = [])` 只保留URL中部分参数.
    * $url - URL
    * $include - 要保留的参数
    ```php
    $url = 'http://www.abc.com/?name=1&age=2&sex=2';
    $url = keepargs($url,['name','sex']);
    // $url = 'http://www.abc.com/?name=1&sex=2'
    ```
12. `unkeepargs($url, $exclude = [])` 删除URL中的参数
    * $url - URL
    * $exclude - 要删除的参数
    ```php
    $url = 'http://www.abc.com/?name=1&age=2&sex=2';
    $url = unkeepargs($url,['age']);
    // $url = 'http://www.abc.com/?name=1&sex=2'
    ```
13. `safe_ids($ids, $sp = ',', $array = false)` 安全数字ID.
    * $ids - 以$sp分隔的id列表,只能是大与0的整数.
    * $sp - 分隔符.
    * $array - 是否返回数组.
    ```php
    $ids = safe_ids('1,a,2,3,4,b',',',true);
    //$ids = [1,2,3,4]
    $ids1 = safe_ids('1,a,2,3,4,b');
    //$ids1 = '1,2,3,4';
    ```
14. `safe_ids2($ids, $sp = ',')` 返回安全ID数组，见`safe_ids`.
15. `array_merge2($base, $arr)` 合并$base与$arr.
    * 如果$base为空或$base不是一个array则直接返回$arr,反之返回array_merge($base,$arr)
16. `get_query_string()` 返回请求字符串.
17. `url_append_args($url, $args)` 为url添加参数。
18. `ary_kv_concat(array $ary, $concat = '=', $quote = true, $sep = ' ')` 将array的key/value通过$sep连接成一个字符串.
    * $ary - 要操作的数组
    * $concat - 连接符，默认为'='
    * $quote - 连接时值是否用双引号包裹.
    * $sep - 分隔符,默认为空格
    ```php
    $pros = ary_kv_concat(['id'=>'abc','href'=>'#abc']);
    //$pros = 'id="abc" href="#abc"'
    ```
19. `ary_concat(array $ary1, array $ary2, $sep = ' ')` 合并二个数组，并将对应值通过$sep进行连结(concat).
    * $ary1 - 被加数组.
    * $ary2 - 数组.
    * $sep - 分隔符，默认为空格
    ```php
    $props = ary_concat(['class'=>'cls1 cls2','id'=>'abc'],['class'=>'cls3']);
    //$props = ['class'=>'cls1 cls2 cls3','id'=>'abc']
    ```
20. `rand_str($len = 8, $chars = "a-z,0-9,$,_,!,@,#,=,~,$,%,^,&,*,(,),+,?,:,{,},[,],A-Z")` 生成随机字符串.
21. `authcode($string, $operation = 'DECODE', $key = '', $expiry = 0)` 来自ucenter的加密解密函数.
22. `get_then_unset(&$ary,...$key)` 从数据$ary取数据并把它从原数组中删除.
    * $ary - 取值数组
    * ...$key - 可以有多个，要取值的key
    ```php
    $ary  = ['a'=>1,'b'=>2,'c'=>3];
    $data = get_then_unset($ary,'a','b');
    //$data=['a'=>1,'b'=>2]
    //$ary=['c'=>3]
    ```
23. `get_for_list($ary, ...$name)` 从数据$ary取数据.
    * $ary - 原数组
    * ...$name - 可以有多个，要取值的key
    ```php
    $ary  = ['a'=>1,'c'=>3];
    $data = get_for_list($ary,'a','b');
    //$data=['a'=>1,'b'=>'']
    ```
24. `unget(&$ary, $key)` 从$ary中获取$key对应的值并将其从$ary中删除.
25. `inner_str($str, $str1, $str2, $include_str1 = true)` 从$str中截取$str1与$str2之间的字符串.
26. `throw_exception($message)` 抛出一个异常以终止程序运行.

这么多年积累下来的有用的函数，都在这了。
