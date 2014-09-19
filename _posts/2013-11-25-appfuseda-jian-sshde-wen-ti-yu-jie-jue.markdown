---
layout: post
title: "Appfuse搭建SSH的问题与解决"
date: 2013-11-25 20:14
comments: true
categories: 
---
* Plugin execution not covered by lifecycle configuration: org.codehaus.mojo:dbunit-maven-plugin:1.0-beta-3:operation (execution: test-compile, phase: test-compile)
  * 解决方法：在`<plugins>`外面套上`<pluginManagement>`
  
``` xml
<pluginManagement>
	<plugins>
		<plugin></plugin>
		...
	</plugins>
</pluginManagement>
```

<!-- more -->

* Can not find the tag library descriptor for "http://java.sun.com/jsp/jstl/core"
* Can not find the tag library descriptor for "http://java.sun.com/jsp/jstl/fmt"
* Can not find the tag library descriptor for "http://java.sun.com/jsp/jstl/functions"
  * 解决方法：添加jstl依赖
``` xml
<dependency>
	<groupId>jstl</groupId>
	<artifactId>jstl</artifactId>
	<version>1.2</version>
	</dependency>
<dependency>
	<groupId>taglibs</groupId>
	<artifactId>standard</artifactId>
	<version>1.1.2</version>
</dependency>
```
遇到的其他问题基本都是因为网络问题，jar包下载失败，重新下载就好了。
附上我配置成功的项目。  
[下载myproject.zip]({{site.url}}/images/code/myproject.zip)