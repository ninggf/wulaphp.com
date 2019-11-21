---
title: Docker 配置
cate: 基础
index: docker
keywords: docker wulaphp docker配置 环境变量 容器
showToc: 0
desc: 本文目的是教会大家如何通过配置让wulaphp与Docker一起工作。
---

本文目的是教会大家如何通过配置让`wulaphp`与`Docker`一起工作。

{$toc}

## 配置 {#cfg}

通过`wulaphp`提供的`docker-compose`模板文件可以很方便的使用`docker`进行开发。按如下步骤进行配置:

1. 重命名`docker-compose.sample.yml`为`docker-compose.yml`。
2. 按需修改`docker-compose.yml`。
   * 可以修改web端口与mysql端口、MySQL默认root密码等。
   * 默认`mysql`用户`root`的密码为空。
3. `conf/site.conf`为nginx配置文件，请按需修改。

**使用的镜像如下:**

* [wulaphp/php:latest](https://hub.docker.com/r/wulaphp/php/) : 为wulaphp定制的php镜像.
  * latest对应的是7.3.x版本的PHP。
* [mysql:5.7.24](https://hub.docker.com/_/mysql/) : mysql 数据库服务器。
* [nginx:latest](https://hub.docker.com/_/nginx/) : nginx WEB服务器。
* [redis:4.0.11](https://hub.docker.com/_/redis/) : redis NoSQL服务器。
* [memcached:1.5.10](https://hub.docker.com/_/memcached/) : memcached 缓存服务器。
* [gearmand:latest](https://hub.docker.com/r/artefactual/gearmand/) : gearmand 服务器。

> 可根据需要选择合适的镜像版本。

### 环境变量 {#env}

可以通过环境变量来控制`xdebug`与`apcu`扩展：

* `XDEBUG_REMOTE_HOST` 是你电脑的IP，默认`host.docker.internal`
* `XDEBUG_REMOTE_PORT`你的IDE监听的端口,默认`9000`
* `XDEBUG_ENABLE` 等于1时开启`xdebug`调试,默认`0`，需要调试时设为`1`。
* `APCU_ENABLE`: 等于1时启用apcu运行时缓存,默认0。

### 外部连接 {#ext}

因为`mysql`，`redis`，`memcached`，`gearmand`，`php`运行在各自的docker容器内，需要将其端口映射到主机上才能从外部正常访问它们。
默认映射了以下端口:

* `web`:`8090`
* `mysql`: `3306`

<p class="tip" markdown=1>以上端口在`docker-compose.yml`文件中修改。</p>

### 内部连接 {#inter}

因为`mysql`，`redis`，`memcached`，`gearmand`，`php`运行在各自的docker容器内，当我们的程序需要连接他们时(我们写的程序运行在`php`与`web`容器内)，在配置上会稍有不同。
主要体现在`host`部分，下边列出连接每个服务器所需要的`host`与`port`：

* `mysql`:
  * host: mysql
  * port: 3306
* `redis`:
  * host: redis
  * port: 6379
* `memcached`:
  * host: memcached
  * port: 11211
* `gearmand`:
  * host: gearmand
  * port: 4730
* `php`:
  * host: php
  * port: 9000

## 启动容器 {#start}

配置完成后，运行以下命令启动容器(windows用户需要以管理员身份运行):

`docker-compose up -d`

## 验证 {#hello}

使用`docker-compose up -d`命令启动相应的容器后，访问`http://127.0.0.1:8090`，你将看到:

<p class="success" markdown=1>
**Hello wula !!**
</p>

如果未能看到上边的输出，请移步[FQA](../fqa.md#install)。

## 关闭容器 {#shutdown}

运行以下命令关闭容器:

`docker-compose down`

## 特别说明 {#note}

使用`docker`时，需要进入`wula_php`容器内才能执行`php`相关的命令。可以使用下边的命令进入`wula_php`容器:

`docker exec -ti wula_php bash`
