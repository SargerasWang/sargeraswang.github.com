---
layout: post
title: "第2章 Java内存区域与内存溢出异常"
date: 2014-01-28 14:31
comments: true
categories: 深入理解java虚拟机
images: [/images/blog_img/jvmbook.jpg]

---
>最近在学习周志明的《深入理解Java虚拟机》，写下学习笔记。  
[jvmbook]: {{page.images[0]}}
[![][jvmbook]](http://item.jd.com/11252778.html)

#运行时数据区
1. 线程共享
   1. 方法区（Method Area）
   2. （Java）堆（Heap）
2. 线程私有
   1. 虚拟机栈（VM Stack）
   2. 本地方法栈（Native Method Stack）
   3. 程序计数器（Program Counter Register）
   
   <!-- more -->
###方法区
* 方法区用于储存已被虚拟机加载的类信息、常量、静态变量、及时编译器编译后的代码等数据
* 虽然《规范》中方法区为堆的一个逻辑部分，但它却有一个别名叫做Non-Heap（非堆），目的应该是与Java堆区分开来。
* 当方法区无法满足内存分配需求时->OutOfMemoryError

####运行时常量池（Runtime Constant Pool）
* 运行时常量池用于存放编译期生成的各种字面量和符号引用，这部分内容将在类加载后进入方法区的运行时常量池中存放
* 既然运行时常量池是方法区的一部分，自然受到方法区内存的限制，当常量池无法再申请到内存时->OutOfMemoryError

###Java堆
* Java堆的唯一目的就是存放对象实例。
* 栈上分配、标量替换优化技术将会导致一些微妙的变化发生，所有的对象都分配在堆上也渐渐变得不是那么“绝对”了。
* Java堆是垃圾收集器管理的主要区域，因此很多时候也被称为“GC堆”（Grabage Collected Heap）
* 如果在堆中没有内存完成实例分配，并且堆也无法再扩展时->OutOfMemoryError

###虚拟机栈
* 虚拟机栈的生命周期与线程相同。
* 每个方法在执行的同时都会创建一个栈帧（方法运行时的基础数据结构）用于储存
  1. 局部变量表
  2. 操作数栈
  3. 动态链接
  4. 方法出口  
  等信息
* 通常，Java栈内存和堆内存，中的“栈”说的就是虚拟机栈，或者虚拟机栈中的局部变量表部分
* 局部变量表存放了编译期间可知的
  1. 各种基本数据类型（其中64位长度的long和double类型的数据会占用2个局部变量空间，其余数据类型只占用一个）
  2. 对象引用类型
     1. 指向对象起始地址的引用指针
     2. 指向一个代表对象的句柄或其他与此对象相关的位置
  3. returnAddress类型（指向了一条字节码指令的地址）
* 局部变量表所需的内存空间在编译期间完成分配。
* 在Java虚拟机规范中，对虚拟机栈规定了两种异常状况：
  1. 线程请求的栈深度大于虚拟机所允许的深度->StackOverflowError
  2. 扩展时无法申请到足够的内存->OutOfMemoryError

###本地方法栈
* **本地方法栈**与**虚拟机栈**的区别：
  * 虚拟机栈为虚拟机执行Java方法（也就是字节码）服务
  * 本地方法栈为虚拟机使用到的Native方法服务
* 与**虚拟机栈**一样，->StackOverflowError & OutOfMemoryError

###程序计数器
* 程序计数器可以看做是当前线程所执行的字节码的行号指示器。
* Java虚拟机的多线程是通过**线程轮流切换**并**分配处理器执行时间**的方式来实现的。
* 程序计数器是唯一一个在Java虚拟机规范中没有规定任何OutOfMemoryError情况的区域。

###直接内存（Direct Memory）
* 直接内存并不是虚拟机运行时数据区的一部分，也不是Java虚拟机规范中定义的内存区域。
* JDK1.4加入了NIO（New Input/Output），引入了基于通道与缓冲区的I/O方式，可以使用Native函数库直接分配堆外内存。
* 在配置虚拟机参数时，经常会忽略直接内存，使得各个内存区域总和大于物理内存限制（包括物理的和操作系统级的限制），从而导致动态扩展时->OutOfMemoryError

#HotSpot虚拟机对象探秘
###对象的创建
* 划分内存：
  * 堆中内存绝对规整：指针碰撞（切蛋糕）
  * 堆中内存并不规整：空闲列表（有列表记录哪里可用）
* 并发情况下划分内存的解决方案：
  * 对分配内存空间的动作进行同步处理，实际上虚拟机采用CAS配上失败重试的方式保证更新操作的原子性
  * 把内存分配动作按照线程划分在不同的空间之中进行，每个线程在Java堆中预先分配一小块内存，称为**本地线程分配缓冲**（Thred Local Allocation Buffer,TLAB）

###对象的内存布局
* 在HotSpot虚拟机中，对象在内存中存储的布局可以分为3块区域：对象头（Header）、实例数据（Instance Data）和对齐填充（Padding）。
* 对象头：
  * 用于存储对象自身的运行时数据。
  * 类型指针，即对象指向它的类元数据的指针
  * 如果对象是一个Java数组，在对象头中还必须有一块用于记录数组长度的数据。  
* 实例数据室对象真正存储的有效信息，也是程序代码中所定义的各种类型的字段内容
* 对齐填充并不是必然存在的，也没有特别的含义，起着**占位符**的作用，因为HotSpot要求对象起始位置必须是8字节的整倍数。

###对象的访问定位
* 主流的访问方式
  * 使用句柄：reference->实例数据指针->实例数据
                     ->类型数据指针->类型数据
  * 直接指针：reference->实例数据（包含类型数据指针）
                                   类型数据指针->类型数据
* 使用句柄来访问的最大好处是reference中存储的是稳定的句柄地址，在对象被移动时只会改变句柄中的实例数据指针，而reference本身不需要修改
* 使用直接指针最大好处就是速度更快，节省了一次指针定位的时间开销，HotSpot使用直接指针方式进行对象访问

#实战：OutOfMemoryError异常
* 将堆的最小值-Xms参数与最大值-Xmx参数设置为一样即可避免堆自动扩展
* 通过参数-XX:+HeapDumpOnOutOfMemoryError可以让虚拟机在出现内存溢出异常时Dump出当前的内存堆转储快照以便事后进行分析

###Java堆溢出

``` java
/**
 * VM Args: -Xms27M -Xmx27M -XX:+HeapDumpOnOutOfMemoryError
 */
public class HeapOOM {

    static class OOMObject {

    }

    public static void main(String[] args) {
        List<OOMObject> list = new ArrayList<HeapOOM.OOMObject>();
        while (true) {
            list.add(new OOMObject());
        }
    }
}
```
运行结果
```
java.lang.OutOfMemoryError: Java heap space
Dumping heap to java_pid1089.hprof ...
Heap dump file created [34195387 bytes in 0.288 secs]
```
其中`Java heap space`说明是Java堆内存溢出

* 内存泄露：进一步查看泄露对象与GC Roots的引用链
* 内存溢出：
  * 检查虚拟机的堆参数（Xmx Xms）与机器物理内存对比看是否还可以调大
  * 从代码上检查是否存在某些对象生命周期过长、持有状态时间过长的情况尝试减少程序运行期的内存消耗

###虚拟机栈和本地方法栈溢出

``` java
/**
 * VM Args: -Xss128k
 */
public class JavaVMStackSOF {

    private int stackLength = 1;

    public void stackLeak() {
        stackLength++;
        stackLeak();
    }

    public static void main(String[] args) throws Throwable {
        JavaVMStackSOF sof = new JavaVMStackSOF();
        try {
            sof.stackLeak();
        } catch (Throwable e) {
            System.out.println("stack length:" + sof.stackLength);
            throw e;
        }
    }

}
```
运行结果
```
stack length:401
Exception in thread "main" java.lang.StackOverflowError
	at io.github.sageraswang.test.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:14)
	at io.github.sageraswang.test.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:15)
	...
```
* 创建线程导致内存溢出异常，尝试失败，系统总是假死。

###方法区和运行时常量池溢出
``` java
/**
 * VM Args: -XX:PermSize=10M -XX:MaxPermSize=10M
 */
public class RuntimeConstantPoolOOM {

    public static void main(String[] args) {
        List<String> list = new ArrayList<String>();
        int i = 0;
        while (true) {
            list.add(String.valueOf(i++).intern());
        }
    }

}
```
运行结果
```
Exception in thread "main" java.lang.OutOfMemoryError: PermGen space
	at java.lang.String.intern(Native Method)
	at io.github.sageraswang.test.RuntimeConstantPoolOOM.main(RuntimeConstantPoolOOM.java:18)
```
其中`PermGen space`说明运行时常量池属于方法区（HotSpot虚拟机中的永久代）的一部分

####String.Intern()返回引用的测试

``` java
public class RuntimeConstantPoolOOM2 {

    public static void main(String[] args) {
        String str1 = new StringBuilder("计算机").append("软件").toString();
        System.out.println(str1.intern() == str1);

        String str2 = new StringBuilder("ja").append("va").toString();
        System.out.println(str2.intern() == str2);
    }

}
```
>JDK1.6执行结果为两个`false`,JDK1.7中执行结果为一个`true`一个`false`.
因为在JDK1.6中，intern()方法会把首次遇到的字符串实例复制到永久代中，返回的也是这个字符串实例的引用，而由StringBuilder创建的字符串实例在Java堆上，所以必然不是同一个引用
 
>而在JDK1.7中的intern()实现不会再复制实例，只是在常量池中记录首次出现的实例引用，因此intern()返回的引用和StringBuilder创建的那个字符串实例是同一个。对`str2`比较返回`false`是因为“java”这个字符串在执行`StringBuilder.toString()`之前已经出现过，字符串常量中已经出现它的引用了，不符合首次出现的原则。

####借助CGLib使方法区出现内存溢出异常

``` java
/**
 * VM Args: -XX:PermSize=10M -XX:MaxPermSize=10M
 */
public class JavaMethodAreaOOM {
    public static void main(String[] args) {
        while (true) {
            Enhancer enhancer = new Enhancer();
            enhancer.setSuperclass(OOMObject.class);
            enhancer.setUseCache(false);
            enhancer.setCallback(new MethodInterceptor() {

                @Override
                public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy)
                        throws Throwable {
                    return proxy.invoke(obj, args);
                }
            });
            enhancer.create();
        }
    }

    static class OOMObject {
    }
}
```
运行结果：
```
Exception in thread "main" net.sf.cglib.core.CodeGenerationException: java.lang.reflect.InvocationTargetException-->null
	at net.sf.cglib.core.AbstractClassGenerator.create(AbstractClassGenerator.java:237)
	at net.sf.cglib.proxy.Enhancer.createHelper(Enhancer.java:377)
	at net.sf.cglib.proxy.Enhancer.create(Enhancer.java:285)
	at io.github.sageraswang.test.JavaMethodAreaOOM.main(JavaMethodAreaOOM.java:29)
Caused by: java.lang.reflect.InvocationTargetException
	at sun.reflect.GeneratedMethodAccessor1.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:25)
	at java.lang.reflect.Method.invoke(Method.java:597)
	at net.sf.cglib.core.ReflectUtils.defineClass(ReflectUtils.java:384)
	at net.sf.cglib.core.AbstractClassGenerator.create(AbstractClassGenerator.java:219)
	... 3 more
Caused by: java.lang.OutOfMemoryError: PermGen space
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClassCond(ClassLoader.java:637)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:621)
	... 8 more
```
>**在经常动态生成大量Class的应用中，需要特别注意类的回收状况**

###本机直接内存溢出

``` java
import sun.misc.Unsafe;

/**
 * VM Args: -Xmx20M -XX:MaxDirectMemorySize=10M
 */
public class DirectMemoryOOM {

    private static final int _1MB = 1024 * 1024;

    public static void main(String[] args) throws Exception {
        Field unsafeField = Unsafe.class.getDeclaredFields()[0];
        unsafeField.setAccessible(true);
        Unsafe unsafe = (Unsafe) unsafeField.get(null);
        while (true) {
            unsafe.allocateMemory(_1MB);
        }
    }
}
```
<font color='red'>运行10分钟，没有出现异常，待解决。</font>

>由DirectMemory导致的内存溢出，Heap Dump 文件没有明显的异常