---
layout: post
title: "关于我遇到的问题"
date: 2013-11-12 21:26
comments: true
categories: 
---
###环境

Mac OSX 10.9 (已安装XCode 5.0.1)

###流程

我是按照[这篇文章](http://beyondvincent.com/blog/2013/08/03/108-creating-a-github-blog-using-octopress/ "利用Octopress搭建一个Github博客")来操作的。

####安装ruby
这里打上命令试了好久都不行，最后发现，原来系统里已经有ruby了，不知道是OSX10.9自带的还是XCode带的。利用
{% codeblock lang:bash %}
$ ruby -v
{% endcodeblock %}
就可以看到，目前使用的ruby版本号。就像我这里显示的是：
{% codeblock lang:bash %}
ruby 2.0.0p247 (2013-06-27 revision 41674) [universal.x86_64-darwin13]
{% endcodeblock %}
####安装Octopress
<!--more-->
这步的时候，已经有了先前的经验，我知道自己已经有git了，
{% codeblock lang:bash %}
$ git clone git://github.com/imathis/octopress.git octopress
$ cd octopress
{% endcodeblock %}
还是很顺利的。
{% codeblock lang:bash %}
$ gem install bundlerrbenv rehash
{% endcodeblock %}
就没那么顺利了，看起来是网络的问题，google了一下，有一个解决方案就是把sources替换掉。[这里](http://ruby.taobao.org/)有如何使用的教程。
{% codeblock lang:bash %}
$ gem sources --remove https://rubygems.org/
$ gem sources -a http://ruby.taobao.org/
$ gem sources -l
*** CURRENT SOURCES ***
http://ruby.taobao.org
# 请确保只有 ruby.taobao.org
$ gem install rails
{% endcodeblock %}
####后续操作
在后面的**配置Octopress**、**将博客部署到GitHub上**、**开始写博客**，都没有什么问题。
####更换主题
如果对默认的主题不爽，可以安装第三方主题，链接在这里：[https://github.com/imathis/octopress/wiki/3rd-Party-Octopress-Themes](https://github.com/imathis/octopress/wiki/3rd-Party-Octopress-Themes)	

###如何坚持写博客？
关于程序员为什么应该写博客的文章数不胜数，之前的我也经常找借口不写，比方说xx空间，xx博客都不适合我写东西。

现在，自己给自己绝了后路（这是一种自控的方式，参见《自控力》一书）没有了借口。

但是，想让一个长远目标真的能实现，就要有计划，而计划的难以程度要以自己能办到，且不会太容易为基准。而且要有内容可写。

频率暂定最少3天一篇，内容嘛，这博客刚刚搭建起来，关于Octopress和MarkDown语法的学习，应该可以写几篇了，之后或许会读一次《Java核心技术》，写读书笔记，或者从头学习IOS开发，写学习笔记。

为梦想而努力吧！