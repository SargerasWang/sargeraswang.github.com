---
layout: post
title: "Emacs使用手册(一) 基本操作"
date: 2013-11-17 15:07
comments: true
published: true
categories: 
---
>我之所以学习Emacs而不是Vim的原因是Eclipse有Emacs键位方案，而这个方案可以解决困扰了我长久的问题：手总需要离开主键位去按方向键，这样浪费时间。
{% img /images/blog_img/emacs/eclipseKeys.png %}

```
本文中的Ctrl+x,指的是按住Ctrl按x键
Esc+x,指的是先按一下Esc，再按下x键
```
* * *
<!-- more -->
* Emacs启动，直接在终端中直接打`emacs`。
{% img /images/blog_img/emacs/start.png %}
* 结束Emacs：`Ctrl+x Ctrl+c`,其实就是按住`Ctrl`然后`x`，然后`c`。
* 取消（终止）执行：`Ctrl+g`
  * 有些命令会跑很久，可以用这个命令中断
  * 按错键也可以用这个命令取消
* 移动光标
  * 向上（previous line）`Ctrl+p`
  * 向下（next line）`Ctrl+n`
  * 向左（backward）`Ctrl+b`
  * 向右（forward）`Ctrl+f`
  * 行首 `Ctrl+a`
  * 行尾 `Ctrl+e`
  * 句首 `Esc+a` 以`。`为基准
  * 句尾 `Esc+e`
  * 文档开头 `Esc+<`
  * 文档结束 `Esc+>`

  <pre>
	Esc+<				Ctrl+p
	Ctrl+a		Ctrl+b	  原点		Ctrl+f		Ctrl+e
						Ctrl+n						Esc+>
	xxxxxxxxx。[Esc+a]xxxxxx原点xxxxxx。[Esc+e]xxxxxx
  </pre>

* 翻页
  * 上一页 `Esc+v`
  * 下一页 `Ctrl+v`
  >翻页时，上一页末尾会留一点在荧幕最上面，以维持连续性
  >在光标接近荧幕最下方时会自动跳半页，把档案往前挪一点，方便阅读。
  * 重画荧幕 `Ctrl+l` 会以当前光标为中心，重画屏幕
* 删除
  * 删除光标后面的一个字符 `Ctrl+d` *(相当于Mac键盘下按`fn+delete`)*。
  * 删除光标前面的一个字符 `delete`。*(Windows下的`Backapace`=`Ctrl+h`,是help的意思)*
  * 删除光标后面的一个单词 `Esc+d`
  * 删除光标前面的一个单词 `Esc+delete`
  * (kill)删除至行尾 `Ctrl+k`
  * (kill)删除至句尾 `Esc+k` *(包含句号本身)*
  >kill掉的东西会被emacs放到一个叫kill ring中去,类似一个暂存的地方，之后可以用yank让他吐出来。
  
* 撤销 `Ctrl+x u`或者`Ctrl + -`