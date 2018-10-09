---
title: 扩展点
---

wulaphp内置勾子(扩展点)一览表:

|勾子|类型|参数|触发时机|
|---|---|---|---|
|wula\configLoaded|事件|无|配置加载完成时|
|wula\extensionLoaded|事件|无|扩展加载完成时|
|wula\moduleLoaded|事件|无|模块加载完成时|
|app\started|事件|无|App启动完成时|
|wula\bootstrapped|事件|无|框架引导完成时|
|wula\stop|事件|无|App停止时|
|loader\loadClass|修改|1.类文件 2.类名|自动加载类|
|router\registerDispatcher|修改|Router实例|Router实例创建完成时|
|router\parse_url|修改|原始url|解析URL时|
|router\beforeDispatch|事件|1. Router实例;2. 解析后的url|分发URL前|
|before_output_content|修改|1. 要输出的内容;2. 视图实例|视图绘制后输出内容到客户端前|
|after_content_output|事件|已经输出的内容|内容发送之后|
|get_redis_cache|修改|1. 缓存实例；2.配置|系统需要Redis缓存实现时|
|get_memcached_cache|修改|1. 缓存实例；2. 配置|系统需要memcached缓存实例时|
|artisan\getCommands|修改|命令列表|命令行执行artisan命令时|
|init_smarty_engine|事件|Smarty实例|初始化Smarty引擎时|
|init_view_smarty_engine|事件|Smarty实例|初始化Smarty视图引擎时|
|init_template_smarty_engine|事件|Smarty实例|初始化Smarty主题引擎时|
|smarty\getFilters|修改|过滤器列表['pre'=>[],'post'=>[]]|注册Smarty过滤器|
|get_theme|修改|1. 当前主题; 2. 要显示的数据|获取主题时|
|get_tpl|修改|1. 当前模板; 2. 要显示的数据|获取模板时|
|tpl\regCtsDatasource|修改|1. 数据源列表(id=>实例)|初始化数据源管理器时|
|combinater\getPath|修改|1. 合并文件存储目录名|合并资源时|
|combinater\getURL|修改|1. 合并文件访问根URL|开始合并资源时|
|logger\getLogger|修改|默认日志记录器|系统获取日志记录器时|
|get_session_name|修改|会话名|开启会话时|
|get_media_domains|修改|多媒体资源URL列表|生成图片等资源URL时|
|passport\new{$type}Passport|修改|Passport实例|获取Passport实例时，$type为Passport类型|
|passport\on{$type}PassportLogout|事件|Passport实例|Passport退出时|
|passport\on{$type}PassportLogin|事件|Passport实例|Passport登录时|
|rbac\getExtraChecker\\{$resId}|修改|无|获取指定资源的额外验证器时|
|passport\restore{$type}Passport|事件|Passport事件|从会话中恢复时|
|{$className}::onParseFields|修改|FormTable实例|解析表单字段时|
|mvc\admin\needLogin|修改|视图|需要登录时|
|mvc\admin\onDenied|修改|1. 视图；2.无权限提示|用户无权限操作时|
|router:{$url}|修改|1.视图，2.action，3.参数|子模块路由失败时|

有些勾子是动态生成的(勾子名中有`{$xxxx}`变量的即为动态生成)，具体使用情况请参考相应的文档。关于插件的更多信息请传送至[插件(P)](guide/mvc/plugin.html).
