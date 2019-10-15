---
title: Nginx 配置
cate: 基础
showToc: 0
index: 1
desc: 本文目的是教会大家如何通过配置让wulaphp与Nginx一起工作
---

本文目的是教会大家如何通过配置让`wulaphp`与`Nginx`一起工作。在开始配置之前请确保:

<p class="tip" markdown="1">nginx的`rewrite`功能已经开启！</p>

## 获取配置

打开命令行并进入应用根目录，执行以下命令:

* Windows: `vendor\bin\wulaphp conf nginx localhost`
* Mac/Linux:  `vendor/bin/wulaphp conf nginx localhost`

你将获取到适合当前应用的基本配置,大致如下:

```nginx
server {
    listen       80;
    #listen       443 ssl;
    server_name  localhost;

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

        gzip on;
        gzip_min_length 1000;
        gzip_comp_level 7;
        gzip_types text/plain text/css text/javascript;
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

## 按需修改

将命令行输出的配置复制到配置文件中，并根据实际情况进行修改:

1. 按需要开启访问日志或错误日志
2. 其它你要修改的东东，可以百度，可以google。
3. **正式部署时，请将`localhost`换成你的域名哦。**

## 验证

配置好后，重启`nginx`或重新加载配置，然后访问`http://localhost`，你将看到:

<p class="success" markdown=1>
**Hello wula !!**
</p>

> 如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
