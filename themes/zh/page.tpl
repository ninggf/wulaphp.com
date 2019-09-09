{$isIndex=false}
{$pageType='guide'}
{extends file='./layout.tpl'}
{block body}
    <div id="main" class="fix-sidebar">
        <div class="sidebar" data-simplebar style="width: 280px">
            <div class="sidebar-inner">
                <ul class="main-menu">
                    {include './partials/menu.tpl'}
                </ul>
                <div class="list">
                    <a class="become-backer" href="#">
                        支持一下
                    </a>
                    {$summary}
                </div>
            </div>
        </div>
        <div id="sidebar-sponsors-platinum-right"></div>
        <div class="content with-sidebar">
            <div id="ad"></div>
            {if trim($page.title)}
                <h1>{$page.title}</h1>
            {/if}

            {if $page.showToc !== 0}
                <div id="toc">{$page.tocStr}</div>
            {/if}

            {$page.content}
            {if $prevPage || $nextPage}
                <div class="guide-links">
                    {if $prevPage}
                        <span>← <a href="{$prevPage.url}">{$prevPage.name}</a></span>
                    {/if}
                    {if $nextPage}
                        <span style="float:right"><a href="{$nextPage.url}">{$nextPage.name}</a> →</span>
                    {/if}
                </div>
            {/if}
            <div class="footer">
                发现错误？想参与编辑？
                <a href="https://github.com/ninggf/wulaphp.com/edit/v2/{$sourceFile}" target="_blank">
                    在 Github 上编辑此页！
                </a>
            </div>
        </div>
    </div>
    <script src="{'../js/smooth-scroll.min.js'|here}"></script>
    <script src="{'../js/highlight.pack.js'|here}"></script>
    <script type="text/javascript">
        hljs.initHighlightingOnLoad();
    </script>
{/block}