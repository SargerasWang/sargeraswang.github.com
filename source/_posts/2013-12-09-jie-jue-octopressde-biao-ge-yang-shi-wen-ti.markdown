---
layout: post
title: "解决Octopress的表格样式问题"
date: 2013-12-09 21:42
comments: true
categories: 
styles: [data-table]
---
>在[10篇vs19天博客撰写小结]({{site.url}}/blog/2013/11/29/10pian-vs19tian-bo-ke-zhuan-xie-xiao-jie/)中,一个待解决的问题：表格(在Octopress中并没有画出线，后续解决)

Google到[为Octopress追加数据表格的CSS](http://programus.github.io/blog/2012/03/07/add-table-data-css-for-octopress/)这篇，照着做就好了。

<!-- more -->

###创建`source/stylesheets/data-table.css`,内容如下

``` css
* + table {
  border-style:solid;
  border-width:1px;
  border-color:#e7e3e7;
}
 
* + table th, * + table td {
  border-style:dashed;
  border-width:1px;
  border-color:#e7e3e7;
  padding-left: 3px;
  padding-right: 3px;
}
 
* + table th {
  border-style:solid;
  font-weight:bold;
  background: url("/images/noise.png?1330434582") repeat scroll left top #F7F3F7;
}
 
* + table th[align="left"], * + table td[align="left"] {
  text-align:left;
}
 
* + table th[align="right"], * + table td[align="right"] {
  text-align:right;
}
 
* + table th[align="center"], * + table td[align="center"] {
  text-align:center;
}
```

###在`source/_includes/head.html`中，找到引用`screen.css`的地方，添加下面的代码  
{% raw %}
``` html
  <link href="{{ root_url }}/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css">
  {% if page.styles contains 'data-table' %}
  <link href="{{ root_url }}/stylesheets/data-table.css" media="screen, projection" rel="stylesheet" type="text/css" />
  {% endif %}
```
{% endraw %}

###在需要用到表格的博客文件中，的[frontmatter](http://jekyllrb.com/docs/frontmatter/)位置，添加
```
styles: [data-table]
```

###ok，问题解决，效果如下：

左对齐表头 | 中间对齐表头 | 右对齐表头
:----------|:------------:|----------:
左对齐数据 |中间对齐数据  |右对齐数据
第二行数据 |也是第二行    |还是第二行
懒得写了...|.....         |.....
长数据，以便看出表头的对齐|长数据，以便看出表头的对齐|长数据，以便看出表头的对齐


###感谢原作者[程序猎人的博客](http://programus.github.io/blog/2012/03/07/add-table-data-css-for-octopress/)的分享