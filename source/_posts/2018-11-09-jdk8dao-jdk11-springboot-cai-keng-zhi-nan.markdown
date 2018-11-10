---
layout: post
title: "jdk8到jdk11 springboot 踩坑指南"
date: 2018-11-10 00:16
comments: true
categories: 
images: [/images/blog_img/java8-java11/mvn-v.right.png,
/images/blog_img/java8-java11/idea-setting-1.png,
/images/blog_img/java8-java11/idea-setting-2.png,
/images/blog_img/java8-java11/idea-setting-3.png,
/images/blog_img/java8-java11/idea-setting-4.png,
/images/blog_img/java8-java11/idea-setting-5.png,
/images/blog_img/java8-java11/idea-setting-6.png,
/images/blog_img/java8-java11/idea-setting-7.png,
/images/blog_img/java8-java11/idea-setting-8.png,
/images/blog_img/java8-java11/java9-mapof.png]
---
[mvn-v]:{{page.images[0]}}
[idea-setting-1]:{{page.images[1]}}
[idea-setting-2]:{{page.images[2]}}
[idea-setting-3]:{{page.images[3]}}
[idea-setting-4]:{{page.images[4]}}
[idea-setting-5]:{{page.images[5]}}
[idea-setting-6]:{{page.images[6]}}
[idea-setting-7]:{{page.images[7]}}
[idea-setting-8]:{{page.images[8]}}
[java9-mapof]:{{page.images[9]}}

由于打算在项目中使用一些 java9 的特性,而 oracle 官方是从 java8 直接就到 java11 ,所以决定直接升级到java11.

<!--more-->

整个过程**最关键的是注意当前环境变量**,下面开始:

###下载jdk11
* 去`oracle`官网下载对应你系统的jdk,这个页面:

[https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html](https://www.oracle.com/technetwork/java/javase/downloads/jdk11-downloads-5066655.html)

* 安装之后,修改环境变量`JAVA_HOME`
* 确保执行`java -version`看到的版本是11 --这里很重要

###下载安装3.5.0以上的maven
* 去`maven`官网下载最新的3.6.0版本,这个页面:

[https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)

* 解压到合适的目录后,修改环境变量`MAVEN_HOME`
* 确保执行`mvn -v`看到的是`maven 3.6.0`并且 `java 11`  --这里很重要
* 如下截图:

![][mvn-v]

* 只要maven或者java版本显示不正确,就考虑环境变量生效的问题,例如我的MAC,我改了`~/.bash_profile`但是很奇怪不生效,才想起来自己用的是`zsh`,又去改了`~/.zshrc`才生效,改完记得用`source`命令才可以立即生效
* 实在无解就重启下试试

###修改pom.xml
* `spring boot parent`版本更新到 `2.1.0`

``` xml
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
```


* `java.version`修改为11

``` xml
<properties>
	...
	<java.version>11</java.version>
</properties>
```

只要改这两处就ok了,不用看别的教程里还需要增加或修改`<plugins>`内容,这坑我已经踩过了,不需要的.

###阶段性尝试

* 前面步骤做完,到目前,在终端下,应该已经可以正常打包了
* `cd`到项目目录下,执行`mvn clean package`试试看
* 没有报错就ok了,继续往下进行IDE的配置

###IntelliJ IDEA 的配置

这里才是巨坑的.

* 在项目根目录上右键,选择`Open Module Settings`
* 需要配置`jdk`的地方如下几张截图

![][idea-setting-1]

![][idea-setting-2]

![][idea-setting-3]

![][idea-setting-4]

如果有漏配呢,就会有类似这样的输出:

```
Error:java:无效的源发行版:11
```
如下图:

![][idea-setting-5]

* 配置好之后点击`OK`关闭,然后按下`command+,`打开`Preferences`界面,左侧搜索输入`maven`,需要配置的地方如下几张截图

![][idea-setting-6]

![][idea-setting-7]

![][idea-setting-8]

如果有漏配呢,就会有类似这样的输出:

```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.7.0:compile (default-compile) on project xxx: Fatal error compiling: 无效的目标发行版: 11 -> [Help 1]
```
这个`Fatal error compiling: 无效的目标发行版: 11`坑的突破天际!

###别的问题
如果你的项目使用了`mybatis`,那可能会在启动时看到如下日志

```
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.ibatis.reflection.Reflector (file:/.../org/mybatis/mybatis/3.4.6/mybatis-3.4.6.jar) to method java.lang.Integer.getChars(int,int,byte[])
WARNING: Please consider reporting this to the maintainers of org.apache.ibatis.reflection.Reflector
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
```
这个问题mybatis团队在修复了,`3.5.0`中应该能修复,但目前还没有release,所以暂时先忍着吧,详情见github答复:
[MyBatis and JDK 9: Illegal reflective access](https://github.com/mybatis/mybatis-3/issues/1156)

###完成
至此,坑已踩完,可以愉快的使用java11开发啦,比方说使用`Map.of`来快速的创建`Map`.

![][java9-mapof]
