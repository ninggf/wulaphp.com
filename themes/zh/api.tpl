{$isIndex=false}
{$pageType='api'}
{extends file='./layout.tpl'}
{block title}
    <title>wulaphp: {$page.title|default:'api'} - 手册</title>
{/block}
{block body}
    <div id="main" class="fix-sidebar">
        <div class="sidebar" id="sidebar">
            <div class="sidebar-inner">
                <ul class="main-menu">
                    {include './partials/menu.tpl'}
                </ul>
                <div class="list">
                    <a class="become-backer" href="https://github.com/ninggf/wulaphp/stargazers" target="_blank">
                        支持一下
                    </a>
                </div>
            </div>
        </div>
        <div id="sidebar-sponsors-platinum-right"></div>
        <div class="content with-sidebar">
            <div id="ad"></div>
            {if $page.apiHome}
            {else}
                {$page.content}
            {/if}
        </div>
    </div>
    <script src="{'../js/smooth-scroll.min.js'|here}"></script>
    <script src="{'../js/highlight.pack.js'|here}"></script>
    <script type="text/javascript">
        hljs.initHighlightingOnLoad();
    </script>
{/block}