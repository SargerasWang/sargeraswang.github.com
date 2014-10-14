---
layout: post
title: "ER/Studio for mac 移植版制作教程与下载"
date: 2014-10-14 11:24
comments: true
categories: 
images: [/images/blog_img/erstudio/new.png,
        /images/blog_img/erstudio/wine1.png,
        /images/blog_img/erstudio/wine2.png,
        /images/blog_img/erstudio/alert1.png,
        /images/blog_img/erstudio/alert2.png,
        /images/blog_img/erstudio/alert3.png,
        /images/blog_img/erstudio/install1.png,
        /images/blog_img/erstudio/install2.png,
        /images/blog_img/erstudio/keygen.png]

---
[new]:{{page.images[0]}}
[wine1]:{{page.images[1]}}
[wine2]:{{page.images[2]}}
[alert1]:{{page.images[3]}}
[alert2]:{{page.images[4]}}
[alert3]:{{page.images[5]}}
[install1]:{{page.images[6]}}
[install2]:{{page.images[7]}}
[keygen]:{{page.images[8]}}

先上图:  
![][new]

###原理
使用[Wineskin](http://wineskin.urgesoftware.com/tiki-index.php)安装一个Windows的ER/Studio

###步骤
1. 下载wineskin,地址[http://wineskin.urgesoftware.com/tiki-index.php?page=Downloads](http://wineskin.urgesoftware.com/tiki-index.php?page=Downloads)
2. 运行wineskin,点击加号[+],新增一个engine,我用的是`WS9Wine 1.7.28`,点击[Download And Install].  
<!-- more -->
![][wine1]
![][wine2]  
3. 使用上一步安装的engine创建一个应用,点击`Create New Blank Wrapper`,输入一个名字,比方说`"ERStudio"`,**注意不要用`"ER/Studio"`,貌似斜杠会影响文件的创建**.,创建好后会弹出一个提示,问是否要安装`.NET`,点取消,又一个提示是否安装`HTML`,也取消,再稍等一下.会告诉你创建完成了,然后点击`View wrapper in Finder`.  
![][alert1]
![][alert2]
![][alert3]  
4. 右键xxxx.app->显示包内容,运行`Wineskin.app`.点击`Install Software`->`Choose Setup Executable`,选择ER/Studio的EXE安装程序([下载地址](http://pan.baidu.com/wap/shareview?&shareid=1817104890&uk=2336093466&dir=%2F%E5%88%86%E4%BA%AB%2Fsoftwave%2FERStudio8&page=1&num=20&fsid=4244204594&third=4)),下一步..下一步..下一步......安装完成.  
![][install1]
![][install2]  
5. 下载破解文件([下载地址](http://pan.baidu.com/wap/shareview?&shareid=1817104890&uk=2336093466&dir=%2F%E5%88%86%E4%BA%AB%2Fsoftwave%2FERStudio8&page=1&num=20&fsid=1394660492&third=4)),把解压出来的破解工具`3ddown.com_patch_setup.exe`放在ER/Studio的安装目录下`ERStudio.app/Contents/Resources/drive_c/Program Files/Embarcadero/ERStudio8.0/3ddown.com_patch_setup.exe`.然后到上层找到`Wineskin`运行,选择`Advanced`,在`Windows EXE`选择刚才的`3ddown.com_patch_setup.exe`文件.点击`Test Run`,运行破解.
![][keygen]  
6. 还是在上一步的`Windows EXE`,选择ER/Studio的运行文件`/Program Files/Embarcadero/ERStudio8.0/ERSTUDIO.exe`.测试一下是否可以运行,点击`Test Run`.  
7. 修改图标,我从`ERSTUDIO.exe`里提取出来的icon.[下载地址]({{site.url}}/images/blog_img/erstudio/icon.icns),替换上即可.

###使用须知
~~由于这种方式的原理是虚拟了一个windows环境,所以这个应用无法读取到应用之外的文件,想要打开ER图,可以把图放在`ERStudio.app/Contents/Resources/drive_c/`下面,例如我们ER图放在SVN上,直接把ER图的文件夹CheckOut到这里.~~

应用第一次启动,会在你的`文稿`目录中创建一个`ERStudio8.0`文件夹,把ER图放这里就好,其实应用可以访问到整个`文稿`文件夹.
###完整版下载
百度云下载:[http://yun.baidu.com/share/link?shareid=1037072841&uk=1309001135](http://yun.baidu.com/share/link?shareid=1037072841&uk=1309001135)