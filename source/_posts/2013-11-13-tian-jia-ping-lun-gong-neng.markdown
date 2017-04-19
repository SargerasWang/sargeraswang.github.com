---
layout: post
title: "添加评论功能"
date: 2013-11-13 21:01
comments: true
categories: 
---
今天同事听说我有博客了，表示要上来评论一番，我才想起来还没有这个功能，遂加了一个，过程记录在这里，整个过程以**破船**的[这篇文章](http://beyondvincent.com/blog/2013/07/27/107-hello-page-of-github/)为基础，我只是稍作改动。
###一. 多说网注册账号

去[多说网](http://duoshuo.com/),点[我要安装],选一个账号登陆，我直接选的QQ登陆。

授权后，进入[创建站点]的页面，站点名称填一下

站点地址，像我就是http://sageraswang.github.com

多说域名，应该就是shortname，我用的是 sageraswang

电子邮箱等自己填。

之后点击[创建].

###二. 添加代码
<!--more-->
注册之后，会跳转到通用代码的页面。
其中，只需要用到的是short_name的值，像我就是sageraswang
{% codeblock lang:js %}
var duoshuoQuery = {short_name:"sageraswang"};
{% endcodeblock %}

####修改_config.yml

在文件最后添加
{% codeblock %}
#duoshuo comments
duoshuo_comments: true
duoshuo_short_name: yourname
{% endcodeblock %}

其中，“yourname”替换成你的**short_name**。

####修改/source/_layouts/post.html

打开post.html ,找到 &lt;section&gt;标签,把包括上下的if在内，都删除，换成
{% codeblock lang:html %}
｛% if site.duoshuo_short_name and site.duoshuo_comments == true and page.comments == true %｝
  <section>
    <h1>评论</h1>
    <div id="comments" aria-live="polite">｛% include post/duoshuo.html %｝</div>
  </section>
｛% endif %｝
{% endcodeblock %}
上面代码中的**大括号**我都换成了**全角**，你粘贴后应换回**半角**。

####创建/source/_includes/post/duoshuo.html

写入以下内容
{% codeblock lang:html %}
<!-- Duoshuo Comment BEGIN -->
<div class="ds-thread"></div>
<script type="text/javascript">
  var duoshuoQuery = {short_name:"yourname"};
  (function() {
    var ds = document.createElement('script');
    ds.type = 'text/javascript';ds.async = true;
    ds.src = 'http://static.duoshuo.com/embed.js';
    ds.charset = 'UTF-8';
    (document.getElementsByTagName('head')[0] 
    || document.getElementsByTagName('body')[0]).appendChild(ds);
  })();
</script>
<!-- Duoshuo Comment END -->
{% endcodeblock %}

其中，“yourname”替换成你的**short_name**。

####生成+预览+发布

shell命令

{% codeblock lang:bash %}
$ rake generate
$ rake preview
{% endcodeblock %}
进入http://127.0.0.1:4000/ 看一下效果，点某一篇文章，看最后是否出现了评论模块。
如果一切正常，就发布到github
{% codeblock lang:bash %}
$ rake deploy
{% endcodeblock %}

####完成

到此，评论功能添加完成，**enjoy it**!