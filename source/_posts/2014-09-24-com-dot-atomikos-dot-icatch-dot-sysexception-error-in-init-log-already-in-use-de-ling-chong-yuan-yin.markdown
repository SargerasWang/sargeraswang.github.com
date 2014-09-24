---
layout: post
title: "com.atomikos.icatch.SysException:Error in init(): Log already in use? 的另一种原因"
date: 2014-09-24 16:07
comments: true
categories: 
images: []

---
```
Error setting property values; nested exception is org.springframework.beans.PropertyBatchUpdateException;
nested PropertyAccessExceptions (1) are:
PropertyAccessException 1: org.springframework.beans.MethodInvocationException:
Property 'transactionTimeout' threw exception; nested exception is com.atomikos.icatch.SysException:
Error in init(): Log already in use?
	at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessPropertyValues(AutowiredAnnotationBeanPostProcessor.java:289)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1147)
	at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:519)

```

今天突然发生了这奇怪的事情,前两天服务器还很好,今天就抛出这个异常了.

首先,想起来同事曾经遇到过`Log already in use`的问题,是因为同一个项目启动了两次,检查服务器后发现就启动了一次,不是这个原因.**还有一个重点,我本机(MacBook)和同事的机器(windows)启动都没有这个问题,就服务器(linux)会有.**

<!--more-->

马上去Google,网上说法总结为两个原因:

1. 一个项目,已经启动了,再次启动的时候.
   * 解决办法:停止已启动的实例,再启动.
2. 同一个环境中存在多个这种使用jta的项目.
   * 解决办法:为每个项目配置使用不同的log文件,如下

jta.properties
``` properties
#项目一
com.atomikos.icatch.console_file_name = rm1.out
com.atomikos.icatch.log_base_name = rmlog1.log
```
jta.properties
``` properties
#项目二
com.atomikos.icatch.console_file_name = rm2.out
com.atomikos.icatch.log_base_name = rmlog2.log
```

但是,经过尝试,均无法解决问题.然后尝试搜索了一下`rmlog2.log`,结果发现在resin根目录下有.就去服务器看,结果没有.马上,脑洞大开,**会不会是因为权限??**

结果,"what f*ck",就是权限的问题.因为昨天同事吧resin目录的普通用户的写权限给禁用了.

###解决办法:配置log文件为绝对路径(要有权限)

jta.properties
``` properties
com.atomikos.icatch.service=com.atomikos.icatch.standalone.UserTransactionServiceFactory
com.atomikos.icatch.output_dir=/data/logs/xxx/
com.atomikos.icatch.log_base_dir=/data/logs/xxx/
com.atomikos.icatch.console_file_name = tm.out   
com.atomikos.icatch.log_base_name = tm.log    
com.atomikos.icatch.max_timeout = 300000
```