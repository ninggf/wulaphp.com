---
title: 文件存储
showToc: 0
index: storage ssdb oss 千牛
desc: 将文件以合适的方式保存
---

很多时候，我们需要保存一些文件，简单点的可以使用`file_put_contents`，
复杂点的可以通过`FTP`把文件保存到远程FTP服务器上，更复杂点的可以把文件存储到阿里云的OSS，千牛，百度网盘等等。
`wulaphp`为保存文件提供了统一接口:`Storage`，且内置了两种实现:

1. [本地存储器](#local): 将文件内容存储到本地
2. [SSDB存储器](#ssdb): 将文件内容存储到SSDB

开发者可以根据需要继承`\wulaphp\io\StorageDriver`实现自己的存储器，并将其注册到系统即可,详见[自定义存储器](#custom)。

## 使用方法 {#usage}

开发者只需要像下边这样即可使用默认存储器存取文件:

```php
$storage = new Storage();
// 保存文件
$rst     = $storage->save('hello.txt', 'hello world!');
// 读取文件
$content = $storage->load('hello.txt');
// 删除文件
$rst     = $storage->delete('hello.txt');
```

上述代码将使用默认的文件存储器保存文件内容。可以通过修改[默认配置](../config/base.md)中的`ssn`来定制存储器。

## 本地存储器 {#local}

将文件内容保存到本地，注册前缀为`file:`，接受一个配置参数`path`，代码中可以像下边这样使用:

```php
$storage = new Storage('file:path=storage');
```

参数说明:

1. `path` 相对于项目根目录的目录。

## SSDB存储器 {#ssdb}

将文件内容存储到SSDB，注册前缀为`ssdb`，接受三个配置参数`host`、`port`、`timeout`, 代码中可以像下边这样使用:

```php
$storage = new Storage('ssdb:host=127.0.0.1;port=8888;timeout=5');
// 保存文件
$rst     = $storage->save('hello.txt', 'hello world!');
// 读取文件
$content = $storage->load('hello.txt');
// 删除文件
$rst     = $storage->delete('hello.txt');
```

参数说明

1. `host`: SSDB服务器地址
2. `port`: SSDB服务器监听端口，默认为`8888`
3. `timeout`: 连接超时，单位为秒，默认为`5`秒

## 自定义存储器 {#custom}

如果你需要将文件存储到其它地方，如：阿里云的OSS，千牛，百度网盘等等。
请继承`\wulaphp\io\StorageDriver`实现自己的存储器，并实现以下四个方法:

1. `save($filename, $content)` 保存文件。
2. `load($filename)` 加载文件内容。
3. `delete($filename)` 删除文件。
4. `initialize()` 初始化存储器。

实现上述方法后找一个合适的时机将你的存储器注册到系统，下边给个小示例:

1. 存储器代码:

    ```php
    namespace your\storage;
    class RedisStorage extends StorageDriver {
        private $redis = null;

        protected function initialize() {
            list($host, $port) = get_for_list($this->options, 'host', 'port');
            try {
                $this->redis = \wulaphp\util\RedisClient::getRedis(['host' => $host, 'port' => $port]);

                return true;
            } catch (Exception $e) {
                return false;
            }
        }

        public function save($filename, $content) {
            return $this->redis->set($filename, $content);
        }

        public function load($filename) {
            return $this->redis->get($filename);
        }

        public function delete($filename) {
            $this->redis->del($filename);
        }
    }
    ```

2. 注册存储器（比如在模块或扩展的引导文件中，或者在composer包的autoload中)

    ```php
    \wulaphp\io\Storage::registerDriver('redis', '\your\storage\RedisStorage');
    ```

3. 使用自定义存储器

    ```php
    $storage = new Storage('redis:host=127.0.0.1;port=8888');
    ```

如果你愿意请为`wulaphp`提供阿里云OSS，千牛等提供器吧。
