---
title: FQA
index: 1
desc: 常见问题来这里找答案
---

## 安装问题 {#install}

1. Q：为什么`composer require wula/wulaphp`那么慢，有时还会出错?
   * A: composer 服务器在国外访问速度较慢，如果下载超时就会报错，可以多尝试几次。
     也可以配置composer使用国内源进行加速，但是国内源版本更新速度可能不及时。
2. Q：为什么提示找不到`composer`命令?
   * A：请将`composer`所在目录加入环境变量`PATH`中即可。
3. Q：为什么`php vendor/bin/wulaphp init`运行失败?
   1. A：请将`php`所在目录加入环境变量`PATH`中即可。
   2. A：要初始化的目录不为空。
4. Q：为什么`php -S 127.0.0.1:8090 -t wwwroot/ wwwroot/index.php`运行失败?
   1. A：请将`php`所在目录加入环境变量`PATH`中即可。
   2. A：`8090`端口被占用，换一个端口。
5. Q：为什么访问`http://127.0.01:8090`时看不到**Hello wula !!**，而是报错或出现空白页?
   1. A：请确保环境符合最小要求，详见[环境要求](guide/install.md#requirements)。
   2. A：查看php的错误日志，以精确定位问题。
