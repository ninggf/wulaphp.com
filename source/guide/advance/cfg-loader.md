---
title: 配置加载器
type: guide
order: 1099
---

## 默认加载器

当我们使用`App::cfg`系列方法获取配置时，wulaphp是通过配置加载器先加载配置然后再返回配置项对应值的（当然可以返回整个配置数组）。
配置加载器[ConfigurationLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/ConfigurationLoader.php)有两个方法:

1. `loadConfig` - 加载普通配置并返回[Configuration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/Configuration.php)实例或其子类的实例。
2. `loadDatabaseConfig` - 加载数据库配置并返回[DatabaseConfiguration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/DatabaseConfiguration.php)实例。

除了上述的两个方法还有两个方法，仅在加载**默认配置**时执行（来自[BaseConfigurationLoader](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/BaseConfigurationLoader.php)）:

1. `beforeLoad` - 加载**默认配置**前执行
2. `postLoad` - 加载**默认配置**后执行

默认的加载器已经可以很好的工作了，如果不能满足你，请自定义你的配置加载器。
默认配置在应用（App）启动时加载，其它组的配置则按需加载。

### loadFromFile

除了使用`App::cfg`系列方法获取配置，还可以通过默认加载器的`loadFromFile()`直接获取配置实例，
然后通过`Configuration::get`方法获取配置项的值。

> **说明**
> 1. 与自定义加载器不兼容，无法处理自定义配置格式。
> 2. 如其名直接从文件加载配置，效率极高。

## 自定义加载器

如果你不想从php文件加载配置甚至你不想从本地加载配置，你都可以自己实现配置加载器按你自己需要去加载配置，只要记得最后返回一个[Configuration](https://github.com/ninggf/wulaphp/blob/v2.0/wulaphp/conf/Configuration.php)实例就行。
下边代码示例从`ini`文件(也放在`conf`目录下)加载配置:

```php
class MyConfigurationLoader extends ConfigurationLoader {
    public function loadConfig($name = 'default') {
        $config = new Configuration($name);
        $file   = CONFIG_PATH . $name . '.ini';
        if (is_file($file)) {
            $cfg = parse_ini_file($file, true);
            if ($cfg) {
                $config->setConfigs($cfg);
            }
        }

        return $config;
    }
}
```

O了，自定义加载器完成，可以加载普通的配置了，要想加载『数据库配置』请实现`loadDatabaseConfig`方法。

### 使用自定义加载器

有了自定义加载器类就可以修改`bootstrap.php`文件中的`CONFIG_LOADER_CLASS`常量了:

```php
define('CONFIG_LOADER_CLASS', 'MyConfigurationLoader');
```

> **重点说明**: 要写全类名(包含命名空间的)。

自定义加载器完成。
