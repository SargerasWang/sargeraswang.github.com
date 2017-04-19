---
layout: post
title: "配置每次new_post后自动用Mou打开文章(续)"
date: 2013-12-19 22:13
comments: true
categories: 
images: [/images/blog_img/newpost.png]

---
[newpost]: {{page.images[0]}}

>已经有超过10天没有写过博客了，最近读完了Linux发明者[林纳斯·托瓦兹](http://zh.wikipedia.org/wiki/%E6%9E%97%E7%BA%B3%E6%96%AF%C2%B7%E6%89%98%E7%93%A6%E5%85%B9)的自传《Just For Fun》，受益匪浅。但我还是不想以读后感的形式写在这里，我想没有必要专门写一整篇，何时想起来何时写出来就好了。
<!-- more -->
这篇还是来擦屁股的，之前一篇[配置每次new_post后自动用Mou打开文章]({{site.url}}/blog/2013/11/16/pei-zhi-mei-ci-new-posthou-zi-dong-yong-mouda-kai-wen-zhang/),用了几次之后发现一个小问题，就是当我使用了`rake new_post['xxx']`之后，确实帮我使用Mou打开Markdown文件了，但是当前shell就没法用了，只有退出Mou后才可以使用。  

最近一直在找解决办法，今天终于找到了，就是`open`命令加上`-a`参数，官方是这样描述的：  
```
-a                Opens with the specified application.
```

那么，单独在shell中使用的代码就是：  
``` bash
open -a /Applications/Mou.app/Contents/MacOS/Mou xxx.markdown
```
测试成功，修改`Rakefile`文件中的：  
```
editor	= "/Applications/Mou.app/Contents/MacOS/Mou" 
```
为：  
```
editor	= "open -a /Applications/Mou.app/Contents/MacOS/Mou" 
```
大功告成，shell与Mou互不影响，效果如图：  
![][newpost]