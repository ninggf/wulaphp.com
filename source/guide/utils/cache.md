---
title: 缓存
type: guide
order: 600
catalog: 工具
---

缓存是应对大流量，高并发不可或缺的部分，wulaphp集成了一套使用简单、扩展灵活的缓存机制。
目前wulaphp内置的缓存支持`memcached`和`redis`做为缓存服务器(通过插件简单地扩展一下子就可以支持ssdb、leveldb等等缓存服务器了哦)。

## Cache类

wulaphp的缓存使用对应用是透明的，代码里你可以这样:

1. 获取缓存实例
    ```php
    $cacher = Cache::getCache();
    ```
2. 缓存数据
    ```php
    $cacher->add('cache_key', 'be cached value');
    ```
3. 获取数据
    ```php
    $value = $cacher->get('cache_key');
    ```
4. 删除缓存
    ```php
    $cacher->delete('cache_key');
    ```
5. 清空缓存
    ```php
    $cacher->clear();
    ```
6. 缓存是否存在
    ```php
    $cacher->has_key('cache_key');
    ```

看上去简单，使用起来好像也不难。But~~~，你得配置它。

> **特别说明**
>
> 1. 使用`memcached`请安装**memcached**扩展.
> 2. 使用`redis`请安装**redis**扩展.
>
> 如果你不想安装PHP扩展，请自定义缓存类。

## 缓存配置

你使用`memcached`还是`redis`还是`xxx`还是`yyy`还是`zzz`？不急咱一个一个来，打开`conf/cache_config.php`文件：

1. 配置`memcached`
    ```php
    $config = new \wulaphp\conf\CacheConfiguration();
    $config->enabled(true);
    $config->setDefaultCache('memcached');
    $config->addMemcachedServer('127.0.0.1', '11211', 50);
    $config->addMemcachedServer('192.168.1.100', '11211', 50);
    ```
    > **说明:**
    > 1. 可以添加多个`memcached`服务器，并合理分配它们的权重.
    > 2. 如果只有一台`memcached`服务器，权重应为:100
    > 3. `addMemcachedServer`方法有三个参数:
    >    1. host - 服务器IP/域名
    >    2. port - 端口(默认11211)
    >    3. weight - 权重(默认100)
2. 配置`redis`
    ```php
    $config = new \wulaphp\conf\CacheConfiguration();
    $config->enabled(true);
    $config->setDefaultCache('redis');
    $config->addRedisServer('localhost',6379, 8, 1);
    ```
    > `addRedisServer`有5个参数:
    > 1. host - 服务器IP/域名
    > 2. port - 端口(默认6379)
    > 3. database - 缓存在哪个库(默认0)
    > 4. timeout - 连接超时(默认1)
    > 5. auth - 认证密码（默认为空）
3. 其它缓存见下一节[自定义缓存](#自定义缓存)

> **友情提示**
> 1. `enabled`启用或停用缓存，没毛病吧。
> 2. `setDefaultCache`设置默认缓存
> 3. 可以在`conf/cache_config.php`中同时配置`memcached`和`redis`和其它缓存
>    * 通过`$config->addConfig($type, $cfg)`。

## 自定义缓存

开始自定义缓存之前有三个知识点要了解一下:

1. [Cache](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/cache/Cache.php)类 - 继承它实现你自己的缓存类。
2. 通过`get_{$type}_cache`勾子提供你自定义的缓存类实例($type为`Cache::getCache()`的参数)
    * `$cacher = Cache::getCache('ssdb')`的勾子为`get_ssdb_cache`。
3. 在`cache_config.php`配置你的缓存（如果需要配置的话）

开始实现一个假缓存（type为`fake`）做为演示:

1. 自定义缓存类`FakeCache`:
    ```php
    class FakeCache extends Cache {
        private $conf;

        public function __construct($cfg) {
            $this->conf = $cfg;
        }

        public function add($key, $value, $expire = 0) {
            //把$value添加到缓存,缓存时间为$expire	
        }

        public function get($key) {
            if ($key == 'aaa') {
                return 'bbb';
            } else {
                return null;
            }
        }

        public function delete($key) {
            // 删除缓存
        }

        public function clear($check = true) {
            //清空缓存
        }

        public function has_key($key) {
            return $key === 'aaa';
        }
    }
    ```
    > **真的好假啊**
    >
    > 几个方法是必须实现的:
    > 1. `add` 把内容添加到缓存
    > 2. `get` 取缓存
    > 3. `delete` 删除缓存
    > 4. `clear` 清空缓存
    > 5. `has_key` 缓存是否存在
2. 绑定勾子`get_fake_cache`提供`FakeCache`实例
    ```php
    bind('get_fake_cache',function($cache,$cfg){
        $cache = new FakeCache($cfg);
        return $cache;
    });
    ```
3. 假假的配置一下它(`conf/cache_config.php`中)
    ```php
    $config->addConfig('fake', ['aaa' => 'bbbb']);
    ```
4. 使用它
    ```php
    $cacher = Cache::getCache('fake');
    ```
5. 如果你愿意可以将设置它为默认缓存
    ```php
    $config->setDefaultCache('fake');
    ```

自己动手，丰衣足食!!
