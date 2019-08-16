<?php
/*
 * This file is part of wulacms.
 *
 * (c) Leo Ning <windywany@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace hello\controllers;

use wulaphp\mvc\controller\Controller;
use wulaphp\mvc\view\XmlView;

class MathController extends Controller {
    //加
    public function add($i, $j) {
        return new XmlView(['result' => $i + $j], 'math');
    }

    //减
    public function sub($i, $j) {
        return ['result' => $i - $j];
    }

    //乘
    public function mul($i, $j) {
        return view(['result' => $i * $j]);
    }
}