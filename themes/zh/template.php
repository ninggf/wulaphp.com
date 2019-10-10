<?php

use wulaphp\router\Router;

function zh_api_template_data(&$data) {
    $url     = Router::getURI();
    $jc      = @file_get_contents(BOOKY_ROOT . 'api.json');
    $apiData = @json_decode($jc, true);
    $urls    = explode('/', trim($url, '/'));
    $actives = [];
    $aurl    = '';

    foreach ($urls as $u) {
        $aurl      .= '/' . $u;
        $actives[] = $aurl;
    }

    if ($apiData && !preg_match('#\.html#', $url)) {
        array_shift($urls);
        $idx = $apiData;
        foreach ($urls as $u) {
            $idx = $idx[ $u ]['children'];
        }
        $idxes = ['pkgs' => [], 'clzs' => []];
        foreach ($idx as $api) {
            if (isset($api['children'])) {
                $idxes['pkgs'][] = $api;
            } else {
                $idxes['clzs'][] = $api;
            }
        }
        $data['apiIndexes'] = $idxes;
    }
    $data['pageUrl']   = $url;
    $data['actives']   = $actives;
    $data['apiData']   = $apiData ? $apiData : [];
    $data['pageTitle'] = '首页名称';
}