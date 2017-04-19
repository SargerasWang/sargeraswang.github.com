---
layout: post
title: "Emacs使用手册(二) 使用进阶"
date: 2014-03-18 19:55
comments: true
categories: 
images: [/images/blog_img/benpao.jpg,
        /images/blog_img/emacs/c_x_c_l.png,
        /images/blog_img/emacs/subline.png,
        /images/blog_img/emacs/buffer.png,
        /images/blog_img/emacs/subWindow.png]
styles: [data-table]

---
[benpao]: {{page.images[0]}}
[cxcl]: {{page.images[1]}}
[subline]: {{page.images[2]}}
[buffer]: {{page.images[3]}}
[subWindow]: {{page.images[4]}}

![][benpao]
>一个多月没有写东西了，这期间发生了很多事，年初定的换工作的目标达成，收获颇丰。   
>“外面的世界很精彩...外面的世界很无奈...北京...北京...”  
>哈，没那么文艺，新的城市，新的公司，新的开始，我还是不够努力，奔跑吧！少年！
<!-- more -->
###被禁用的命令
有一些 Emacs 命令被“禁用”了，以避免初学者误用，当你使用到了一个被禁用的命令，Emacs 会显示一个提示消息，告诉你这个命令到底是干什么的，询问你是否要继续，并在得到你的肯定后再执行这命令。  

* 如果你确定要执行，就按下空格
* 如果你不想用，就按下“n”
> 试试 Ctrl+x Ctrl+l  
> ![][cxcl]

###窗格（WINDOWS）
Emacs 可以有多个窗格，每个窗格显示不同的文字。

* 关掉多余的窗格 `Ctrl+x 1`
* 切换为2个窗口：
  * 上下拆分`ctrl+x 2`
  * 左右拆分`ctrl+x 3`  
  ![][subWindow]
* 多窗口间切换光标 `ctrl+x o` **这里o代表other**
* 滚动另外一个画面 `alt+ctrl+v`
* 开启新窗口并打开指定文件 `ctrl+x 4 ctrl+f 文件名`
> 这个命令跟之前的命令不太一样，包含了两个字符，以Ctrl+x开始，有一系列命令都是以Ctrl+x开始的，许多都跟“窗格、文件、缓冲区”等有关，其中有些命令可能包含了2个、3个、4个字符。

###插入与删除
* 插入文字很简单，直接敲键盘就可以了。
* 删除前一个字符，用`Delete`，与 Emacs 之外的用法一样。
* 如果一行中文字显示不下，需要换行，那么：
  * 在console下会有反斜杠`\`出现
  * 在图形窗口中会有小小的转弯箭头出现
  ![][subline]
* 插入重复字符，插入八个星号`*`,`ctrl+u 8 *`
* 删除指定区域内的文字，在开始的地方按下`ctrl+@`,结束的地方按下`ctrl+w`.
* `ctrl+y`可以把上次连续kill掉的内容都吐出来
* 如果`ctrl+y`里面没有你要的，你想要的是在更早的时候kill掉的，那就按下`alt+y`,如果还不是，就继续`alt+y`直到吐出你想要的为止

###文件（FILE）
* 打开一个文件`ctrl+x ctrl+f`，输入一个不存在的文件名，就是 Emacs 创建文件的方式
* 储存这个文件`ctrl+x ctrl+s`,储存缓存区中的所有文件`ctrl+x s`.
> 第一次存盘的时候 Emacs 会将源文件重命名以备份，通常是在原文件名之后添加一个`~`
> 可以用这条命令关闭这个特性：`alt+x customize-variable <Return> make-backup-files <Return>】`
* Emacs 会自动保存，在原文件名两侧加“#”，如果想恢复为自动保存的文件，使用命令：`alt+x recover file`

###缓冲区（BUFFER）
* 打开新的文件后，想切换会原先的文件，还是执行`ctrl+x ctrl+f`，输入先前的文件名即可。
* 列出缓冲区 `ctrl+x ctrl+b`
  ![][buffer]
* `ctrl+x b`也可以用来切换缓冲区
* 并不是所有的缓冲区都对应一个文件，例如`*Messages*`里放着的都是 Emacs 底部出现的消息。

> ###命令集扩展
Emacs 扩展命令的两种风格：

按键 & 名称 | 解释 | 举例
------------ | ------------- | ------------
`ctrl+x`   字符扩展。   | `ctrl+x`之后输入另一个字符或者组合键。 | `ctrl+x ctrl+s`
`alt+x`  命令名扩展。  | `alt+x`之后输入一个命令名 | `alt+x help-with-tutorial`


> 在Console中，`ctrl+z`可以将Emacs暂时挂起，回到shell，再使用`fg`命令可以再切换回 Emacs。1

* 字符串替换命令：`alt+x replace-string` 两个参数分别用回车提交。比如要替换当前屏幕中所有“abc”为“def”，那应该执行`alt+x replace-string 回车 abc 回车 def`

###主/辅模式
状态栏括号中表示当前使用的主模式，使用`alt+x 模式名称`来切换主模式。
> 例如`alt+x text-mode`切换到Text模式
* 使用`ctrl+h m`可以查看当前主模式的文档
* 辅模式与子模式无关，与其他辅模式也无关
> 有一个叫做自动折行模式，可以再编辑自然语言文本的时候，打字超出一行边界时自动换行。  
> 默认的行边界是70个字符，可以通过`ctrl+u 字符数 ctrl+x f`来设置  
> 设定某段自动折行 `alt+q`

###搜索
Emacs 是渐进式搜索，在你输入的同时Emacs就开始搜索了
* `ctrl+s`向前搜索
* `ctrl+r`向后搜索
* 结束搜索：
  * 回车：光标停留在搜索到的位置
  * `ctrl+g`：光标停留在执行搜索之前的位置
  
###递归编辑 （没试出来效果。。。后续补上）

###使用帮助
* `ctrl+h 命令`可以查看对应命令的帮助，`ctrl+h ?`可以列出哪些命令有帮助。
* `ctrl+h c 按键`可以查看按键的说明。`ctrl+h k 按键`可以查看按键更详细的帮助
* `ctrl+h f 命令`可以查看命令的帮助
* `ctrl+h v 变量名`可以查看变量的文档。
* `ctrl+h a 命令`相关命令的搜索