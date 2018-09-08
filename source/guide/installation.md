---
title: 安装
type: guide
catalog: 基础
order: 2
---

## 环境准备

wula.php需要PHP的5.6.+并且安装了以下扩展： 
- mbstring
- pdo_mysql

## 安装

虽然我们知道composer在国内可能慢得地蜗牛一样，但是我们依然选择了她:

`composer create-project wula/wula blog`

### 加速composer

如果真的慢到你无法忍受，要以通过下边的命令尝试使用国内境象：

`composer config -g repo.packagist composer https://packagist.phpcomposer.com`

国内境象中的包版本可以会比[packagist.org](https://packagist.org/)有点延时。

<p class="tip">
如果你不了解composer(作为一个PHPer, Composer是必须会的), 请传送到[Composer](https://getcomposer.org/)或[Google](https://www.google.com/#q=composer)或[度娘](https://www.baidu.com/s?wd=composer),[点我可以下载最新版Composer](https://getcomposer.org/download/)。
</p>

### 本地开发服务器
如果你在本地安装了PHP，那么可以使用PHP提供的内建开发服务器来运行应用，只需要简单的调用artisan的`serve`命令。`serve`命令在8080端口上打开内建服务器，通过浏览器访问`http://127.0.0.1:8080`:

`php artisan serve`

如果改变监听端口和地址请使用以下参数调用`serve`命令：
- l 指定监听地址
- p 指定监听端口

> 如: `php artisan serve -p 8000` 将在8000端口监听。

### 配置
#### 框架核心配置
框架核心配置全都在`bootstrap.php`文件中，请参考注释进行修改(一班的人不修改，只有二班的才需要修改)。

#### 应用配置文件
应用配置文件位于`conf`目录，框架的[数据库配置](config.html#数据库配置)，[缓存配置](config.html#缓存配置)，[应用配置](#应用配置)都存放于此。

#### 目录权限
框架要求**Web Server**能读写`logs`和`tmp`两个目录（通过`composer create-project`安装的已经设置好了），可以通过`php artisan init`来设置他们俩的权限。

## Web Server 配置
漂亮的URL需要**Web Server**支持重写功能(`rewrite`).
<p class="tip">
wula.php不支持以下URL，不漂亮.
http://www.abc.com/index.php?module=A&controller=B&action=C&args=...
http://www.abc.com/index.php/A/B/C?args=...
</p>

### Apache (httpd)

wula.php提供了wwwroot/.htaccess文件用来实现漂亮的URL, 只要你的Apache启用了`mod_rewrite`且像下边这样配置你的网站即可：

```xml
<VirtualHost *:80>
    <Directory "$wula_root/wwwroot/">
        Options +FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    ServerAdmin your-email-address
    DocumentRoot "your_project_public_dir"
    ServerName your_server_name
    # other directives can be here
</VirtualHost>
```
> $wula_root是你的wula.php安装目录哈，你要根据实际情况进行替换的哦(`pwd`命令可以打印当前目录).

如果，我说如果，上边的配置不启作用，你可以尝试像下边这样配置你的网站:

```
Options +FollowSymLinks

RewriteEngine On

RewriteCond %{REQUEST_FILENAME} !-f 
RewriteCond %{REQUEST_URI} !=/favicon.ico
RewriteRule ^(.*)$ index.php [QSA,L]

```

### nginx
如果你运行的是nginx（也需要启用`rewrite`功能的哦），请把下边的配置拿走:

```
server {
    listen       80;
    server_name  your_server_name;
    root $wula_root/wwwroot/;
    location / {
        index index.php index.html index.htm;
        if (!-e $request_filename){
            rewrite ^(.*)$ index.php last;
        }
    }
    location ~ /(modules|assets|themes)/.+\.(php[s345]?|tpl|inc)$ {
        return 404;
    }        
    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root/$fastcgi_script_name;
        include        fastcgi_params;
    }
    location ~ /\.ht {
        deny  all;
    }
}
```
其它的配置，请自行根据项目需要修改。

> 再次强调！$wula_root是你的wula.php安装目录哈，你要根据实际情况进行替换的哦(`pwd`命令可以打印当前目录).


## 邂逅wula.php

完成以上步骤，通过浏览器访问你的网站，看到以下输出说明安装成功：**Hello wula !!**

<p class="tip">`php artisan serve`启用内建开发服务器的可以直接访问[http://127.0.0.1:8080](http://127.0.0.1:8080)</p>