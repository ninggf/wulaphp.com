---
title: 安装
type: guide
catalog: 基础
order: 2
---

## 环境要求

- PHP >= 5.6.9
- pdo_mysql
- mysqlnd （支持UTF8MB4用）
- mbstring
- curl
- json
- gd

<p class="tip">
推荐安装`redis`,`memcached`,`posix`,`pcntl`,`sockets`,`scws`等扩展.
</p>

## 安装
<p class="tip">
特别强调下列所有安装方式都需要`Composer`,请事先准备好它。

如果你使用`Mac OS`或`类Unix`[点我可以下载最新版Composer](https://getcomposer.org/download/)。
如果你使用的`Windows`,请下载[Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe)。

如果你不了解Composer(作为一个PHPer, Composer是必须会的)，请传送到[Composer](https://getcomposer.org/)或[Google](https://www.google.com/#q=composer)或[度娘](https://www.baidu.com/s?wd=composer)学习一下.
</p>

### Composer
虽然我们知道Composer在国内可能慢得跟蜗牛一样，但是我们依然选择了它:

`$composer create-project wula/wula your_project`

等一会会儿，wulaphp就安装好啦~

<p class="tip">
如果真的慢到你无法忍受，可以通过下边的命令使用国内境象：
`composer config -g repo.packagist composer https://packagist.phpcomposer.com`
国内境象中的包版本可以会比[packagist.org](https://packagist.org/)有点延时。
</p>

### git clone

1. `$ git clone https://github.com/ninggf/wula.git your_project`
2. `$ cd your_project`
3. `$ composer install --no-dev`

等一会会儿，wulaphp就安装好啦^_^

## 配置

### 核心配置
框架核心配置全都在`bootstrap.php`文件中，请参考注释进行修改(一班的人不修改，只有二班的才需要修改)。
<p class="tip">
此文件请谨慎修改哦
</p>

### 应用配置
应用配置文件位于`conf`目录,分两类配置:
* 一般配置,以`_config.php`结尾的php文件.
    * `config.php`默认配置文件
    * `cache_config.php`缓存配置文件
    * `cluster_config.php`集群配置文件
* 数据库配置,以`_dbconfig.php`结尾的php文件.
    * `dbconfig.php`默认数据库配置文件

### 目录权限
如果你使用`Mac OS`或`类Unix`,那么框架要求**Web服务器**能读写`storage`,`storage/logs`和`storage/logs`目录:

`$ chmod 777 storage storage/tmp storage/logs`

## 服务器配置

**wulaphp**不支持以下URL，不漂亮:

* http://www.abc.com/index.php?module=A&controller=B&action=C&args=...
* http://www.abc.com/index.php/A/B/C?args=...

漂亮的URL需要服务器支持重写功能(`rewrite`)。请确保你的服务器支持重写! 

**wulaphp**可以很方便地部署在[Apache](#Apache)和[nginx](#nginx)中.

### Apache

wulaphp提供了wwwroot/.htaccess文件用来实现漂亮的URL, 只要你的Apache启用了`mod_rewrite`且像下边这样配置你的网站即可：

``` xml
<VirtualHost *:80>
    <Directory "$your_project/wwwroot/">
        Options +FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    ServerAdmin your-email-address
    DocumentRoot "$your_project/wwwroot"
    ServerName your_server_name
    # other directives can be here
</VirtualHost>
```
> 注:
>
> $your_project是你的wulaphp安装目录，你要根据实际情况进行替换(`pwd`命令可以打印当前目录).
> 
> 配置完成后重启apache生效.

如果，我说如果，上边的配置不启作用，你可以尝试像下边这样配置你的网站:

```
Options +FollowSymLinks

RewriteEngine On

RewriteCond %{REQUEST_FILENAME} !-f 
RewriteCond %{REQUEST_URI} !=/favicon.ico
RewriteRule ^(.*)$ index.php [QSA,L]
```

#### 独立主机配置
修改Apache的配置文件中的以下内容:
- 修改DocumentRoot
```
DocumentRoot "$your_project/wwwroot"
```
- 修改目录配置
```
<Directory "$your_project/wwwroot">
    Options FollowSymLinks -Indexes
    AllowOverride all
    Order allow,deny
    Allow from all
</Directory>
```

> 注:
>
> $your_project是你的wulaphp安装目录，你要根据实际情况进行替换(`pwd`命令可以打印当前目录).
> 
> 配置完成后重启apache生效.

### nginx
如果你运行的是nginx（也需要启用`rewrite`功能），请把下边的配置拿走:

```
server {
    listen       80;
    server_name  your_server_name;
    root $your_project/wwwroot/;
    location / {
        index index.php index.html index.htm;
        if (!-e $request_filename){
            rewrite ^(.*)$ index.php last;
        }
    }
    location ~ /(assets|uploads|files)/.+\.(php[s345]?|tpl|inc)$ {
        return 404;
    }        
    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000; #unix:/tmp/php-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root/$fastcgi_script_name;
        include        fastcgi_params;
        #fastcgi_param  APPMODE pro;
    }
    location ~ /\.ht {
        deny  all;
    }
}
```
其它的配置，请自行根据项目需要修改。

> 注:
>
> 再次强调！$your_project是你的wulaphp安装目录，你要根据实际情况进行替换(`pwd`命令可以打印当前目录).
> 
> 可以通过`fastcgi_param  APPMODE` 来定义wulaphp的运行模式:
>   * pro 为线上生产环境
>   * dev 为开发环境（默认）
>   * test 为测试环境
> 
> 配置完成后重新加载nginx的配置生效.

## Docker

wulaphp提供了`docker-compose`模板文件,如果你想使用Docker运行wulaphp,请:
1. 重命名`docker-compose.sample.yml`为`docker-compose.yml`
2. 按需要修改`docker-compose.yml`和`conf/site.conf`
3. 启动docker: `$ docker-compose up -d`
4. 关闭docker: `$ docker-compose down`

模板文件中使用的镜像如下:
* [windywany/php:latest](https://hub.docker.com/r/windywany/php/)为wulaphp定制的php镜像.
* [mysql:5.7.23](https://hub.docker.com/_/mysql/)
* [nginx:latest](https://hub.docker.com/_/nginx/)
* [redis:4.0.11](https://hub.docker.com/_/redis/)

更多Docker使用方法请移步到[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/).

## Hello wula

完成以上步骤，通过浏览器访问你的网站(网址你知道的哦)，看到以下输出说明安装成功：**Hello wula !!**

如果没看到-_-, 请移步[常见问题](../faq.html).