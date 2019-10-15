---
title: Httpd 配置
cate: 基础
index: 1
showToc: 0
desc: 本文目的是教会大家如何通过配置让wulaphp与Httpd一起工作。
---

本文目的是教会大家如何通过配置让`wulaphp`与`httpd`一起工作。在开始配置之前请确保:

<p class="tip" markdown="1">启用了httpd的`rewrite`和`alias`模块，httpd 最低版本要求为`2.4`。</p>

## 获取配置

打开命令行并进入应用根目录，执行以下命令:

* Windows: `vendor\bin\wulaphp conf httpd localhost`
* Mac/Linux:  `vendor/bin/wulaphp conf httpd localhost`

你将获取到适合当前应用的基本配置,如下:

```httpd
<VirtualHost *:80>
    DocumentRoot "/your_webapp_dir/wwwroot"
    ServerName localhost

    <Directory "/your_webapp_dir/">
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <LocationMatch "^/(?<DIR>modules|themes)/(?<FILE>.+\.(js|css|jpe?g|png|gif))$">
        <IfModule alias_module>
            Alias "/your_webapp_dir/%{env:MATCH_DIR}/%{env:MATCH_FILE}"
        </IfModule>
        <IfModule deflate_module>
            AddOutputFilterByType DEFLATE text/css text/javascript application/javascript
        </IfModule>
        <IfModule expires_module>
            ExpiresActive Off
            ExpiresDefault "access plus 30 days"
        </IfModule>
    </LocationMatch>

    # other directives can be here
</VirtualHost>
```

## 按需修改

将命令行输出的配置复制到配置文件中，并根据实际情况进行修改:

1. 按需要开启访问日志或错误日志
2. 其它你要修改的东东，可以百度，可以google。
3. **正式部署时，请将`localhost`换成你的域名哦。**

## 验证

配置好后，重启`httpd`或重新加载配置，然后访问`http://localhost`，你将看到:

<p class="success" markdown=1>
**Hello wula !!**
</p>

> 如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
