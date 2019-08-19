---
title: Httpd 配置
cate: 基础
index: 1
showToc: 0
desc: 本文目的是教会大家如何通过配置让wulaphp与Httpd一起工作。
---

本文目的是教会大家如何通过配置让`wulaphp`与`Httpd`一起工作，但不会教大家如何安装`httpd`。在开始配置之前请确保:

<p class="tip" markdown="1">安装了httpd的`rewrite`模块并已经开启！</p>

## 获取配置

打开命令行并进入应用根目录，执行以下命令:

`# php vendor/bin/wulaphp conf httpd`

你将获取到适合当前应用的基本配置,如下:

```httpd
<VirtualHost *:80>
    DocumentRoot "/your_webapp_dir/wwwroot"
    ServerName your_server_name

    <Directory "/your_webapp_dir/">
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <IfModule alias_module>
        AliasMatch "^/(modules|themes)/(.+\.(js|css|jpe?g|png|gif))$" "/your_webapp_dir/$1/$2"
    </IfModule>

    # other directives can be here
</VirtualHost>
```

## 按需要修改

将上面的配置复制到配置文件中，并根据实际情况进行修改:

1. 域名`your_server_name`改为你的域名
2. 目录（两处）`/your_webapp_dir/`改为你应用的实际目录
3. 按需要开启访问日志或错误日志
4. 其它你要修改的东东，可以百度，可以google。

### 静态资源 {#static}

上边的配置中通过下边的代码默认将`modules`和`themes`目录设为静态资源目录:

```httpd
<IfModule alias_module>
    AliasMatch "^/(modules|themes)/(.+\.(js|css|jpe?g|png|gif))$" "/your_webapp_dir/$1/$2"
</IfModule>
```

如果有需要，可以在`modules`前或`themes`后添加你的静态资源目录。

## 验证

配置好后，重启`httpd`或重新加载配置，然后访问应用首页，你将看到:

**Hello wula !!**

如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
