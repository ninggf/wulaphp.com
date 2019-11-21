---
title: 客户端接入
showToc: 0
index: rest client
keywords: rest client RESTFul 客户端 业务参数 公共参数 签名算法 md5算法 php签名 java签名
desc: 开速接入RESTFul服务器，可自定义签名算法，支持业务、公共参数
---

{$toc}

## 概述 {#intro}

`RESTFulServer`的API基于HTTP协议来调用，其自定义了调用协议：

填充参数 -> 生成签名 -> 拼装HTTP请求 -> 发起HTTP请求 -> 得到HTTP响应 -> 解析json/xml结果.

## 公共参数 {#common}

调用任何一个API都必须传入的参数，目前支持的公共参数有：

|参数名称|参数类型|是否必须|参数描述|
|---|:---:|:---:|---|
|api|String|Y|API接口名称|
|app_key|String|Y|分配给客户端的AppKey|
|session|String|N|系统颁发给应用的会话信息，API标记有`SESSION`时此参数必填|
|timestamp|String|Y|时间戳，格式为yyyy-MM-dd HH:mm:ss GMT+8,例如:2017-01-01 12:00:00。RESTFul服务端允许客户端请求最大时间误差为5分钟|
|format|String|N|响应格式，默认为json格式,可选值:json,xml|
|v|Int|Y|API版本|
|sign_method|String|Y|签名的摘要算法，可选值为：hmac，md5，sha1|
|sign|String|Y|API输入参数签名结果，签名算法参照下面的介绍。|

## 业务参数 {#params}

API调用除了必须包含公共参数外，如果API本身有业务级的参数也必须传入，每个API的业务级参数请考API文档说明。

## 签名算法 {#sign}

为了防止API调用过程中被黑客恶意篡改，调用任何一个API都需要携带签名，`RESTFulServer`服务端会根据请求参数，对签名进行验证，签名不合法的请求将会被拒绝。如果为`RESTFulServer`指定了自己定义的签名器，那么签名过程请自行解决。

### 默认签名算法 {#dsign}

默认的`RESTFulServer`签名器`DefaultSignChecker`目前支持的签名算法有三种：MD5(sign_method=md5)，HMAC_MD5(sign_method=hmac), SHA1(sign_method=sha1)，签名大体过程如下：

* 对所有API请求参数（包括公共参数和业务参数，但除去sign参数），根据参数名称的ASCII码表的顺序排序。如：foo=1, bar=2, foo_bar=3, foobar=4排序后的顺序是bar=2, foo=1, foo_bar=3, foobar=4。

    1. 如果参数对应的是文件，则取文件的sha1摘要进行签名，如: file参数是文件，转换后为file=SHA1(file的内容)
    2. 如果参数是数组，则需将参数进行如下转换: arg[0]=1,arg[1]=2
    3. 如果参数是关联数组(map)，则需要对其进行按key按ASCII码表的顺序排序后按数组的方式处理。

* 将排序好的参数名和参数值拼装在一起，根据上面的示例得到的结果为：bar2foo1foo_bar3foobar4
* 把拼装好的字符串采用utf-8编码，使用签名算法对编码后的字节流进行摘要。如果使用MD5或SHA1算法，则需要在拼装的字符串前后加上app的secret后，再进行摘要，如：md5(bar2foo1foo_bar3foobar4+secret)；如果使用HMAC_MD5算法，则需要用app的secret初始化摘要算法后，再进行摘要，如：hmac_md5(bar2foo1foo_bar3foobar4)。
* 将摘要得到的字节流结果使用十六进制表示，如：hex(“helloworld”.getBytes(“utf-8”)) = “68656C6C6F776F726C64”

> 说明：MD5和HMAC_MD5都是128位长度的摘要算法，用16进制表示，一个十六进制的字符能表示4个位，所以签名后的字符串长度固定为32个十六进制字符。

#### JAVA签名示例代码 {#java}

