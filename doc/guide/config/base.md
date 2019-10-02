---
title: 基础配置
index: base
showToc: 0
desc: wulaphp基础配置，让wulaphp按你的想法运行
---

`conf/config.php`为`wulaphp`的默认配置，系统在启动时会自动加载。

## 默认配置

下方代码即为`wulaphp`的全部默认配置项:

```php
return [
    'debug'          => env('debug', DEBUG_DEBUG),//日志级别
    'timezone'       => 'Asia/Shanghai',// 时区
    'expire'         => 0,// 会话过期时间单位秒
    'static_base'    => '',// 静态资源Base URL
    'cdn_base'       => '',// CDN资源Base URL
    'ssn'            => 'file:path=storage',// 存储器配置
    'domains'        => [],// 模块域名绑定配置
    'alias'          => [],// 模块别名配置
    'proxy'          => [ //curl代理配置
        'type' => '',// 代理类型,可选值http,SOCKS4,SOCKS5,SOCKS4A
        'auth' => '',// 认证
        'port' => '',// 端口
        'host' => ''// 代理服务器
    ],// curl代理设置
    'cookie'         => [
        'expire'   => 0, // 过期时间,单位秒
        'path'     => '/', // 路径
        'domain'   => '', // 域名
        'security' => false //启用安全
    ],
    'upload'         => [
        'path'  => 'files',//文件上传保存根目录（相对于wwwroot)
        'dir'   => 1, // 存储目录，0:按年；1:按年月；2:按年月日
        'group' => 0, // 存储分组数，当上传量比较大时可以设置此值
    ],
    'resource'       => [
        'combinate' => 0,// 是否合并js,css
        'minify'    => 0 // 是否压缩模板文件中的js,css
    ]
]
```

### 简单说明

1. `static_base` 影响Smarty变量修饰器`assets`、`vendor`和函数`App::assets()`、`App::vendor()`。
2. `cdn_base` 影响Smarty变量修饰器`cdn`和函数`App::cdn()`。
3. `ssn` 存储器配置，详见[存储器](../utils/storage.md)。
4. `domains` 模块域名绑定配置，模块和域名绑定后，只能通过绑定的域名访问。
5. `alias` 模块别名设置，设置后只能通过别名访问模块。
6. `upload` 文件上传配置，详见[文件上传](../utils/uploader.md)。
7. `resource.combinate` 影响Smarty函数[combinate](../advance/smarty.funcs.md#combinate)。
8. `resource.minify` 影响Smarty函数[minify](../advance/smarty.funcs.md#minify)。
9. `proxy` 详见[curl扩展](http://php.net/manual/zh/function.curl-setopt.php)。
   * `type`为空，不使用代理。
