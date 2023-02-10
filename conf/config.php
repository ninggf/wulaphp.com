<?php
/**
 * 应用配置文件.
 */
return [
    'debug'    => env('debug', DEBUG_WARN),
    'resource' => [
        'combinate' => env('resource.combinate', 0),
        'minify'    => env('resource.minify', 0)
    ],
    'users'    => []
];