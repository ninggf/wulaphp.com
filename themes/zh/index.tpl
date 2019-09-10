{$isIndex=true}
{$pageType='index'}
{extends file='./layout.tpl'}
{block body}
    <div class="sidebar">
        <div class="sidebar-inner">
            <ul class="main-menu">
                {include './partials/menu.tpl'}
            </ul>
        </div>
    </div>
    <div id="hero">
        <div class="inner">
            <div class="left">
                <img class="hero-logo" src="{'../images/logo.png'|here}">
            </div>
            <div class="right">
                <h2 class="vue">wulaphp</h2>
                <h1><br/>
                    又一个PHP框架 </h1>
                <p>
                    <a class="button" href="{'guide/install.md'|docurl}">起步</a>
                    <a class="button" href="http://down.wulaphp.com/wulaphp-{$config.version}.zip" target="_blank">下载</a>
                    <a class="button white" href="https://github.com/ninggf/wulaphp" target="_blank">GITHUB</a>
                </p>
            </div>
        </div>
    </div>
    <div id="highlights">
        <div class="inner">
            <div class="point">
                <h2>易用</h2>
                <p>内置大量常用功能类，Rbac、Session、Cache、ORM开箱即用！</p>
            </div>

            <div class="point">
                <h2>灵活</h2>
                <p>简单小巧的内核, 强大的模块、插件扩展机制, 足以应付任何规模的应用；多种URL路由让选择更灵活。</p>
            </div>

            <div class="point">
                <h2>高效</h2>
                <p>
                    基于APC、YAC等扩展的运行时缓存让类自动加载如同飞一般；
                    优雅的数据库、Redis封装让开发更高效。 </p>
            </div>
        </div>
    </div>
    <div id="footer">
        <p>
            <a class="social-icon" href="https://github.com/ninggf/wulaphp" target="_blank">
                <svg aria-labelledby="simpleicons-github-icon" role="img" viewBox="0 0 24 24"
                     xmlns="http://www.w3.org/2000/svg"><title id="simpleicons-github-icon" lang="en">GitHub
                        icon</title>
                    <path fill="#FFFFFF"
                          d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"></path>
                </svg>

            </a>
        </p>
        <p>
            <a href="https://travis-ci.org/ninggf/wulaphp"><img
                        src="https://travis-ci.org/ninggf/wulaphp.svg?branch=v2.0" alt="Build Status"></a>
            <a href="https://packagist.org/packages/wula/wulaphp"><img
                        src="https://poser.pugx.org/wula/wulaphp/v/stable.svg" alt="Latest Stable Version"></a>
            <a href="https://packagist.org/packages/wula/wulaphp"><img
                        src="https://poser.pugx.org/wula/wulaphp/license.svg" alt="License"></a>
            <br>
            Copyright &copy; 2016-{'Y'|date} Wulaphp Dev Team </p>
    </div>
    <script type="text/javascript">
        var topScrolled = false;
        window.addEventListener('scroll', function () {
            if (window.pageYOffset > 165 && !topScrolled) {
                topScrolled = true;
                document.getElementById('mobile-bar').classList.remove('top')
            } else if (window.pageYOffset <= 165 && topScrolled) {
                topScrolled = false;
                document.getElementById('mobile-bar').classList.add('top')
            }
        })
    </script>
{/block}