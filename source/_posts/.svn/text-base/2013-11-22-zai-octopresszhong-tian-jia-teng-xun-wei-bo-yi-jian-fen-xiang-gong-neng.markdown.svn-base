---
layout: post
title: "在Octopress中添加腾讯微博一键分享功能"
date: 2013-11-22 19:04
comments: true
categories: 
---
>前两天为我的博客添加了腾讯微博的一键分享功能，过程记录在这里。
>Emacs使用手册系列要过几天才能写了。
>接下来的首要任务是要研究一下用maven的archetype搭建一个SSH。

{% img /images/blog_img/qqweibo.png %}

<!-- more -->

###申请一键分享代码
先去[腾讯微博开放平台](http://dev.t.qq.com/)登陆后,点【网站接入】  
{% img /images/blog_img/wangzhanjieru.png 160 %}  
再点【一键分享】  
{% img /images/blog_img/yijianfenxiang.png 160 %}  
再点【立即使用】  
{% img /images/blog_img/lijishiyong.png %} 
然后填写【网站名称】和【网站地址】，选择一个样式，点【获取代码】  
然后你可以看到两段代码：  
一段是DIV
``` html
<div id="qqwb_share__" data-appkey="你的key" data-icon="0" data-counter="0" data-content="{title}" data-pic="{pic}"></div>
```
一段是JavaScript
``` html
<script src="http://mat1.gtimg.com/app/openjs/openjs.js#autoboot=no&debug=no"></script>
```

###添加代码到Octopress
####第一段div
打开octopress/source/_includes/post/sharing.html  
加入
{% raw %}
``` html
{% if site.qq_weibo %} 
    <div id="qqwb_share__" data-appkey="{{site.qq_weibo_key}}" data-icon="1" data-counter="0" data-counter_pos="{{qq_weibo_data_pos}}" data-content="{{page.title}}" data-pic=""></div>
{% endif %}
```
{% endraw %}
然后打开_config.yml
加入  
```
# qq weibo
qq_weibo: true
qq_weibo_key: 你的key
qq_weibo_data_pos: right
```
####第二段JavaScript
打开octopress/source/_includes/custom/head.html  
加入  
``` html
<script src="http://mat1.gtimg.com/app/openjs/openjs.js#autoboot=no&debug=no"></script>
```
####测试
```
rake generate
rake preview
```
看下效果，应该就可以了

###初阶完善
####位置问题

上面的代码生成后，一键分享按钮在画面的左对齐，看着很不顺眼，我想要他居中。试了下在div上加 `style="text-align:center;"`,没有用，用开发者模式看一下这个div，发现： 

{% img /images/blog_img/divDebug.png %}   

Div上被加了`style="textalign:left;"`的属性，那段JavaScript一定是凶手，然后就去看[这段JavaScript	](http://mat1.gtimg.com/app/openjs/openjs.js#autoboot=no&debug=no)（一坨代码，你可以用GoogleChrome的[这个插件](https://chrome.google.com/webstore/detail/piekbefgpgdecckjcpffhnacjflfoddg)来格式化一下，方便阅读），搜索`text-align:left`,找到了：  
{% img /images/blog_img/textAlign.png %} 

凶手是找到了，可是尝试过加一段JavaScript盖掉`text-align`,没有起到作用，一定是我的JavaScript功力不够。换个思路，最后决定用table了。最终可以达到居中效果的完整代码如下：  

{% raw %}
``` html
{% if site.qq_weibo %} 
<table width="100%">
<tr>
<td>&nbsp;</td>
<td width="62px">
    <div id="qqwb_share__" data-appkey="{{site.qq_weibo_key}}" data-icon="1" data-counter="0" data-counter_pos="{{qq_weibo_data_pos}}" data-content="{{page.title}}" data-pic="{{site.url}}/images/blog-title.png"></div>
</td>
<td>&nbsp;</td>
</tr>
</table>
{% endif %}
```
{% endraw %}
###不尽人意之处
1. image应该可以读取文章中的所有图片才对，后续研究后补到这里。
2. 最后用table定位居中的方式蠢了一些，后续有更好的解决办法再补到这里。
<font color="green">@2013-12-10 这个已解决[链接]({{site.url}}/blog/2013/12/09/octopresstian-jia-teng-xun-wei-bo-fen-xiang-zhong-tu-pian-de-wen-ti/)</font>