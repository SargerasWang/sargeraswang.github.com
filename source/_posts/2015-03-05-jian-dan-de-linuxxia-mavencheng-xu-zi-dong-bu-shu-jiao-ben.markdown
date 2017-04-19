---
layout: post
title: "简单的linux下maven程序自动部署脚本"
date: 2015-03-05 16:19
comments: true
categories: 
images: []

---
>vps服务器弄好之后,每次更改完代码都是本地打包,上传war到服务器,再替换数据库配置,重启服务.
>刚开始偶尔一次还好,但频繁操作就受不了了,然后写了以下脚本.

##部署流程
####1.从github更新
``` sh
git pull
```

####2.替换数据库配置
``` sh
cp -f ../db_config/db.properties ./src/main/resources/props/db.properties
```

修改log4j配置文件的第一行,服务器端有mail,本机没有

``` sh
sed -i '1c log4j.rootLogger=INFO,stdout,stderr,mail' ./src/main/resources/log4j.properties
```

####3.打包
``` sh
mvn package
```

####4.停止tomcat
``` sh
service tomcat stop
```

####5.删除原文件夹
``` sh
rm -rf /var/lib/tomcat7/webapps/ROOT
```

####6.改名+复制包到tomcat
``` sh
mv target/WebManager.war target/ROOT.war
cp -f target/ROOT.war /var/lib/tomcat7/webapps/
```
####7.启动tomcat
``` sh
service tomcat7 start
```    

###shell:

``` sh
#!/bin/sh                                                                                                                                   
echo "==============================开始部署=============================="
cd /usr/local/project/csm-framework/
echo "##############################更新git##############################"
git pull
echo "########################替换数据库配置#############################"
cp -f ../db_config/db.properties ./src/main/resources/props/db.properties 
echo "########################修改Log4j配置#############################"
sed -i '1c log4j.rootLogger=INFO,stdout,stderr,mail' ./src/main/resources/log4j.properties
echo "############################打包###################################"
mvn clean package
echo "#########################停止tomcat################################"
service tomcat7 stop
echo "##########################删除原文件夹#############################"
rm -rf /var/lib/tomcat7/webapps/*
echo "##########################解压到webapps############################"
unzip -o target/WebManager.war -d /var/lib/tomcat7/webapps/ROOT/
echo "############################启动tomcat#############################"
service tomcat7 start
echo "==============================部署完成=============================="
```