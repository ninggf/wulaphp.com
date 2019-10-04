---
title: 文件上传
showToc: 0
index: upload
desc: 快捷地上传文件
---

{$toc}

在wulaphp中通过[UploadFile](#UploadFile)类和[文件上传器](#uploder)可以很方便的完成文件上传工作。

## UploadFile

通过此类可以很方便的完成通过表单上传的文件的保存任务:

```php
// 表单中file组件的name为file
$file = new \wulaphp\io\UploadFile('file');
// 保存
$filename = $file->save('files' . date('/Y/m/d/'));
```

嗯就是这么简单。如果你的表单上传的文件是数组:

```php
$files = $_FILES['files'];
foreach ($files as $upf) {
    $file     = new \wulaphp\io\UploadFile($upf);
    $filename = $file->save('files' . date('/Y/m/d/'));
}
```

### 构造函数 {#new}

参数:

1. `$name` **string|array** 参数名或上传的文件数组.
2. `$ext`  **array** 允许的扩展名列表(包括'.'，如:['.png','.gif']).
3. `$max`  **int** 允许的最大上传尺寸.

### save

参数

1. `$destdir` **string** 目的目录
2. `$fileName` **string|null** 指定要保存文件名(不包括扩展名)，默认为`null`使用上传的文件名.
3. `$random`  **bool** 是否随机生成文件名.

返回值:

**bool** 保存成功返回文件路径,失败返回`false`。

### last_error

返回值:

**string** 上传出错信息.

## 文件上传器 {#uploader}

UploadFile只能处理通过表单上传的文件且存储在本地，
如果你是通过其它方法上传文件（比如plupload,swfupload等)且不存储在本地，
wulaphp也提供了相应的解决方案: `Uploader`。
wulaphp内置了`LocaleUploader`(本地文件上传器)和`FtpUploder`，可以通过继承`\wulaphp\io\Uploader`实现自己的文件上传器。

代码中通过`$uploader = Uploader::getUploader()`获取系统默认的文件上传器或`$uploader = Uploader::getUploader('myUploader')`获取自定义文件上传器,
通过`$uploader->save()`将文件保存到它该保存的地方，比如阿里云OSS，千牛等等。

### LocaleUploder

要使用`LocaleUploder`做为系统默认文件上传器请向下边这样修改默认配置文件`conf/config.php`:

```php
[
    ...,
    'upload'=>[
        'uploader' => 'file',
        'path'     => 'files',//文件上传保存根目录（相对于wwwroot)
        'dir'      => 1, // 存储目录，0:按年；1:按年月；2:按年月日
        'group'    => 0, // 存储分组数，当上传量比较大时可以设置此值
    ],
    ...
]
```

或媒体配置文件`conf/media_config.php`:

```php
[
    'default_uploader'=>'file',
    'save_path'     => 'files',//文件上传保存根目录（相对于wwwroot)
    'dir'      => 1, // 存储目录，0:按年；1:按年月；2:按年月日
    'group_num'    => 0, // 存储分组数，当上传量比较大时可以设置此值
]
```

### FtpUploder

要使用`FtpUploader`做为系统默认文件上传器请修改`conf/media_config.php`配置文件:

```php
[
    'default_uploader'=>'ftp',
    'save_path'     => 'files',//文件上传保存根目录（相对于wwwroot)
    'dir'      => 1, // 存储目录，0:按年；1:按年月；2:按年月日
    'group_num'    => 0, // 存储分组数，当上传量比较大时可以设置此值,
    'params' => 'host=ftp_server_host&port=25&user=ftp&password=888&timeout=5&passive='//参数
]
```

> **params 说明**
>
> 1. `host`: FTP服务器主机名或IP
> 2. `port`: FTP端口
> 3. `user`: 用户名
> 4. `password`: 密码
> 5. `timeout`: 超时
> 6. `passive`: 被动模块

<p class="tip" markdown=1>需要`ftp`扩展才能使用`FtpUploader`!</p>

### 自定义文件上传器 {#custom}

继承`\wulaphp\io\Uploader`并实现以下方法:

1. `save` 保存上传的文件
    * 参数:
       1. `$filepath` **string** 已上传文件的路径
       2. `$path` **string|null** 目的目录，默认为`null`,由上传器决定
    * 返回值: **array** 关联数组
       1. `url` 相对于根路径的URL
       2. `name` 文件名
       3. `path` 存储路径
2. `getName` 上传器名称
    * 返回值: **string** 上传器名称
3. `delete` 删除文件
    * 参数:
        1. `$file` **string** 存储路径
    * 返回值: **bool** 是否成功
4. `thumbnail` 生成缩略图
    * 参数:
        1. `$file` **string** 存储路径
        2. `$w` **int** 宽
        3. `$h` **int** 高
    * 返回值: **string** 相对于根路径的URL
5. `close` 关闭上传器
6. `get_last_error` 返回错误信息.
    * 返回值: **string** 上传过程中发生的错误信息.

具体可以参考[LocaleUploader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/io/LocaleUploader.php)源代码实现你的文件上传器（需要把上传的文件保存到其它地方时）。
然后通过勾子`upload\getUploader`修改默认文件上传器,通过勾子`upload\regUploaders`将上传器注册到系统。

## UploadSupport

为你的控制器添加`UploadSupport`特性可以快速实现文件上传功能，详见[UploadSupport](../mvc/supports.md#UploadSupport)。
