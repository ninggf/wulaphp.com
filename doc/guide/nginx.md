---
title: Nginx 配置
cate: 基础
showToc: 0
index: 1
desc: 本文目的是教会大家如何通过配置让wulaphp与Nginx一起工作
---

本文目的是教会大家如何通过配置让`wulaphp`与`Nginx`一起工作，但不会教大家如何安装`nginx`。在开始配置之前请确保:

<p class="tip" markdown="1">nginx的`rewrite`功能已经开启！</p>

## 获取配置

打开命令行并进入应用根目录，执行以下命令:

`# php vendor/bin/wulaphp conf nginx`

你将获取到适合当前应用的基本配置,如下:

```nginx
server {
    listen       80;
    #listen       443 ssl;
    server_name  your_server_name;

    #access_log  off;
    #error_log  off;

    root /your_webapp_dir/wwwroot;

    location / {
        index index.php index.html index.htm;
        if (!-e $request_filename){
            rewrite ^(.*)$ index.php last;
        }
    }
    location ~ ^/(assets|files)/.+\.(php[s345]?|tpl|inc)$ {
        return 404;
    }

    location ~ ^/(modules|themes)/.+\.(js|css|png|gif|jpe?g)$ {
        root /your_webapp_dir/;

        #gzip on;
        #gzip_min_length 1000;
        #gzip_comp_level 7;
        #gzip_types text/plain text/css application/x-javascript application/javascript text/javascript;
        #expires 30d;
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

## 按需要修改

将上面的配置复制到配置文件中，并根据实际情况进行修改:

1. 域名`your_server_name`改为你的域名
2. 目录（两处）`/your_webapp_dir/`改为你应用的实际目录
3. 按需要开启访问日志或错误日志
4. 其它你要修改的东东，可以百度，可以google。

### 静态资源 {#static}

上边的配置中通过下边的代码默认将`modules`和`themes`目录设为静态资源目录:

```nginx
location ~ ^/(modules|themes)/.+\.(js|css|png|gif|jpe?g)$ {
    ...
}
```

如果有需要，可以在`modules`前或`themes`后添加你的静态资源目录。

<p class="tip" markdown=1> 如果需要启用静态资源压缩，请将`gzip*`和`expire`指令前的`#`删除。 </p>

## 验证

配置好后，重启`nginx`或重新加载配置，然后访问应用首页，你将看到:

**Hello wula !!**

如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
