---
layout: post
title: "10篇vs19天博客撰写小结"
date: 2013-11-29 22:07
comments: true
categories: 博客
---
>刚才看了[战隼的学习探索-我的战拖策略](http://www.read.org.cn/html/2314-wo-de-zhan-tuo-ce-lue.html),想想自己距上一篇博文也有3天了，回想在博客搭建好的第二天，我曾说[频率暂定最少3天一篇]({{ site.url }}/blog/2013/11/12/guan-yu-wo-yu-dao-de-wen-ti/)。

如果用除法，10篇/19天，平均2天一篇，应该算合格。  
但这就是在给自己找借口，我肯定当天所说“最少3天一篇”的愿意是“要把写博客当做一种习惯”，《自控力》中曾经说过：当我们不想做一件事情的时候，大脑就会想好各种“合理”的原因，让你不至于太痛苦。
<!-- more -->
说到《自控力》这本书，对我的影响还是极大的。看到第三章的时候，我决定戒烟了，然后就真的戒了。后来觉得吃素比较好，然后到现在都能保持。

**从这本书中，我到底学到了什么？**
>直面内心，不要逃避

自从看完书后，每当我发现自控力变弱的时候，就放好心态，去看看脑子里到底是怎么想的，如何帮助自己的失控找借口的。  
这样思考的次数多了，自然就会有相应地策略。也就是说，要和那个容易失控的自己做斗争。既然是和另一个“自己”作斗争，那么只要你存在，他就存在，所以没有必要想着“三天内改变自己”，“一个月减肥5公斤”。  
那只是三分钟的热度，书中作者说道，自控力是会消耗的能量，也就是说会有用完的时候。

但是，自控力也可培养，慢慢的变多，方式之一就是从养成小习惯开始。

***
好吧，以上内容，只是一时想起，就写下来了，跑题很远。

今天既然是小结，就把前几篇博客遗漏的，没有做完的事情列出来，生成一个TODO List:

* 在写[添加评论功能]({{ site.url }}/blog/2013/11/13/tian-jia-ping-lun-gong-neng/)这篇的时候，我并不知道如何才能把`{% raw %}{% if %}{% endraw %}`转义掉，就用了全角大括号这一招，但是后来我在octopress官网上找到了解法，就是`raw`标签:

{% raw %}
```
{% if %}{% endif %}
```
{% endraw %}

{% img /images/blog_img/rawtag.png %}

* 在写完[配置每次new_post后自动用Mou打开文章]({{ site.url }}/blog/2013/11/16/pei-zhi-mei-ci-new-posthou-zi-dong-yong-mouda-kai-wen-zhang/)之后，我一直用到现在，问题也就出现了，自动用Mou打开文章后，终端就一直在等Mou关闭才能继续；而且一旦关闭终端，Mou也会被关闭，
<font color="green">这个已解决[链接]({{site.url}}/blog/2013/12/19/pei-zhi-mei-ci-new-posthou-zi-dong-yong-mouda-kai-wen-zhang-xu/)</font>。  
{% img /images/blog_img/shellWaitMou.png %}

* 在[MarkDown 语法说明]({{ site.url }}/blog/2013/11/16/markdown-yu-fa-shuo-ming/)一文中，有说道“表格(在Octopress中并没有画出线，后续解决)”,后来有查过解决方案，是修改css，但是一直没有动手改，
<font color="green">这个已解决[链接]({{site.url}}/blog/2013/12/09/jie-jue-octopressde-biao-ge-yang-shi-wen-ti/)</font>。

* 关于在[Emacs使用手册(一) 基本操作]({{ site.url }}/blog/2013/11/17/emacsshi-yong-shou-ce/)中我说要学习Emacs的原因是eclipse有这个键位支持方案，后来我有坚持使用一周这个方案，最终放弃了，原因是eclipse的默认emacs方案并没有支持所有按键（我最不能忍受的是系统自动提示的时候，Ctrl+N并不能当做↓来使用），Google了一下，发现一个eclipse的emacs插件（[Emacs+ Eclipse Plug-in](http://www.mulgasoft.com/)）,但是作者已经不维护了，新版Eclipse中使用会报错，所以现在我还忍受着手要离开主键盘去按上下左右的痛苦，
<font color="green">这个已解决[链接]({{site.url}}/blog/2014/05/09/mac-xia-eclipse-shi-yong-emacan-jian-de-she-zhi/)</font>。  
{% img /images/blog_img/emacsPlus.png %}

* 既然是叫做“Emacs使用手册(一) 基本操作”，就说明至少还应该有“二”，不能假装忘记，
<font color="green">这个已解决[链接]({{site.url}}http://127.0.0.1:4000/blog/2014/03/18/emacsshi-yong-shou-ce-er-shi-yong-jin-jie/)</font>。

* 在[在Octopress中添加腾讯微博一键分享功能]({{ site.url }}/blog/2013/11/22/zai-octopresszhong-tian-jia-teng-xun-wei-bo-yi-jian-fen-xiang-gong-neng/) 最后，有提出两点"不尽人意之处"，
<font color="green">2013-12-10 这个已解决[链接]({{site.url}}/blog/2013/12/09/octopresstian-jia-teng-xun-wei-bo-fen-xiang-zhong-tu-pian-de-wen-ti/)</font>。

* 在[Appfuse搭建SSH的问题与解决]({{ site.url }}/blog/2013/11/25/appfuseda-jian-sshde-wen-ti-yu-jie-jue/)写完之后，我有大概看过整个生成的项目，其中除了我想要的Spring+Struts2+Hibernate之外，有太多太多的其他东西。所以不适用，后来我又试了简易版的Light版，好像有好一些，但总是觉得不如从头自己搭建一个来的舒心，吃的放心，就这么定了，自己搭建一个，然后过程记录在博客里，
<font color="red">这个待解决</font>。

###惊人
一共11篇博客，就有6个待办事项，我的大脑在20:00的时候还很痛苦于“到底应该写一篇什么呢，没有题材啊！”,这完全是在给自己不想动手而找借口。

* 还有一个才对，搜索引擎收录的问题，百度已经解决了，但是Google为何没有收录，还没有找到原因，
<font color="green">这个已解决[链接]({{site.url}}/blog/2013/12/06/googleyi-jing-shou-lu-liao/)</font>。

{% img /images/blog_img/baidu.png %}