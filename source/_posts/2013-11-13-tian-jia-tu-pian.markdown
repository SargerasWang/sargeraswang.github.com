---
layout: post
title: "在Octopress中添加图片"
date: 2013-11-13 22:43
comments: true
categories: 
---
{% img /images/blog_img/tenten.jpg %}

1.把图片copy到/source/images 下,例如我这张图片叫做tenten.jpg

2.添加代码
``` 
{% raw %}{% img /images/blog_img/tenten.jpg %}{% endraw %}
```

以下摘自[octopress的官网](http://octopress.org/docs/plugins/image-tag/)中关于Image Tag 的介绍
<!-- more -->
###语法格式

```
{% raw %}{% img [class names] /path/to/image [width] [height] [title text [alt text]] %}{% endraw %}
```

{% img /images/blog_img/tenten.jpg 100 100 %}

上面这个是设置过大小的,代码如下：
```
{% raw %}{% img /images/blog_img/tenten.jpg 100 100 %}{% endraw %}
```

{% img /images/blog_img/tenten.jpg 200 200 火影中的人物-天天 %}

上面这个是加了描述的，鼠标悬浮的时候可以看到'火影中的人物-天天'，代码如下：
```
{% raw %}{% img /images/blog_img/tenten.jpg 200 200 火影中的人物-天天 %}{% endraw %}
```
