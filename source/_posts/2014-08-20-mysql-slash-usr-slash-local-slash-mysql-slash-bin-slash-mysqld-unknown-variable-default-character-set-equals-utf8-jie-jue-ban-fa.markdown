---
layout: post
title: "mysql  /usr/local/mysql/bin/mysqld: unknown variable default-character-set=utf8 解决办法"
date: 2014-08-20 20:21
comments: true
categories: 
images: [/images/blog_img/mysql_status.png]

---
[ok]:{{page.images[0]}}
![][ok]


为了修改mysql默认字符集,按照网上的方式,修改了`my.cnf`,之后启动mysql报错:

```
 [ERROR] /usr/local/mysql/bin/mysqld: unknown variable
 'default-character-set=utf8'

```

后来Google到[官网的这篇文章](http://lists.mysql.com/mysql/226319).

其中说道:

`The above link says default-character-set is depreciated and you should
be   using  character-set-server. It also states default-character-set
was removed in v5.5.3.`

解决方法:把`my.cnf` 中的

```
default-character-set=utf8
```

修改为

```
character-set-server=utf8
```

成功启动mysql.