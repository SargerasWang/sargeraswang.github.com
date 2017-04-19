---
layout: post
title: "rake deploy 出现Could not resolve host: github.com 的解决方法"
date: 2013-11-14 22:15
comments: true
categories: 
---
{% img /images/blog_img/gfw.jpg %}

今天上午看自己的博客，发现昨晚好像没有deploy，博客好多地方都有问题。

晚上回来，检查，确实有错误，修改完，打算提交，就执行了

```
reke deploy
```
看到最后显示的是
```
## Github Pages deploy complete
```
就以为成功了，遂上博客观察，还是没有改变，又去清浏览器缓存，还是没有改变。再次执行
<!-- more -->
```
rake deploy
```
这次仔细看了一下console输出
```
## Pushing generated _deploy website
fatal: unable to access 'https://github.com/SagerasWang/sageraswang.github.com.git/': Could not resolve host: github.com

## Github Pages deploy complete
```
原来如此，访问github.com无法解析了。

这一定是我大[GFW](http://zh.wikipedia.org/zh-cn/%E9%98%B2%E7%81%AB%E9%95%BF%E5%9F%8E)的功劳，好吧，幸亏我有[goagent](https://code.google.com/p/goagent/).

{% img /images/blog_img/goagent.png %}

在shell中执行

```
set HTTP_PROXY=http://127.0.0.1:8087
rake deploy
```
这次ok了，成功deploy！
