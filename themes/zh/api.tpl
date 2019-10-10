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
                    <ul class="menu-root" id="apiList">
                        {foreach $apiData as $apiD => $mOne}
                            <li {if in_array($mOne.url,$actives)}class="active"{/if}><a href="{$mOne.url}"
                                                                                        class="sidebar-link {if $pageUrl==$mOne.url}current{/if}">{$mOne.title}</a>
                                <ul class="menu-sub">
                                    {foreach $mOne.children as $apiD=>$mTwo}
                                        <li {if in_array($mTwo.url,$actives)}class="active"{/if}>
                                            <a href="{$mTwo.url}"
                                               class="sidebar-link {if $pageUrl==$mTwo.url}current{/if}">{$mTwo.title}</a>
                                            {if $mTwo.children}
                                                <ul>
                                                    {foreach $mTwo.children as $mThree}
                                                        <li {if in_array($mThree.url,$actives)}class="active"{/if}>
                                                            <a href="{$mThree.url}"
                                                               class="sidebar-link {if $pageUrl==$mThree.url}current{/if}">{$mThree.title}</a>
                                                        </li>
                                                    {/foreach}
                                                </ul>
                                            {/if}
                                        </li>
                                    {/foreach}
                                </ul>
                            </li>
                        {/foreach}
                    </ul>
                </div>
            </div>
        </div>
        <div id="sidebar-sponsors-platinum-right"></div>
        <div class="content with-sidebar">
            <div id="ad"></div>
            {if $page.apiHome}
                {if $apiIndexes.pkgs}
                    <h2>包</h2>
                    <ul>
                        {foreach $apiIndexes.pkgs as $pkg}
                            <li><a href="{$pkg.url}">{$pkg.title}</a></li>
                        {/foreach}
                    </ul>
                {/if}
                {if $apiIndexes.clzs}
                    <h2>类</h2>
                    <ul>
                        {foreach $apiIndexes.clzs as $pkg}
                            <li><a href="{$pkg.url}">{$pkg.title}</a></li>
                        {/foreach}
                    </ul>
                {/if}
            {else}
                <div id="toc">{$page.tocStr}</div>
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