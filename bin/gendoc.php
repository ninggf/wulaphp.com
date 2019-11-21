<?php
/*
 * This file is part of wulacms.
 *
 * (c) Leo Ning <windywany@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace {
    if (!function_exists('pcntl_async_signals')) {
        function pcntl_async_signals($t) {
        }
    }
}

namespace gendoc {

    use wulaphp\util\Annotation;

    /**
     * 生成文档
     */
    function gendoc() {
        $classes = ['api' => ['title' => 'api', 'url' => '/api', 'children' => []]];
        $path    = WULA_ROOT . 'wulaphp';
        $search  = [WULA_ROOT, '.php', '/'];
        $files   = find_files($path, '/.+\.php$/', [], true);
        $clzs    = array_map(function ($v) use ($search) {
            return str_replace($search, ['', '', '\\'], $v);
        }, $files);
        $apis    = &$classes['api']['children'];
        foreach ($clzs as $clz) {
            _gendoc($clz, $apis);
        }
        ksort($apis);
        $data = json_encode($apis, JSON_UNESCAPED_SLASHES);
        file_put_contents(BOOKY_ROOT . 'api.json', $data);
        createIdx($classes);
    }

    function _gendoc($clz, &$classes) {
        $obj    = new \ReflectionClass($clz);
        $docStr = $obj->getDocComment();
        if (strpos($docStr, '@internal') || strpos($docStr, '@deprecated')) {
            unset($obj, $docStr);

            return;
        }
        $ann      = new Annotation($obj);
        $markdown = ['---'];
        $clzs     = explode('\\', $clz);
        $cln      = array_pop($clzs);

        if (!isset($classes[ $clzs[1] ])) {
            $classes[ $clzs[1] ]['title']    = $clzs[1];
            $classes[ $clzs[1] ]['url']      = '/api/' . $clzs[1];
            $classes[ $clzs[1] ]['children'] = [];
            $node                            = &$classes[ $clzs[1] ]['children'];
        } else {
            $node = &$classes[ $clzs[1] ]['children'];
        }
        if (isset($clzs[2])) {
            if (!isset($node[ $clzs[2] ])) {
                $node[ $clzs[2] ]['title']    = $clzs[2];
                $node[ $clzs[2] ]['url']      = '/api/' . $clzs[1] . '/' . $clzs[2];
                $node[ $clzs[2] ]['children'] = [];
                $node                         = &$node[ $clzs[2] ]['children'];
            } else {
                $node = &$node[ $clzs[2] ]['children'];
            }
        }
        $clzs[0]    = '/api';
        $ns         = implode('/', $clzs);
        $node[]     = ['title' => $cln, 'url' => $ns . '/' . $cln . '.html'];
        $file       = BOOKY_ROOT . str_replace(['wulaphp', '\\'], ['api', '/'], $clz) . '.md';
        $dir        = BOOKY_ROOT . $ns;
        $doc        = $ann->getDoc();
        $markdown[] = 'title: ' . $cln;
        $markdown[] = 'layout: api';
        $markdown[] = 'index: '.$cln;
        $markdown[] = 'keywords: '.$cln;
        $markdown[] = 'class: ' . $clz;
        $markdown[] = 'desc: ' . str_replace("\n",'',$doc);
        $markdown[] = "---\n\n";

        if (!is_dir($dir) && !mkdir($dir, 0755, true)) {
            die('cannot create dir: ' . $dir);
        }

        $t   = $obj->isInterface() ? '接口' : ($obj->isTrait() ? 'Trait' : '类');

        $markdown[] = '## ' . $cln . " $t {#$cln}\n";
        $markdown[] = '`' . $clz . '`';
        $markdown[] = '';
        $markdown[] = "$doc\n";

        # 父类
        $parent = $obj->getParentClass();
        # 接口
        $its = $obj->getInterfaceNames();
        # Trait
        $tt = $obj->getTraitNames();
        if ($parent || $its || $tt) {
            $markdown[] = "";
            if ($parent) {
                $markdown[] = '* 继承自' . getUrl($parent->name);
            }
            if ($its) {
                $markdown[] = '* 实现接口:';
                foreach ($its as $it) {
                    $markdown[] = '    * ' . getUrl($it);
                }
            }
            if ($tt) {
                $markdown[] = '* 使用Trait:';
                foreach ($tt as $t) {
                    $markdown[] = '    * ' . getUrl($t);
                }
            }
            $markdown[] = '';
        }
        $ct = getCt($ann);
        if ($ct) {
            $markdown[] = "## 常量 {#ct}\n";
            $markdown[] = implode("\n", $ct) . "\n";
        }

        $pp = getPp($obj);
        if ($pp) {
            $markdown[] = "## 属性 {#pp}\n";
            $markdown[] = implode("\n", $pp) . "\n";
        }

        $md = getMd($obj);
        if ($md) {
            $markdown[] = "## 方法 {#md}\n";
            $markdown[] = implode("\n", $md);
        }

        file_put_contents($file, implode("\n", $markdown));
        echo $file, " done! \n";
        unset($markdown, $obj, $file, $clzs, $cln, $pp, $ct, $md);
    }

    function getCt(Annotation $ann) {
        $md  = [];
        $cts = $ann->getMultiValues('const');
        foreach ($cts as $cs => $v) {
            $md[] = '* ' . $v;
        }

        return $md;
    }

    function getPp(\ReflectionClass $obj) {
        $md  = [];
        $dps = $obj->getDefaultProperties();
        $pp  = $obj->getProperties(\ReflectionProperty::IS_PUBLIC | \ReflectionProperty::IS_PROTECTED);
        if ($pp) {
            foreach ($pp as $p) {
                $mp   = ['*'];
                $name = $p->getName();
                $mfs  = implode(' ', \Reflection::getModifierNames($p->getModifiers()));
                $doc  = $p->getDocComment();
                $mfs  = $mfs . ' $' . $name;
                if (isset($dps[ $name ])) {
                    $value = $dps[ $name ];
                    $type  = gettype($value);
                } else {
                    $type = '';
                }
                $mp[] = "`$mfs`: ";
                if ($doc) {
                    $ann = new Annotation($p);
                    $doc = $ann->getDoc();
                    $var = $ann->getString('var', $type);
                    if ($var) {
                        $mp[] = getUrl($var);
                    }
                    $mp[] = $doc;
                } else if ($type) {
                    $mp[] = "`$type`";
                }
                $md[] = implode(' ', $mp);
            }
        }
        unset($pp, $ann, $dps, $mp);

        return $md;
    }

    function getMd(\ReflectionClass $obj) {
        $md    = [];
        $mds   = $obj->getMethods(\ReflectionMethod::IS_PUBLIC | \ReflectionMethod::IS_PROTECTED);
        $pfid  = md5($obj->getFileName());
        $files = file($obj->getFileName());
        foreach ($mds as $m) {
            $fid = md5($m->getFileName());
            if ($pfid != $fid) {
                continue;
            }
            $mp   = ['### ' . $m->getName() . "\n"];
            $func = "```php\n";
            $ann  = new Annotation($m);
            $doc  = $ann->getDoc();
            $dc   = getDc($files, $m->getStartLine(), $m->isAbstract() ? ';' : '{');
            $ps   = getPs($m, $ann);
            $func .= $dc . "\n```";
            $mp[] = $func;
            $mp[] = '';
            $mp[] = $doc;
            $mp[] = '';
            $mp[] = "**参数**\n";
            if ($ps) {
                $mp[] = implode("\n", $ps);
            } else {
                $mp[] = '此函数不需要参数';
            }
            $mp[] = '';
            $mp[] = '**返回值**';
            $mp[] = '';
            $rtn  = $m->getReturnType();
            $mp[] = getUrl($ann->getString('return', $rtn ? $rtn . '' : '无'));
            $mp[] = '';
            $md[] = implode("\n", $mp);
            unset($ann);
        }
        unset($files, $mp);

        return $md;
    }

    function getPs(\ReflectionMethod $m, Annotation $ann) {
        $md   = [];
        $ps   = $m->getParameters();
        $args = $ann->getMultiValues('param');
        $pas  = getPa($args);
        foreach ($ps as $i => $p) {
            $pa    = $p->getName();
            $type  = $p->getType();
            $type  = $type ? " **$type** " : ' ';
            $vari  = $p->isVariadic();
            $md [] = getUrl('* `' . ($vari ? '...$' : '$') . $pa . '`' . (isset($pas[ $pa ]['t']) ? " **{$pas[$pa]['t']}** " : $type) . $pas[ $pa ]['p']);
        }
        unset($args, $pa, $type, $ps, $pas);

        return $md;
    }

    function getPa($args) {
        $pa = [];
        foreach ($args as $a) {
            if (preg_match('/^(?<t>[^\s]+)?(\s+)?\$(?<n>[\w][\w_\d]*)\s+(\[optional=(?<d>.+)])?(?<p>.+)$/i', trim($a), $ms)) {
                $pa[ $ms['n'] ] = $ms;
            }
        }

        return $pa;
    }

    function getDc($files, $pos, $needle = '{') {
        $pos1 = $pos - 1;
        if (!$files || !isset($files[ $pos1 ])) {
            return '';
        }
        $line = trim($files[ $pos1 ]);
        while (($pos = mb_strpos($line, $needle)) === false) {
            $pos1++;
            if (!isset($files[ $pos1 ])) {
                break;
            }
            $line .= trim($files[ $pos1 ]);
        }
        $dc = trim(mb_substr($line, 0, $pos));

        return $dc;
    }

    function getUrl($text) {
        return preg_replace_callback('/\\\\?wulaphp\\\\\w+(\\\\\w+)?\\\\\w+/i', function ($ms) {
            $clzs    = explode('\\', trim($ms[0], '\\'));
            $cln     = $clzs[ count($clzs) - 1 ];
            $clzs[0] = 'api';
            $clz     = implode('/', $clzs) . '.html';

            return '[' . $cln . '](/' . $clz . ')';
        }, $text);
    }

    function createIdx($classes) {
        ksort($classes);
        foreach ($classes as $cls) {
            if (isset($cls['children'])) {
                $file = BOOKY_ROOT . ltrim($cls['url'], '/') . '/index.md';
                echo $file, " created! \n";
                file_put_contents($file, "---\ntitle: {$cls['title']}\nlayout: api\napiHome: 1\n---\n\n");
                createIdx($cls['children']);
            }
        }
    }

    gendoc();
}