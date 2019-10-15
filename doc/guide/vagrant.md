---
title: Vagrant
cate: 基础
index: 1
desc: 本文目的是教会大家使用wulaphp官方提供的Vagrant开发环境。
---

本文目的是教会大家使用wulaphp官方提供的Vagrant Box快速配置本地开发环境。

## 概述

安装、配置PHP开发环境还是有点小复杂的(特别是windows用户)，好多扩展在windows下不能使用。
幸好有[vagrant](https://www.vagrantup.com/)，通过vagrant可以很方便地创建、管理虚拟机。

vargrant可以运行在Windows，Mac或Linux上，wulaphp的Vagrant Box: `wulaphp/homestead`包括以下软件，开箱即用:

1. CentOS 7
2. PHP 7.1.32 （可通过`yum`升级或更换到其它版本）
3. MySQL Server 5.7.27
4. nginx 1.12.2
5. Redis 3.2.12
6. Memcached 1.4.15
7. Gearmand 1.1.12

以上软件都可以通过`yum`进行升级。该Box已经安装了运行wulaphp所需的扩展(包括推荐的扩展)。

<p class="tip" markdown=1>
如果你使用的是Windows系统，你需要启用硬件虚拟技术(VT-x)支持(可以在BIOS里启用)，同时关闭Hyper-V。
</p>

## 安装 {#install}

要使用`wulaphp/homestead`，请安装[VirtualBox 6.x](https://www.virtualbox.org/wiki/Downloads)与[Vagrant](https://www.vagrantup.com/downloads.html)。

> `wulaphp/homestead`只支持`virtualbox` provider。

### 安装 vagrant plugins {#plugin}

安装好`vagrant`之后，需要安装以下插件:

1. `vagrant-vbguest`
2. `vagrant-winnfsd`

通过命令`vagrant plugin install vagrant-vbguest vagrant-winnfsd`安装。

### 安装 wulaphp/homestead box {#homestead}

一旦VirtualBox和Vagrant安装完成后，需要通过下边的命令将`wulaphp/homestead` box安装到Vagrant。该box的体积大约有1G，下载需要一点时间，请耐心等候。

`vagrant box add wulaphp/homestead`

如果上边的命令出错了，请确保你安装的Vagrant是最新版本的。

## 虚拟机管理 {#init}

打开命令行，并`cd`到你准备放置项目的目录，执行下边的命令进行初始化:

`vagrant init wulaphp/homestead`

上述命令将在当前目录创建一个配置文件`Vagrantfile`，通过可以定制虚拟机。

### 配置虚拟机 {#cfg}

打开`Vagrantfile`文件，按需要修改。可以参考下述代码与注释:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "wulaphp/homestead"
  config.winnfsd.uid = 1000
  config.winnfsd.gid = 1000
  
  # 端口转发，请根据需要修改、添加
  config.vm.network "forwarded_port", guest: 80, host: 9090
  config.vm.network "forwarded_port", guest: 3306, host: 3306

  # 为了使用nfs共享文件
  config.vm.network "private_network", type: "dhcp"

  # 此处使用nfs共享文件，切记，切记！！
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provider "virtualbox" do |vb|
      vb.gui = false # 不需要界面哦
      vb.memory = 2048 # 内存，单位MB
      vb.cpus = 2 # CPU核心数
  end
end
```

### 启动虚拟机 {#start}

配置完成后就可以使用命令`vagrant up`启动虚拟啦，每一次启动时请耐心等候。如果：

1. 有弹出窗，请无脑点**是**
2. 要求输入用户名和密码，请输入**登录系统的用户名和密码**

如果启动失败，请到vagrant官网取经求助。

### 登录虚拟机 {#ssh}

虚拟机启动成功后，执行`vagrant ssh`登录虚拟机。按vagrant的约定，此时登录用户是**vagrant**，密码是**vagrant**。

至此，你已经成功的安装并启动了虚拟机。

### 安装、更新软件 {#yum}

通过包管理软件`yum`可以安装、更新软件, 如更新php，可以通过命令`yum update php-fpm`完成。如安装git，可以通过`yum install git`命令。

如果安装composer，请参考Composer的<a href="https://getcomposer.org/download/" target="_blank">Command-line installation</a>。

## 默认用户 {#default_user}

1. 系统用户
   1. `vagrant`: vagrant
   2. `root`: vagrant
2. MySQL Server
   1. `vagrant@localhost`: 空
   2. `vagrant@%`: 空
   3. `root@localhost`: 空

## 预装软件 {#pre_installed}

### nginx

配置文件所在目录`/etc/nginx/`, 主配置文件`/etc/nginx/nginx.conf`，网站配置文件建议放在`/etc/nginx/conf.d/`目录。

### php

PHP预装的是7.1.32版本,其配置文件是`/etc/php.ini`,扫描目录`/etc/php.d/`。`php-fpm`配置文件是`/etc/php-fpm.conf`,扫描目录`/etc/php-fpm.d/`。

php-fpm监听端口:`9000`

#### xdebug

默认情况下，xdebug已经开启，可以直接使用。

### php 7.2.x {#php72}

要使用 php 7.2.x 版本需要先卸载php 7.1.x版本，请保存下边的代码到`c2php72.sh`:

```shell
#!/bin/sh

yum-config-manager --disable remi-php71
yum-config-manager --disable remi-php73
yum-config-manager --enable remi-php72
yum -y update php-fpm

rm -f /etc/php.d/scws.ini
rm -f /etc/php.ini.rpmnew
rm -f /etc/php-fpm.conf.rpmnew
rm -f /etc/php-fpm.d/www.conf.rpmnew
rm -f /etc/php.d/20-shmop.ini
rm -f /etc/php.d/20-sysvmsg.ini
rm -f /etc/php.d/20-sysvsem.ini
rm -f /etc/php.d/20-sysvshm.ini
rm -f /etc/php.d/30-wddx.ini

service php-fpm restart
```

然后执行`sudo sh c2php72.sh`，耐心等一下php的版本就会切换到php 7.2.x版本啦。升级后请重新安装`scws`扩展。

### php 7.3.x {#php73}

要使用 php 7.3.x 版本需要先卸载php 7.1.x版本，请保存下边的代码到`c2php73.sh`:

```shell
#!/bin/sh

yum-config-manager --disable remi-php71
yum-config-manager --disable remi-php72
yum-config-manager --enable remi-php73
yum -y update php-fpm

rm -f /etc/php.d/scws.ini
rm -f /etc/php.ini.rpmnew
rm -f /etc/php-fpm.conf.rpmnew
rm -f /etc/php-fpm.d/www.conf.rpmnew
rm -f /etc/php.d/20-shmop.ini
rm -f /etc/php.d/20-sysvmsg.ini
rm -f /etc/php.d/20-sysvsem.ini
rm -f /etc/php.d/20-sysvshm.ini
rm -f /etc/php.d/30-wddx.ini

service php-fpm restart
```

然后执行`sudo sh c2php73.sh`，耐心等一下php的版本就会切换到php 7.3.x版本啦。升级后请重新安装`scws`扩展。

### redis

配置文件`/etc/redis.conf`,端口`6379`。

### memcached

配置文件`/etc/sysconfig/memcached`,端口`11211`。

### gearmand

配置文件`/etc/sysconfig/gearmand`,端口`4730`

## 项目实战 {#project}

### 安装

参见[安装](install.md)。

### 配置

登录到虚拟机之后，参见[nginx配置](nginx.md)。

### 特别说明

所有php相关的命令都需要在虚拟机里执行。
