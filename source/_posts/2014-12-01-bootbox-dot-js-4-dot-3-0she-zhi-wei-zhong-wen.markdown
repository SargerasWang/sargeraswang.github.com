---
layout: post
title: "bootbox.js 4.3.0设置为中文"
date: 2014-12-01 09:06
comments: true
categories: 
images: []
---
bootbox.js 是bootstrap用的alert/confirm插件,支持多语言.中文设置方法:

``` js
bootbox.setDefaults({locale:"zh_CN"});
```

然后alert的确认按钮,还是显示为`OK`,直接去源码修改:
bootbox.js 最后位置

```
zh_CN : {
      OK      : "OK",//修改这里
      CANCEL  : "取消",
      CONFIRM : "确认"
    }
```