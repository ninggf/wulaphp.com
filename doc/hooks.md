---
title: Hooks
showToc: 0
index: hooks plugin extension handler alter
keywords: hooks plugin extension handler alter
---

wulaphp内置勾子(事件)一览表:

|勾子|类型|参数|触发时机|
|---|---|---|---|
|wula\configLoaded|H|无|配置加载完成时|
|wula\extensionLoaded|H|无|扩展加载完成时|
|wula\moduleLoaded|H|无|模块加载完成时|
|app\started|H|无|App启动完成时|
|wula\bootstrapped|H|无|框架引导完成时|
|wula\stop|H|无|App停止时|
|loader\loadClass|A|1.类文件；2.类名|自动加载类|
|router\registerDispatcher|A|Router实例|Router实例创建完成时|
|router\parse_url|A|原始url|解析URL时|
|router\beforeDispatch|H|1. Router实例;2. 解析后的url|分发URL前|
|before_output_content|A|1. 要输出的内容;2. 视图实例|视图绘制后输出内容到客户端前|
|after_content_output|H|已经输出的内容|内容发送之后|
|get_redis_cache|A|1. 缓存实例；2.配置|系统需要Redis缓存实现时|
|get_memcached_cache|A|1. 缓存实例；2. 配置|系统需要memcached缓存实例时|
|upload\getUploader|A|上传器实例|获取系统默认文件上传器时|
|upload\regUploaders|A|上传器实例数组|获取所有可用文件上传器时|
|artisan\getCommands|A|命令列表|命令行执行artisan命令时|
|init_smarty_engine|H|Smarty实例|初始化Smarty引擎时|
|init_view_smarty_engine|H|Smarty实例|初始化Smarty视图引擎时|
|init_template_smarty_engine|H|Smarty实例|初始化Smarty主题引擎时|
|smarty\getFilters|A|过滤器列表['pre'=>[],'post'=>[]]|注册Smarty过滤器|
|get_theme|A|1. 当前主题; 2. 要显示的数据|获取主题时|
|get_tpl|A|1. 当前模板; 2. 要显示的数据|获取模板时|
|tpl\regCtsDatasource|A|数据源列表(id=>实例)|初始化数据源管理器时|
|combinater\getPath|A|合并文件存储目录名|合并资源时|
|combinater\getURL|A|合并文件访问根URL|开始合并资源时|
|logger\getLogger|A|默认日志记录器|系统获取日志记录器时|
|get_session_name|A|会话名|开启会话时|
|get_media_domains|A|多媒体资源URL列表|生成图片等资源URL时|
|passport\new{$type}Passport|A|Passport实例|获取Passport实例时，$type为Passport类型|
|passport\on{$type}PassportLogout|H|Passport实例|Passport退出时|
|passport\on{$type}PassportLogin|H|Passport实例|Passport登录时|
|rbac\checker\\{$resId}|A|无|获取指定资源的额外验证器时|
|passport\restore{$type}Passport|H|Passport实例|从会话中恢复时|
|{$className}::onParseFields|A|FormTable实例|解析表单字段时|
|mvc\admin\needLogin|A|视图|需要登录时|
|mvc\admin\onDenied|A|1. 视图；2.无权限提示|用户无权限操作时|
|mvc\admin\onLocked|A|视图|用户被锁定时|

> `H`: Handler，由`fire`触发的事件不需要返回值；`A`：Alter，由`apply_filter`触发的事件，需要返回值。

有些勾子是动态生成的(勾子名中有`{$xxxx}`变量的即为动态生成)，具体使用情况请参考相应的文档。关于插件的更多信息请传送至[插件(P)](guide/plugin.md)。
