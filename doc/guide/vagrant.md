---
title: Vagrant
cate: 基础
index: 1
showToc: 0
desc: 本文目的是教会大家使用wulaphp官方提供的Vagrant开发环境。
---

本文目的是教会大家使用wulaphp官方提供的Vagrant Box快速配置本地开发环境。

{$toc}

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
