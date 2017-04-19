---
layout: post
title: "在VPS上搭建tomcat+mysql"
date: 2015-02-16 13:54
comments: true
categories: 
images: [/images/blog_img/vps/success.png]

---
[success]:{{page.images[0]}}

>很久没有写blog了,从去年底开始一直在整一个框架,现在最最基础的东西好了.
>就想着给基友演示一下,看了一下国外的VPS,价格还可以接受,而且还可以增强linux的操作熟练度,就租了.
>这篇是写从租服务器开始直到可以通过[http://csm.sargeraswang.com](http://csm.sargeraswang.com)访问到我的站点.

###准备
1. 你自己的域名
2. 支持`VISA`或者`MasterCard`的信用卡
3. 你的网站程序
<!-- more -->
##开始
###1.购买VPS

对VPS的选购我是从[这里](http://www.vpsmm.com/)找的,具体我购买的是[peakservers](https://peakservers.com/)的配置[256MB/10GB/1core],价格15$/年.

购买的时候会让你选择系统,我选择的是`ubuntu14.04 64bit`.

购买之后,你可以看到分配给你的IP,root的密码.

###2.安装
打开终端,输入 `ssh root@服务器IP` 回车,输入密码,登陆成功.
####安装mysql

``` sh
apt-get update
apt-get install mysql-server
```

>输入mysql的root密码两次,安装完成

####安装tomcat

``` sh
apt-get install tomcat7
```

####安装emacs(可选)
由于我只会一点点emacs而不会使用vi,所以需要安装emacs,如果你用vi,可以忽略这步.后文中所有`emacs`请自行使用vi.

``` sh
apt-get install emacs
```

###3.配置
####关闭系统的Apache2服务
系统默认有apache2服务占用80端口,需要关闭:

```
service apache2 stop
```

####修改tomcat端口为80

``` sh
emacs /var/lib/tomcat7/conf/server.xml
```

找到这行

``` xml
<Connector port="8080" protocol="HTTP/1.1"                                                                                                           
               connectionTimeout="20000"                                                                                                               
               URIEncoding="UTF-8"                                                                                                                     
               redirectPort="8443" />
```

修改为

``` xml
<Connector port="80" protocol="HTTP/1.1"                                                                                                           
               connectionTimeout="20000"                                                                                                               
               URIEncoding="UTF-8"                                                                                                                     
               redirectPort="8443" />
```

`ctrl+x ctrl+s`保存,`ctrl+x ctrl+c`退出.

由于linux中1024以下端口只有root用户才有权限占用,而使用`apt-get`方式安装的Tomcat默认会新增一个用户使用.所以我们要修改启动Tomcat的用户为root.

``` sh
emacs /etc/default/tomcat7
```

找到这行

```
TOMCAT7_USER=tomcat7
```

修改为

```
TOMCAT7_USER=root
```

保存退出.

###4.上传数据库&程序
打开FileZilla,`主机`输入服务器IP,`用户名`输入`root`,`密码`输入你的root密码,`端口`输入`22`,点击`快速连接`.
####数据库备份与还原
* 备份本地的数据库

```
mysqldump -u root -p 数据库名称 > /某个目录/db.sql
```

* 上传到服务器

使用FileZilla,从左侧框体(就是你本机目录)中找到刚才的`db.sql`,在右侧框体(服务器目录)的根目录下新建一个文件夹用于存放上传的文件,我这里叫`download`.  
然后,将文件从左侧拖拽到右侧,等待上传完成.

* 从服务器上还原数据库

```
mysql -u root -p
```

输入你服务上mysql的root密码

``` sql
create database 数据库名称;
use 数据库名称;
source /download/db.sql
```

####程序打包上传
1. 将打包好的war包通过FileZilla上传到服务器.
2. 在服务器端:
    1. 复制war包到webapps目录  
    ```
    cp /download/WebManager.war /var/lib/tomcat7/webapps/
    ```
    2. 重启tomcat解压war  
    ```
    service tomcat7 restart
    ```
    3. 将程序移动到ROOT文件夹  
    ```
    rm -rf WebManager.war
    rm -rf ROOT
    mv WebManager ROOT
    ```
    4. 重启tomcat  
    ```
    service tomcat7 restart
    ```
3. 通过服务器ip访问测试服务是否正常

###5.域名绑定
登陆到你的域名解析界面,新增一条`A记录`,记录值为你的服务器IP,完成.

###完成
![][success]