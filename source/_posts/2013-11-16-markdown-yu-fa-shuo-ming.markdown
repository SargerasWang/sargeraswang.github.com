---
layout: post
title: "Markdown 语法说明"
date: 2013-11-16 19:08
comments: true
categories: 
---
#区块元素
##段落和换行
通常的回车并不会换行，插入一个空行会产生一个空行。
强制换行可以使用 ```<br/>```

```
这是第一行
这是第二行 这并不会产生换行
```
效果如图<br/>
{% img /images/blog_img/brTag.png %}
##标题
一到六个```#```分别对应```H1~H6```
```
#H1
##H2
###H3
####H4
#####H5
######H6
```
效果如图<br/>
{% img /images/blog_img/H1H6.png %}

<!-- more -->
##区块引用
引经据典的时候在每行第一个字符使用```>```
```
>Learn basic keystroke commands
>Emacs Guided Tour	Overview of Emacs features at gnu.org
>View Emacs Manual	View the Emacs manual using Info
>
>Copying Conditions	Conditions for redistributing and >changing Emacs
>Ordering Manuals	Purchasing printed copies of manuals
```
效果如下：
>Learn basic keystroke commands
>Emacs Guided Tour	Overview of Emacs features at gnu.org
>View Emacs Manual	View the Emacs manual using Info
>
>Copying Conditions	Conditions for redistributing and >changing Emacs
>Ordering Manuals	Purchasing printed copies of manuals

MarkDown也允许只在段落的第一行最前面加上```>```
```
>Learn basic keystroke commands
Emacs Guided Tour	Overview of Emacs features at gnu.org
View Emacs Manual	View the Emacs manual using Info

>Copying Conditions	Conditions for redistributing and changing Emacs
Ordering Manuals	Purchasing printed copies of manuals
```
效果与上面一样。<br />
区块引用可以嵌套
```
>Learn basic keystroke commands
>
>>Emacs Guided Tour	Overview of Emacs features at gnu.org
>
>View Emacs Manual	View the Emacs manual using Info
```
效果如下：
>Learn basic keystroke commands
>
>>Emacs Guided Tour	Overview of Emacs features at gnu.org
>
>View Emacs Manual	View the Emacs manual using Info

引用的区块内也可以使用其他的MarkDown语法，包括标题、列表、代码区块等。
```
>##这是一个标题
>
>1. 这是第一行列表项
>2. 这是第二行列表项
>
>给出一些例子代码：
>
>	```public static void main()```
```
效果如下：
>##这是一个标题
>
>1. 这是第一行列表项
>2. 这是第二行列表项
>
>给出一些例子代码：
>
>	```public static void main()```

##列表
无序列表使用星号、加号或减号作为列表标记
```
* 红
* 绿
* 蓝
+ 红
+ 绿
+ 蓝
- 红
- 绿
- 蓝
```
效果如下：

* 红
* 绿
* 蓝
+ 红
+ 绿
+ 蓝
- 红
- 绿
- 蓝

有序列表使用数字加英文句点加空格
```
1. 加菲猫
2. 机器猫
3. 黑猫警长
```
效果如下：

1. 加菲猫
2. 机器猫
3. 黑猫警长

**注意：数字不会影响到结果**，就算你写成这样
```
1. 加菲猫
1. 机器猫
1. 黑猫警长
```
效果还是：

1. 加菲猫
1. 机器猫
1. 黑猫警长

**但最好还是按照顺序写，因为将来MarkDown可能会支持这种属性**

列表项目里也可以放入引用或代码块
```
* Learn basic keystroke commands
	> Emacs Guided Tour	Overview of Emacs features at gnu.org
* View Emacs Manual	View the Emacs manual using Info
* ```public static void main(String[] arg1)```
```
效果如下：

* Learn basic keystroke commands
	> Emacs Guided Tour	Overview of Emacs features at gnu.org
* View Emacs Manual	View the Emacs manual using Info
* ```public static void main(String[] arg1)```

当然，项目列表很可能无意中产生，比方说
```
1949. 中华人民共和国成立！
```
会变成

1949. 中华人民共和国成立！

