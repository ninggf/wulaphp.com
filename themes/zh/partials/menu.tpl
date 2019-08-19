<li>
    <form id="search-form">
        <input type="text" id="search-query-nav" class="search-query st-default-search-input" autocomplete="off"/>
    </form>
</li>
<li><a href="{'guide/index.md'|docurl}" class="nav-link{if preg_match('#^guide/?.*#',$url)} current{/if}">文档</a></li>
<li><a href="/wulaphp-{$config.version}.zip">下载</a></li>
<li><a href="{'hooks.md'|docurl}" class="nav-link{if $url =='hooks.html'} current{/if}">扩展点</a></li>
<li class="nav-dropdown-container ecosystem">
    <a class="nav-link">其它</a><span class="arrow"></span>
    <ul class="nav-dropdown">
        <li><h4>资源列表</h4></li>
        <li>
            <ul>
                <li><a href="https://github.com/ninggf/wulaphp" class="nav-link" target="_blank">Github</a></li>
            </ul>
        </li>
        <li><h4>信息</h4></li>
        <li>
            <ul>
                <li><a href="#" class="nav-link">QQ群:371487281</a></li>
            </ul>
        </li>
    </ul>
</li>