---
title: FQA
index: 1
desc: 常见问题来这里找答案
---

## 安装问题 {#install}

1. Q：为什么`composer require wula/wulaphp`那么慢，有时还会出错?
   * A: **composer**服务器在国外访问速度较慢，如果下载超时就会报错，可以多尝试几次。
     也可以配置**composer**使用国内源进行加速，但是国内源版本更新速度可能不及时。
2. Q：为什么提示找不到`composer`命令?
   * A：请将`composer`所在目录加入环境变量`PATH`中即可。
3. Q：为什么`php vendor/bin/wulaphp init`运行失败?
   1. A：请将`php`所在目录加入环境变量`PATH`中即可。
   2. A：要初始化的目录不为空。
4. Q：为什么`php artisan serve`运行失败?
   1. A：`8080`端口被占用，换一个端口。
5. Q：为什么验证时看不到**Hello wula !!**，而是报错或出现空白页?
   1. A：请确保环境符合最小要求，详见[环境要求](guide/install.md#requirements)。
   2. A：查看php的错误日志，以精确定位问题。
   3. A：请确保配置文件中的`/your_webapp_dir/`已经正确替换成真实的路径。
   4. A：（nginx）请确保安装并启用了**nginx**的`rewrite`模块。
        * `nginx -V 2>&1 | tr -- - '\n' | grep module`查看nginx配置选项。
   5. A：（httpd）请确保安装并启用了**httpd**的`rewrite`和`alias`模块。
        * `httpd -M` 查看httpd的模块信息
   6. A：配置修改之后请重启**nginx**或**httpd**。
   7. A：如果是**Linux**，请检查Selinx是否开启，如果开启了，请关闭或为项目配置相应的权限。
   8. A：以docker方式运行时，请确保文件共享配置正确。
   9. A：以docker方式运行时，请以管理员方式运行docker相关命令。
