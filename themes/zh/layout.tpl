<!DOCTYPE html>
<html lang="zh" data-rel="{$url}">
<head>
    <title>{$page.title|default:'文档'} - wulaphp</title>
    <meta charset="utf-8">
    <meta name="description" content="{$page.desc|default:$config.siteDesc|escape}">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta property="og:type" content="article">
    <meta property="og:title" content="{$page.title}">
    <meta property="og:description" content="{$page.desc|default:$config.siteDesc|escape}">
    <link rel="icon" href="{'../images/logo.png'|here}" type="image/x-icon">
    <link href='//fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600|Roboto Mono' rel='stylesheet'
          type='text/css'>
    <link href='//fonts.googleapis.com/css?family=Dosis:500&text=wula.php' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="{'../css/search.css'|here}">
    {if $isIndex}
        <link rel="stylesheet" href="{'../css/index.css'|here}">
    {else}
        <link rel="stylesheet" href="{'../css/simplebar.css'|here}">
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
<script src="{'../js/simplebar.min.js'|here}"></script>
<script src="{'../js/common.js'|here}"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.6/fastclick.min.js"></script>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        FastClick.attach(document.body)
    }, false)
</script>
</body>
</html>