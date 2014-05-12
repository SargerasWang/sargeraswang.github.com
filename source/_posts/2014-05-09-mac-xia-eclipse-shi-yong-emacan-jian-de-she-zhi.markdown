---
layout: post
title: "Mac 下 Eclipse 使用Emac按键的设置"
date: 2014-05-09 16:41
comments: true
categories: 
images: [/images/blog_img/emac_eclipse.png,
         /images/blog_img/eclipse_keys.png,
         /images/blog_img/eclipse_keys2.png,
         /images/blog_img/eclipse_keys3.png]

---
[emac_eclipse]: {{page.images[0]}}
[eclipse_keys]: {{page.images[1]}}
[eclipse_keys2]: {{page.images[2]}}
[eclipse_keys3]: {{page.images[3]}}

> 来填坑了，当初自己写下的文字果然力量非凡，原先就是因为不喜欢在编码时，总是需要右手离开主键盘区，找方向键来控制光标而烦恼，所以学了emacs。但是eclipse的emacs键位并不怎么好用，所以本文是记录如何设置eclipse的光标控制。**好吧，主要是填坑[10篇vs19天博客撰写小结]({{ site.url }}/blog/2013/11/29/10pian-vs19tian-bo-ke-zhuan-xie-xiao-jie/)**
<!-- more -->
###需要什么
首先要分析需求，很简单，我不想让右手离开主键位区，去找上下左右按键。

那么，我需要能修改以下按键 ：

* 上 
* 下 
* 左
* 右
* 行头
* 行尾

###Keys很强大
1. 去 eclipse->Preferences (快捷键 `Commend+，`)，filter中输入`Kyes`.
   ![][eclipse_keys]
2. 设置以下按键
    * 上 `Line Up` 为 `Ctrl+P`
    * 下 `Line Down` 为 `Ctrl+N`
    * 左 `Previous Column` 为 `Ctrl+B`
    * 右 `Next Column` 为 `Ctrl+F`
    * 行头 `Line Start` 为 `Ctrl+A`
    * 行尾 `Line End` 为 `Ctrl+E`  
    ![][eclipse_keys2]
    
###OK了，解放你的右胳膊吧
之所以现在才写这篇，是因为我一直认为`左`和`右`应该是`Back`和`Forward`,一直无法使用，甚是恼火，直到我看了eclipse自带的emacs按键方案。

![][eclipse_keys3]

> 哈，到现在，当初的坑就剩下最后一个了 **使用maven搭建SSH框架**