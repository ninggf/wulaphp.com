<?php

namespace hello;

use wulaphp\app\App;
use wulaphp\app\Module;

/**
 * HelloWorld
 *
 * @package hello
 */
class HelloModule extends Module {
    public function getName() {
        return 'HelloWorld';
    }

    public function getDescription() {
        return '描述';
    }

    public function getHomePageURL() {
        return '';
    }
}

App::register(new HelloModule());
// end of bootstrap.php