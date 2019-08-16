<?php

namespace hello\controllers;

use wulaphp\mvc\controller\Controller;

/**
 * 默认控制器.
 */
class IndexController extends Controller {
    /**
     * 默认控制方法.
     *
     * @param string $name
     *
     * @return \wulaphp\mvc\view\View
     */
    public function index($name = 'World') {
        $data = ['name' => $name];

        return view($data);
    }

    public function add($i, $j) {
        return 'the result is: ' . ($i + $j);
    }
}