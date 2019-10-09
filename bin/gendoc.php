<?php
/*
 * This file is part of wulacms.
 *
 * (c) Leo Ning <windywany@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/**
 * 生成文档
 */
function gendoc() {
    $classes = [];
    $path    = WULA_ROOT . 'wulaphp';
    $search  = [WULA_ROOT, '.php', '/'];
    $files   = find_files($path, '/.+\.php$/', [], true);
    $clzs    = array_map(function ($v) use ($search) {
        return str_replace($search, ['', '', '\\'], $v);
    }, $files);

    foreach ($clzs as $clz) {
        _gendoc($clz, $classes);
        break;
    }
}

function _gendoc($clz, &$classes) {
    $markdown = ['---'];
    $clzs     = explode('\\', $clz);
    $cln      = array_pop($clzs);

    $classes[ $clzs[0] ][ $clzs[1] ] = $cln;

    $clzs[0] = 'api';
    $ns      = implode('/', $clzs);
    $file    = BOOKY_ROOT . str_replace(['wulaphp', '\\'], ['api', '/'], $clz) . '.md';
    $dir     = BOOKY_ROOT . $ns;

    $markdown[] = 'title: ' . $cln;
    $markdown[] = 'layout: api';
    $markdown[] = 'class: ' . $clz;
    $markdown[] = "---\n\n";

    if (!is_dir($dir) && !mkdir($dir, 0755, true)) {
        die('cannot create dir: ' . $dir);
    }

    $obj = new ReflectionClass($clz);
    echo $file, " done! \n";

    $markdown[] = '## The ' . $cln . ' Class';
    file_put_contents($file, implode("\n", $markdown));
    unset($markdown, $obj, $file, $clzs, $cln);
}

gendoc();