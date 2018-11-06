---
layout: post
title: "generatePrivate Exception 解决"
date: 2018-11-06 18:11
comments: true
categories: 
images: []
---

> java.security.spec.InvalidKeySpecException: java.security.InvalidKeyException: invalid key format 异常解决

私钥是直接生成的`pkcs8`格式,类似如下:

```
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL21hi3tyVA2ILrk
...
+bojB4QWBQi9zg==
```

直接在代码中使用`String`存储,利用类似如下代码进行签名:

<!--more-->

``` java
PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(prikeyvalue.getBytes());
KeyFactory keyf = KeyFactory.getInstance("RSA");
PrivateKey myprikey = keyf.generatePrivate(priPKCS8);
```

其中第三行报错,如下:

```
java.security.spec.InvalidKeySpecException: java.security.InvalidKeyException: invalid key format
	at sun.security.rsa.RSAKeyFactory.engineGeneratePrivate(RSAKeyFactory.java:217)
	at java.security.KeyFactory.generatePrivate(KeyFactory.java:372)
	at ...
Caused by: java.security.InvalidKeyException: invalid key format
	at sun.security.pkcs.PKCS8Key.decode(PKCS8Key.java:330)
	at sun.security.pkcs.PKCS8Key.decode(PKCS8Key.java:356)
	at sun.security.rsa.RSAPrivateCrtKeyImpl.<init>(RSAPrivateCrtKeyImpl.java:91)
	at sun.security.rsa.RSAPrivateCrtKeyImpl.newKey(RSAPrivateCrtKeyImpl.java:75)
	at sun.security.rsa.RSAKeyFactory.generatePrivate(RSAKeyFactory.java:316)
	at sun.security.rsa.RSAKeyFactory.engineGeneratePrivate(RSAKeyFactory.java:213)
	... 77 more
```

解决方式,秘钥`String`要先经过`Base64 Decode`,如下:

``` java
PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(prikeyvalue.getBytes());
//改成如下
PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(new Base64().decode(prikeyvalue.getBytes()));
```

这里的`Base64`类是指`org.apache.commons.codec.binary.Base64`.

问题解决