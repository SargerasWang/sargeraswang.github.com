---
layout: post
title: "netty org.msgpack.MessageTypeException: Expected array but got not array value"
date: 2017-04-19 17:07
comments: true
categories: 
images: []
---

在使用Netty时,client给server发送消息,突然大量并发请求发送消息,抛出以下异常

```
org.msgpack.MessageTypeException: Expected array but got not array value
    at org.msgpack.unpacker.Converter.readArrayBegin(Converter.java:202) ~[msgpack-0.6.12.jar:na]
```

看起来是`msgpack`的问题,debug发现如果单步debug,就没有问题,并发时才会出现,google以上内容并没有解决问题.

最后找到原因,是因为没有解决`粘包拆包`,解决方法如下:

``` java
socketChannel.pipeline()
        .addLast("frameDecoder",new LengthFieldBasedFrameDecoder(1024,0,2,0,2))  //
        .addLast("msgpack decoder",new MsgpackDecoder())
        .addLast("frameEncoder",new LengthFieldPrepender(2))  //
        .addLast("msgpack encoder",new MsgpackEncoder())
        .addLast(serverHandler);
```

主要是上面的`.addLast("msgpack decoder",new MsgpackDecoder())`和`.addLast("msgpack encoder",new MsgpackEncoder())`.

问题解决.