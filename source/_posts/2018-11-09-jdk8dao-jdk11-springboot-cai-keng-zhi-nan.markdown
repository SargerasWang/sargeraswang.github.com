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
/images/blog_img/java8-java11/java9-mapof.png,
/images/blog_img/java8-java11/idea-switch-boot.png,
/images/blog_img/java8-java11/idea-switch-boot2.png,
/images/blog_img/java8-java11/want-die.jpg]
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
[idea-switch-boot]:{{page.images[10]}}
[idea-switch-boot2]:{{page.images[11]}}
[want-die]:{{page.images[12]}}

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
或者是`Fatal error compiling: 无效的标记: --release`

这个`Fatal error compiling: 无效的目标发行版: 11`坑的突破天际!

###别的问题:mybatis警告
* 如果你的项目使用了`mybatis`,那可能会在启动时看到如下日志

```
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.ibatis.reflection.Reflector (file:/.../org/mybatis/mybatis/3.4.6/mybatis-3.4.6.jar) to method java.lang.Integer.getChars(int,int,byte[])
WARNING: Please consider reporting this to the maintainers of org.apache.ibatis.reflection.Reflector
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
```
这个问题mybatis团队在修复了,`3.5.0`中应该能修复,但目前还没有release,所以暂时先忍着吧,详情见github答复:
[MyBatis and JDK 9: Illegal reflective access](https://github.com/mybatis/mybatis-3/issues/1156)

###别的问题:Unable to import maven project: See logs for details
当你对pom.xml 做修改保存,IDEA右下角会有提示 `Unable to import maven project: See logs for details`,提示让我们去看日志.

点击[Help]->[Show Log in Finder],可以看到错误信息如下:

```
2018-11-10 14:55:54,580 [58702502]   WARN - ution.rmi.RemoteProcessSupport - Unrecognized option: -d64 
2018-11-10 14:55:54,580 [58702502]   WARN - ution.rmi.RemoteProcessSupport - Error: Could not create the Java Virtual Machine. 
2018-11-10 14:55:54,580 [58702502]   WARN - ution.rmi.RemoteProcessSupport - Error: A fatal exception has occurred. Program will exit. 
2018-11-10 14:55:54,656 [58702578]   WARN - ution.rmi.RemoteProcessSupport - Unrecognized option: -d64 
2018-11-10 14:55:54,656 [58702578]   WARN - ution.rmi.RemoteProcessSupport - Error: Could not create the Java Virtual Machine. 
2018-11-10 14:55:54,656 [58702578]   WARN - ution.rmi.RemoteProcessSupport - Error: A fatal exception has occurred. Program will exit. 
2018-11-10 14:55:54,657 [58702579]  ERROR -      #org.jetbrains.idea.maven - Cannot reconnect. 
java.lang.RuntimeException: Cannot reconnect.
        at ...
Caused by: java.rmi.RemoteException: Cannot start maven service; nested exception is: 
        com.intellij.execution.ExecutionException: Unrecognized option: -d64
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.

        at ...
Caused by: com.intellij.execution.ExecutionException: Unrecognized option: -d64
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.

        at com.intellij.execution.rmi.RemoteProcessSupport.acquire(RemoteProcessSupport.java:159)
        at org.jetbrains.idea.maven.server.MavenServerManager.create(MavenServerManager.java:158)
        ... 37 more

```

关键是其中的 `com.intellij.execution.ExecutionException: Unrecognized option: -d64`,这是由于`-d64`在java10中已经被移除了.

#####下面关于这个问题的解决步骤,不要照着做,直接看最后的正确解决办法就好.
#####下面关于这个问题的解决步骤,不要照着做,直接看最后的正确解决办法就好.
#####下面关于这个问题的解决步骤,不要照着做,直接看最后的正确解决办法就好.

* 我们先修改IDEA使用java11.

修改方法:点击[Help]->[Find Action...]->输入[Switch],选中[Switch Boot JDK ...],选择jdk11,点击[Save and restart],如下图所示:

![][idea-switch-boot]

![][idea-switch-boot2]

重启完成,发现问题依旧,怀疑是这个`-d64`在项目中有配置,搜索后并没有发现.

* 试一下删除IDEA的缓存文件夹,目录在`~/Library/Caches/产品名称(比方说我的是IntelliJIdea2018.2)`,病情没有好转 .

* 删除掉配置信息:`rm -rf ~/Library/Preferences/IntelliJIdea*`

然后,奇迹发生了,重置之后的IDEA已经无法导入我的项目了,生无可恋...

![][want-die]

再仔细看下日志,发现后面几行:

```
2018-11-10 15:40:28,342 [  38826]  ERROR - llij.ide.plugins.PluginManager - IntelliJ IDEA 2018.2.5  Build #IU-182.4892.20
2018-11-10 15:40:28,342 [  38826]  ERROR - llij.ide.plugins.PluginManager - JDK: 1.8.0_152-release
2018-11-10 15:40:28,342 [  38826]  ERROR - llij.ide.plugins.PluginManager - VM: OpenJDK 64-Bit Server VM
2018-11-10 15:40:28,343 [  38827]  ERROR - llij.ide.plugins.PluginManager - Vendor: JetBrains s.r.o
2018-11-10 15:40:28,343 [  38827]  ERROR - llij.ide.plugins.PluginManager - OS: Mac OS X
2018-11-10 15:40:28,343 [  38827]  ERROR - llij.ide.plugins.PluginManager - Last Action:
```

* 好,按照官方所说,修改一下IDEA的启动jdk,在 `~/Library/Preferences/IntelliJIdea2018.2`下创建一个`idea.jdk`文件,内容是`/Library/Java/JavaVirtualMachines/jdk-11.0.1.jdk`

再启动加载项目试试,日志中虽然jdk版本是11了,可是依旧报错.绝望中,google到这么一个网页,里面也是同样的问题,答复是:

```
Hi.

It should be fixed in 2018.3:
```

What ? 2018.3目前还是EAP版本,下载一个试试吧
[https://www.jetbrains.com/idea/nextversion/](https://www.jetbrains.com/idea/nextversion/)

下载完成打开拖拽到`应用程序`,运行`IntelliJ IDEA 2018.3 EAP.app`,导入我的项目,惊喜来了,成功了!!!`JetBrains`诚不欺我!

###总结就是:解决
`com.intellij.execution.ExecutionException: Unrecognized option: -d64`
###办法就是使用`2018.3`及更新版本.

###完成
至此,坑已踩完,可以愉快的使用java11开发啦,比方说使用`Map.of`来快速的创建`Map`.

![][java9-mapof]
