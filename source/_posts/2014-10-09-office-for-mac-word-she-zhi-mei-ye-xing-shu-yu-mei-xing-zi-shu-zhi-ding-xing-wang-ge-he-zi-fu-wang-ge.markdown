---
layout: post
title: "office for mac word 设置每页行数与每行字数(指定行网格和字符网格)"
date: 2014-10-09 09:35
comments: true
categories: 
images: [/images/blog_img/word_col_row.png,
        /images/blog_img/word_col.png,
        /images/blog_img/word_row.png]

---
[col_row]:{{page.images[0]}}
[col]:{{page.images[1]}}
[row]:{{page.images[2]}}

毕业论文要求格式之一是,每行30字,每页25行.查到windows下word中的设置在`文件`——`页面设置`——`在网格选择“指定行和字符网络”`,可mac版中没有这个选项,经过挨个排查,找到这项设置在`文件`->`页面设置`->`[设置]下拉选择[Microsoft Word]`->`页边距`->`文档网格`->`指定行网格和字符网格`,然后在下方输入每页多少行,每行多少字.

<!-- more -->
![][col_row]

使用后发现,明明设置每行30字,可实际总是在20字左右,行数也不对.测试后发现:

1. 每行字数不正确的,是由于在`字体...`中设置过`字符间距`,解决办法就是选中文字,点击`格式`->`字体...`->`高级`修改`间距`为`常规`,`位置`为`常规`.如下图:    
![][col]
2. 每页行数不正确的,是由于设置过`行间距`,解决办法是选中文字,点击`格式`->`段落...`->`间距`,`行距`设置为默认的`单倍行距`.如下图:    
![][row]

#####大功告成!