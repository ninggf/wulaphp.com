(function () {
    initMobileMenu();
    if (PAGE_TYPE == 'guide') {
        initToc();
    }
    initSearch();

    /**
     * Mobile burger menu button and gesture for toggling sidebar
     */
    function initMobileMenu() {
        var mobileBar  = document.getElementById('mobile-bar')
        var sidebar    = document.querySelector('.sidebar')
        var menuButton = mobileBar.querySelector('.menu-button')

        menuButton.addEventListener('click', function () {
            sidebar.classList.toggle('open')
        })

        document.body.addEventListener('click', function (e) {
            if (e.target !== menuButton && !sidebar.contains(e.target)) {
                sidebar.classList.remove('open')
            }
        })

        // Toggle sidebar on swipe
        var start = {},
            end   = {}

        document.body.addEventListener('touchstart', function (e) {
            start.x = e.changedTouches[0].clientX
            start.y = e.changedTouches[0].clientY
        })

        document.body.addEventListener('touchend', function (e) {
            end.y = e.changedTouches[0].clientY
            end.x = e.changedTouches[0].clientX

            var xDiff = end.x - start.x
            var yDiff = end.y - start.y

            if (Math.abs(xDiff) > Math.abs(yDiff)) {
                if (xDiff > 0) sidebar.classList.add('open')
                else sidebar.classList.remove('open')
            }
        })
    }

    function initToc() {
        var toc     = document.querySelector('ul.toc'),
            main    = document.querySelector('div.content'),
            showToc = function () {
                var w = window.innerWidth;
                if (w >= 1300) {
                    toc.style.left    = main.offsetLeft + main.offsetWidth + 15 + 'px';
                    toc.style.display = 'block'
                } else {
                    toc.style.left = 'unset'
                }
            };
        if (toc) {
            window.addEventListener('resize', showToc);
            showToc();
        }
    }

    function initSearch() {
        var query   = $('input.search-query'),
            nav     = document.getElementById('nav'),
            wrapper = document.getElementById('search-wrapper'),
            timer   = 0,
            qkey    = '',
            url     = '//' + location.host + '/search-doc.do',
            search  = function () {
                $.get(url, {
                    q: qkey
                }, function (data) {
                    if (data && data.hits) {
                        wrapper.innerHTML = '';
                        var list          = $('<ul class="search-rst"></ul>');
                        $(data.pages).each(function (i, p) {
                            $('<li><a href="' + p.url + '">' + (p.cate ? '[' + p.cate + '] ' : '') + p.title + '</a></li>').appendTo(list)
                        });
                        list.appendTo($('#search-wrapper'))
                    } else {
                        wrapper.innerHTML = '<small>未找到与"' + qkey + '"相关的内容</small>';
                    }
                }, 'json');
            };
        if (query.length > 0) {
            query.on('focus', function (e) {
                if (window.innerWidth > 899) {
                    var left           = nav.offsetLeft;
                    wrapper.style.left = left + 'px';
                    wrapper.style.top  = '50px'
                } else {
                    wrapper.style.left = '20px';
                    wrapper.style.top  = '90px'
                }
            });
            query.on('click', function (e) {
                var val = $(this).val().trim();
                if (val) {
                    e.stopImmediatePropagation()
                    wrapper.style.display = 'block'
                }
            });
            query.on('keyup', function () {
                qkey = $(this).val().trim()
                if (timer) {
                    clearTimeout(timer);
                    timer = 0;
                }
                if (qkey) {
                    wrapper.style.display = 'block'
                    timer                 = setTimeout(search, 500);
                } else {
                    wrapper.style.display = 'none'
                    wrapper.innerHTML     = '';
                }
            });
            document.addEventListener('click', function () {
                wrapper.style.display = 'none'
            });
            wrapper.addEventListener('click', function (e) {
                e.stopImmediatePropagation();
            })
        }
    }
})();