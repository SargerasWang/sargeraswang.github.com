---
layout: post
title: "SseEmitter DefaultHandlerExceptionResolver : Async timeout for GET 解决"
date: 2017-04-20 15:05
updated: 2017-04-20 15:05
comments: true
categories: 
images: []
---

使用`SpringMVC`搭配HTML5的`EventSource`之`SseEmitter`如下:

``` java
@RequestMapping("connect")
public SseEmitter connect(){
    SseEmitter emitter = new SseEmitter();    
    return emitter;
}
```

这样会抛出如下异常:

```
DefaultHandlerExceptionResolver : Async timeout for GET
```

原因是请求到timeout时间就会超时,`new SseEmitter(long timeout);`是可以设置timeout的,单位是毫秒,但是设置为60000L(一分钟),也是一样的,每分钟都会抛出这个异常.

最后解决办法,timeout永不过时,timeout设置为0,如下:

``` java
@RequestMapping("connect")
public SseEmitter connect(){
    SseEmitter emitter = new SseEmitter(0L);    
    return emitter;
}
```

就不会抛出异常了,前端用类似如下代码即可:

``` js
    var eventSource = new EventSource("/sse/connect");
    eventSource.onmessage = function(event){
        //event.data 是数据
    }
    eventSource.onerror = function(err){
        if(err.target.readyState == 0){
            //消息服务异常,无法创建连接
        }if(err.target.readyState == 2){
            //消息服务断开,无法及时收到消息
        }
    }
```