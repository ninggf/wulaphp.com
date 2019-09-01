---
title: Docker 配置
cate: 基础
index: 1
showToc: 0
desc: 本文目的是教会大家如何通过配置让wulaphp与Docker一起工作。
---

本文目的是教会大家如何通过配置让`wulaphp`与`Docker`一起工作，但不会教大家如何安装`Docker`。在开始配置之前请确保:

<p class="tip" markdown="1">已经安装`Docker`并启动！</p>

## 配置

wulaphp提供了`docker-compose`模板文件,如果你想使用Docker运行wulaphp,请:

1. 重命名`docker-compose.sample.yml`为`docker-compose.yml`
2. 按需修改`docker-compose.yml`和`conf/site.conf`
3. 启动docker: `$ docker-compose up -d`
4. 关闭docker: `$ docker-compose down`

**模板文件中使用的镜像如下:**

* [windywany/php:latest](https://hub.docker.com/r/windywany/php/) : 为wulaphp定制的php镜像.
* [mysql:5.7.23](https://hub.docker.com/_/mysql/)
* [nginx:latest](https://hub.docker.com/_/nginx/)
* [redis:4.0.11](https://hub.docker.com/_/redis/)

**`windywany/php`支持的环境变量说明:**

* `XDEBUG_REMOTE_HOST` 是你电脑的IP，默认`127.0.0.1`
  * `ifconfig` **类unix**系统查询
  * `ipconfig /all` **windows**系统查询
* `XDEBUG_REMOTE_PORT`你的IDE监听的端口,默认`9000`
* `XDEBUG_ENABLE` 等于1时开启`xdebug`调试,默认`0`

更多Docker使用方法请移步到[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/).

## 验证

使用`$ docker-compose up -d`命令启动相应的容器，然后访问应用首页，你将看到:

<p class="success" markdown=1>
**Hello wula !!**
</p>

如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。