```java
public static String signTopRequest(Map<String, String> params, String secret, String signMethod) throws IOException {
    // 第一步：检查参数是否已经排序
    String[] keys = params.keySet().toArray(new String[0]);
    Arrays.sort(keys);

    // 第二步：把所有参数名和参数值串在一起
    StringBuilder query = new StringBuilder();
    if (Constants.SIGN_METHOD_MD5.equals(signMethod)) {
        query.append(secret);
    }
    for (String key : keys) {
        String value = params.get(key);
        if (StringUtils.areNotEmpty(key, value)) {
            query.append(key).append(value);
        }
    }

    // 第三步：使用MD5/HMAC加密
    byte[] bytes;
    if (Constants.SIGN_METHOD_HMAC.equals(signMethod)) {
        bytes = encryptHMAC(query.toString(), secret);
    } else {
        query.append(secret);
        bytes = encryptMD5(query.toString());
    }

    // 第四步：把二进制转化为大写的十六进制
    return byte2hex(bytes);
}

public static byte[] encryptHMAC(String data, String secret) throws IOException {
    byte[] bytes = null;
    try {
        SecretKey secretKey = new SecretKeySpec(secret.getBytes(Constants.CHARSET_UTF8), "HmacMD5");
        Mac mac = Mac.getInstance(secretKey.getAlgorithm());
        mac.init(secretKey);
        bytes = mac.doFinal(data.getBytes(Constants.CHARSET_UTF8));
    } catch (GeneralSecurityException gse) {
        throw new IOException(gse.toString());
    }
    return bytes;
}

public static byte[] encryptMD5(String data) throws IOException {
    return encryptMD5(data.getBytes(Constants.CHARSET_UTF8));
}

public static String byte2hex(byte[] bytes) {
    StringBuilder sign = new StringBuilder();
    for (int i = 0; i < bytes.length; i++) {
        String hex = Integer.toHexString(bytes[i] & 0xFF);
        if (hex.length() == 1) {
            sign.append("0");
        }
        sign.append(hex.toUpperCase());
    }
    return sign.toString();
}
```

#### PHP签名示例代码 {#php}

```php
function chucksum(array $args, $appSecret) {
    $type = $args['sign_method'];
    sortArgs($args);
    $sign = [];
    foreach ($args as $key => $v) {
        if (is_array($v)) {
            foreach ($v as $k => $v1) {
                if ($v1{0} == '@') {
                    $sign [] = $key . "[{$k}]" . getfileSha1($v1);
                } else if ($v1 || is_numeric($v1)) {
                    $sign [] = $key . "[{$k}]" . $v1;
                } else {
                    $sign [] = $key . "[{$k}]";
                }
            }
        } else if ($v{0} == '@') {
            $sign [] = $key . getfileSha1($v);
        } else if ($v || is_numeric($v)) {
            $sign [] = $key . $v;
        } else {
            $sign [] = $key;
        }
    }
    $str = implode('', $sign);
    if ($type == 'sha1') {
        return sha1($str . $appSecret);
    } else if ($type == 'hmac') {
        return hash_hmac('sha256', $str, $appSecret);
    } else {
        return md5($str . $appSecret);
    }
}
function sortArgs(array &$args) {
    ksort($args);
    foreach ($args as $key => $val) {
        if (is_array($val)) {
            ksort($val);
            $args [ $key ] = $val;
            sortArgs($val);
        }
    }
}
function getfileSha1($value) {
    $file = trim(substr($value, 1), '"');
    if (is_file($file)) {
        return sha1_file($file);
    } else {
        return 'fnf';
    }
}
```

## RESTFulClient

可以通过框架内置的[RESTFulClient](/api/restful/RESTFulClient.html)进行快速接入，简单快捷。

## 注意事项 {#note}

* 所有的请求和响应数据编码皆为utf-8格式，URL里的所有参数名和参数值请做URL编码。如果请求的Content-Type是application/x-www-form-urlencoded，则HTTP Body体里的所有参数值也做URL编码；如果是multipart/form-data格式，每个表单字段的参数值无需编码,但每个表单字段的charset部分需要指定为utf-8。

* GET请求时，参数名与参数值拼装起来的URL长度要小于1024个字符。
* 标记为`GET`的API使用GET请求，`POST`的API必须使用POST方法.
