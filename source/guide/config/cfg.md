---
title: 默认配置
type: guide
order: 201
---

## 配置文件

`conf/config.php`为wulaphp的默认配置，系统在启动时会自动加载。

## 配置项

下方代码即为wulaphp的全部默认配置项:

```php
return [
    'debug'          => DEBUG_WARN,//日志级别
    'timezone'       => 'Asia/Shanghai',// 时区
    'expire'         => 0,// 会话过期时间单位秒
    'static_base'    => '',// 静态资源Base URL
    'cdn_base'       => '',// CDN资源Base URL
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

**简单说明:**

1. `static_base` 影响Smarty变量修饰器`assets`、`vendor`和函数`App::assets()`、`App::vendor()`
2. `cdn_base` 影响Smarty变量修饰器`cdn`和函数`App::cdn()`
3. `resource.combinate` 影响Smarty函数[combinate](../advance/smarty.funcs.html#combinate)
4. `resource.minify` 影响Smarty函数[minify](../advance/smarty.funcs.html#minify)
5. `proxy` 详见[curl扩展](#http://php.net/manual/zh/function.curl-setopt.php)。
    * `type`为空，不使用代理。
