---
layout: post
title: "发布Jar到Maven中央仓库遇到的问题笔记"
date: 2017-10-25 20:52
comments: true
categories: 
images: []
---
本来在github上有开源一个java的Excel导入导出工具包([ExcelUtil](https://github.com/SargerasWang/ExcelUtil))

最近在处理bug的时候,看到有位朋友[希望作者能把构件上传至Maven中央库中](https://github.com/SargerasWang/ExcelUtil/issues/11),想来为了方便大家,就按照他博客文章[发布构件至Maven中央库](http://www.arccode.net/publish-artifact-to-maven-central-repository.html)中的步骤去做,期间遇到一些问题,在这里记录.

###GPG安装

目前直接安装最新的是`gpg2`所以,执行任何命令都应该是`gpg2`开头

###将公钥发布到 PGP 密钥服务器

执行

```
gpg --keyserver hkp://pool.sks-keyservers.net --send-keys 
```

会有报错

`gpg: keyserver send failed: No route to host`

修改为,网络上提供的

`hkp://ipv4.pool.sks-keyservers.net:80`

则会有错误

`gpg: keyserver send failed: End of file`

或

`gpg: keyserver send failed: No name`


最终,还是在官网查到了可用的地址:

```
hkp://p80.pool.sks-keyservers.net:80
```

**查询公钥是否发布成功 同理使用这个url**

###上传构件至OSS中
由于gpg的maven插件,默认使用`gpg`命令,所以执行`mvn clean deploy`会有如下错误:

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-gpg-plugin:1.6:sign (default) on project excel-util: Unable to execute gpg command: Error while executing process. Cannot run program "gpg": error=2, No such file or directory -> [Help 1]

```

应在`pom.xml`中增加设置,`<properties>`中增加`<gpg.executable>gpg2</gpg.executable>`

以上是遇到的所有问题.


在release完成后,客服答复是这样的:

>Central sync is activated for com.sargeraswang. After you successfully release, your component will be published to Central, typically within 10 minutes, though updates to search.maven.org can take up to two hours.


大概意思是,10分钟内会被发布到中央仓库,两小时内会更新到`search.maven.org`