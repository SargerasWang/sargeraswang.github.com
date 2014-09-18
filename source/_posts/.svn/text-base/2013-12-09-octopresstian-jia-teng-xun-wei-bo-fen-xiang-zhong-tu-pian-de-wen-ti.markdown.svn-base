---
layout: post
title: "Octopress添加腾讯微博分享中图片的问题"
date: 2013-12-09 22:44
comments: true
categories: 
images: [/images/blog_img/naruto/Naruto.jpg,
		/images/blog_img/naruto/Rin.jpg,
		/images/blog_img/naruto/success.png]

---
[Raruto]: {{page.images[0]}}
[Rin]: {{page.images[1]}}
[Success]: {{page.images[2]}}

>这篇又是来收拾残局的，之前[在Octopress中添加腾讯微博一键分享功能]({{site.url}}/blog/2013/11/22/zai-octopresszhong-tian-jia-teng-xun-wei-bo-yi-jian-fen-xiang-gong-neng/)最后，说有两点不尽人意之处，第二点是居中的手段太低劣，这个我放弃调试了，第一点是image应该可以取文章中的所有图片才对，搞了两天，终于搞了一个像样的解决方式。

<!-- more -->
####在`source/_includes/post/sharing.html`添加微博分享处添加

{% raw %}
```
{% if page.images %}
{% capture carriage_return %}
{% endcapture %}
	{% capture weiboImg %}
		{% for item in page.images %}
			{{ site.url | append: item | append: '|' }}
		{% endfor %}
	{% endcapture %}
{% else %}
	{% capture weiboImg %}
		{{site.url}}/images/blog-title.png 【这是备用图片路径，就是当博客图片为空时使用这张】
	{% endcapture %}
{% endif %}
```
####原先的Div的data-pic修改为
```
data-pic="{{weiboImg| remove: ' ' | remove: '	'| remove: carriage_return }}"
```
上面那些`remove`是因为在测试中发现，太多的空格和tab和换行，会导致出现的图片变少
{% endraw %}

####博客中的图片声明在MarkDown文件的[frontmatter](http://jekyllrb.com/docs/frontmatter/)处，如下写法
```
images: [/images/blog_img/naruto/Naruto.jpg,
		/images/blog_img/naruto/Rin.jpg]
```
这样的话，`images`就是一个Array类型对象了
####图片声明方式改为参考式写法，如下
{% raw %}
```
[Raruto]: {{page.images[0]}}
[Rin]: {{page.images[1]}}
随便别的文字
![鸣人][Raruto]
![琳][Rin]
```
{% endraw %}
效果如：  
![鸣人][Raruto]
![琳][Rin]	

点击【转播】按钮，后的效果图如：

![][Success]