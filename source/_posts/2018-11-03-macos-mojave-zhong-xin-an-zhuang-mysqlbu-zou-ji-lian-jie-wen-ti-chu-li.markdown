---
layout: post
title: "MacOS Mojave 重新安装mysql步骤及连接问题处理"
date: 2018-11-03 15:35
comments: true
categories: 
images: [/images/blog_img/mysql/success.png]
---
[success]:{{page.images[0]}}

###卸载并清理原有mysql
1.数据备份,具体请查看[mysqldump 的使用](https://www.jianshu.com/p/0a82d115d54d),如果不需要备份,直接到下一步
<!-- more -->
2.查看当前系统是否有`mysql`进程:

``` sh
ps -ax|grep mysql
```
3.如果有,`kill`掉

4.使用`HomeBrew`删除

``` sh
brew remove mysql
brew cleanup
```
5.删除文件:

``` sh
sudo rm /usr/local/mysql
sudo rm -rf /usr/local/var/mysql
sudo rm -rf /usr/local/mysql*
sudo rm ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
sudo rm -rf /Library/StartupItems/MySQLCOM
sudo rm -rf /Library/PreferencePanes/My*
```
6.取消MySQL自动启动:

``` sh
launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
7.删除MySQL的设置:

``` sh
subl /etc/hostconfig 
# 删除这一行 MYSQLCOM=-YES-
```
8.删除MySQL的首选项:

``` sh
rm -rf ~/Library/PreferencePanes/My*
sudo rm -rf /Library/Receipts/mysql*
sudo rm -rf /Library/Receipts/MySQL*
sudo rm -rf /private/var/db/receipts/*mysql*
```
9.重新启动Mac

###下载并安装新mysql
1.[MySQL官网](https://www.mysql.com/cn/) -> 下载 -> 选择最下面的社区版本(MySQL Community Edition) -> 点第一个 MySQL Community Server (GPL) -> 选择DMG安装下载 (
macOS 10.14 (x86, 64-bit), DMG Archive)
> 最终的下载地址是 [https://dev.mysql.com/downloads/file/?id=480768](https://dev.mysql.com/downloads/file/?id=480768)

2.打开DMG,运行安装包,通常都是选择下一步,有一部会问你是使用8.0新版的更强健的安全的方式,还是兼容5.0,我们选择下面的兼容5.0

3.提示输入root密码两次,要记住这里的密码哦

4.安装完成

5.安装程序默认不会添加mysql命令到终端,所以需要自己配置:

1. 打开`/.bash_profile`文件
2. 添加一行 `export PATH=$PATH:/usr/local/mysql/bin`
3. 保存
4. 执行 `source ~/.bash_profile`

6.尝试连接mysql服务,运行 `mysql -uroot -p`回车

7.输入安装时设置的root密码

8.连接成功,并且控制台会打印出mysql版本 `Server version: 8.0.13 MySQL Community Server - GPL`

###尝试使用数据库工具连接
1.使用 DbVisualizer 添加新的 connection
2.像往常一样 `Driver`选择了`MySQL`
3.点击`Ping Server` 提示正常
4.点击`Connect`则无法连接显示如下:

```
An error occurred while establishing the connection:

Long Message:
Could not create connection to database server.

Details:
   Type: com.mysql.jdbc.exceptions.jdbc4.MySQLNonTransientConnectionException
   SQL State: 08001
```

###解决办法
1.原因是新安装的MySQL服务版本过高,老版本jdbc驱动无法连接.

2.解决方式当然有两个:A.退回低版本服务;B.使用高版本驱动

3.我们尝试使用新版本驱动,在选择`Driver`处,下来选择`MySQL(DataDirect)`这一项,会弹出让你选择文件

4.去下载最新的驱动文件,例如这里:[http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.13/mysql-connector-java-8.0.13.jar](http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.13/mysql-connector-java-8.0.13.jar)

5.`Driver`选择刚才下载的这个jar文件,再次尝试`Connect`

6.提示错误信息如下:

```
An error occurred while establishing the connection:
The selected Driver cannot handle the specified Database URL.
The most common reason for this error is that the database URL
contains a syntax error preventing the driver from accepting it.
The error also occurs when trying to connect to a database
with the wrong driver. Correct this and try again.
```

7.在`Settings Format`处,选择`Database URL`

8.`Database URL`填入`jdbc:mysql://localhost:3306`

9.再次尝试`Connect`,成功!

截图如下:

![][success]