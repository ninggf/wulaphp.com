<!DOCTYPE html>
<html lang="zh" data-rel="{$url}">
<head>
    {block title}
    <title>{$page.pageTitle|default:$page.title|default:'文档'} - wulaphp 中文文档</title>
    {/block}
    <meta charset="utf-8">
    <meta name="description" content="{$page.desc|default:$config.siteDesc|escape}">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta property="og:type" content="article">
    <meta property="og:title" content="{$page.title}">
    <meta property="og:description" content="{$page.desc|default:$config.siteDesc|escape}">
    <link rel="icon" href="{'../images/logo.png'|here}" type="image/x-icon">
    <link rel="stylesheet" href="{'../css/search.css'|here}">
    {if $isIndex}
        <link rel="stylesheet" href="{'../css/index.css'|here}">
    {else}
        <link rel="stylesheet" href="{'../css/page.css'|here}">
    {/if}
    <script>window.PAGE_TYPE = "{$pageType}"</script>
</head>
<body {if !$isIndex}class="docs"{/if}>
<div id="mobile-bar"{if $isIndex} class="top"{/if}>
    <a class="menu-button"></a>
    <a class="logo" href="/"></a>
</div>
{include './partials/header.tpl'}
{block body}{/block}
<div id="search-wrapper"></div>
<script src="{'../js/zepto.min.js'|here}"></script>
<script src="{'../js/common.js'|here}"></script>
<script src="{'../js/fastclick.min.js'|here}"></script>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        FastClick.attach(document.body)
    }, false);

    var _hmt = _hmt || [];
    (function() {
        var hm = document.createElement("script");
        hm.src = "https://hm.baidu.com/hm.js?ea24c4545037c6e09b9dcf6a11f74207";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();

    (function(){
        var bp = document.createElement('script');
        var curProtocol = window.location.protocol.split(':')[0];
        if (curProtocol === 'https') {
            bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
        }
        else {
            bp.src = 'http://push.zhanzhang.baidu.com/push.js';
        }
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(bp, s);
    })();
</script>
</body>
</html>
