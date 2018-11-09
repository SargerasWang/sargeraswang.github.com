---
layout: post
title: "java 链式调用的正确姿势"
date: 2018-11-09 16:43
comments: true
categories: 
images: []
---

Google 上搜索"java链式调用"前两名的大哥用的例子是一样的,并且不正确.

他们代码中`build`出来的并不是`Student`,而是一个`Builder`.

这里的链式调用(链式编程),是设计模式中的`Builder模式`,要点就是通过一个代理来完成对象的构建过程。这个代理职责就是完成构建的各个步骤，同时它也是易扩展的。

如下类似代码:

``` java
public class Response {
    private final Integer status;
    private final String message;
    private final Object result;

    public Response(Builder builder) {
        this.status=builder.status;
        this.message=builder.message;
        this.result=builder.result;
    }

    public static class Builder{
        private Integer status;
        private String message;
        private Object result;

        public Response build(){
            return new Response(this);
        }
        public Builder withStatus(Integer status){
            this.status=status;
            return this;
        }
        public Builder withMessage(String message){
            this.message = message;
            return this;
        }
        public Object withResult(String result){
            this.result = result;
            return this;
        }
    }
}
```

调用时如下方式:

``` java
Response response = new Response.Builder()
	.withStatus(1)
	.withMessage("请求成功")
	.withResult(XXX)
	.build();
```