所以需要在```.```前面加入```\```

```
1949\. 中华人民共和国成立！
```
就正常了：

1949\. 中华人民共和国成立！

##代码区块
用三个反引号表示代码区块

```
```这里写代码```
```
##分割线
在一行中用三个以上的星号、减号、底线来建立一个分割线，行内不能有其他东西，可以再星号或是减号中间插入空格。
```
***
---
___
* * *
-     - -
_ _       _
```
效果如下：

***
---
___
* * *
-     - -
_ _       _


#区段元素
##链接
MarkDown 支持两种形式的链接语法：**行内式**和**参考式**两种。

###行内式
```
这是一个[链接](http://www.google.com "Gooooooogle")的例子。
```
效果如：

这是一个[链接](http://www.google.com "Gooooooogle")的例子。

双引号中的文字是在鼠标悬浮在链接上时显示的。
###参考式
在链接的方括号后面再接一个方括号，里面写id，这个id可以再任何地方声明
```
[googleLink]: http://www.google.com "Gooooooogle"
这是一个[链接][googleLink]的例子。
```
效果如下：

[googleLink]: http://www.google.com "Gooooooogle"
这是一个[链接][googleLink]的例子。

id标签可以有字母、数字、空白和标点符号，但是忽略大小写。<br />
参考式的优点在于更容易后期修改，整篇文章的所有链接写在一起更容易管理。

**隐式链接**
允许第二个中括号中什么都不写，那认为第一个中括号中的文字就是ID。如下写法：
```
[链接]: http://www.google.com "Gooooooogle"
这是一个[链接][]的例子。
```
[链接]: http://www.google.com "Gooooooogle"
这是一个[链接][]的例子。

##强调
使用星号`*`或者底线`_`强调字词

* 一个表示倾斜，会转换成`<em>`
* 两个表示加粗，会转换成`<strong>`

```
*倾斜* _这样也能倾斜_
**加粗** __这样也能加粗__
```
效果如下：

*倾斜* _这样也能倾斜_
**加粗** __这样也能加粗__

##图片
也分**行内式**和**参考式**
```
行内式：
![描述](/images/blog_img/tenten.jpg "标题")
参考式：
![描述][tImg]
[tImg]: /images/blog_img/tenten.jpg "标题"
```
效果如下：

![描述](/images/blog_img/tenten.jpg "标题")
参考式：
![描述][tImg]
[tImg]: /images/blog_img/tenten.jpg "标题"

目前MarkDown不支持设置图片宽高，如果必须设置，请使用`<img>`标签。

##其它
###注脚
```
That's some text with a footnote.[^1]

[^1]: And that's the footnote.
```
效果要点这句话最后的小1：  
That's some text with a footnote.[^1]

[^1]: And that's the footnote.
###删除线
```
有些话说的影响和谐，就要~~~被删除~~~
```
效果如下：  
有些话说的影响和谐，就要~~~被删除~~~
###表格(在Octopress中并没有画出线，后续解决)
```
First Header | Second Header | Third Header
------------ | ------------- | ------------
Content Cell | Content Cell  | Content Cell
Content Cell | Content Cell  | Content Cell

| First Header | Second Header | Third Header |
| ------------ | ------------- | ------------ |
| Content Cell | Content Cell  | Content Cell |
| Content Cell | Content Cell  | Content Cell |

First Header | Second Header | Third Header
:----------- | :-----------: | -----------:
Left         | Center        | Right
Left         | Center        | Right
```
First Header | Second Header | Third Header
------------ | ------------- | ------------
Content Cell | Content Cell  | Content Cell
Content Cell | Content Cell  | Content Cell

| First Header | Second Header | Third Header |
| ------------ | ------------- | ------------ |
| Content Cell | Content Cell  | Content Cell |
| Content Cell | Content Cell  | Content Cell |

First Header | Second Header | Third Header
:----------- | :-----------: | -----------:
Left         | Center        | Right
Left         | Center        | Right
###自动连接
尖括号内会自动转换为链接
```
<http://www.google.com>
```
<http://www.google.com>
邮件链接也可以，并且MarkDown会转换为`mailto:地址`
```
<address@example.com>
```
效果如下：

{% img /images/blog_img/mailto.png %}

###Markdown免费编辑器
* Windows 平台
  * MarkdownPad
  * MarkPad
* Linux
  * ReText
* Mac
  * Mou
* 在线编辑器
  * Markable.in
  * Dillinger.io
* 浏览器插件
  * MaDe (Chrome)