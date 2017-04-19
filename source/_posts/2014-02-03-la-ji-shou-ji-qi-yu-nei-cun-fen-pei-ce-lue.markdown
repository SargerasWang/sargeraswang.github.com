---
layout: post
title: "第3章 垃圾收集器与内存分配策略"
date: 2014-02-03 16:40
comments: true
categories: 深入理解java虚拟机
images: [/images/blog_img/jvmbook.jpg]

---
[jvmbook]: {{page.images[0]}}

###对象已死吗

####引用计数算法
>给对象添加引用计数器，每当有一个地方引用它时，计数器值就加1；当引用失效时，计数器值就减1；任何时刻计数器为0的对象就是不可能再被使用的。

>它很难解决对象之间互相循环引用的问题。

<!-- more -->

[![][jvmbook]](http://item.jd.com/11252778.html)

``` java
/**
 * VM Args: -XX:+PrintGCDetails
 */
public class ReferenceCountingGC {

    public Object instance = null;
    private static final int _1MB = 1024 * 1024;

    /*
     * 这个成员属性的唯一意义就是占点内存，以便能在GC日志中看清楚否被回收过
     */
    private byte[] bigSize = new byte[2 * _1MB];

    public static void testGC() {
        ReferenceCountingGC objA = new ReferenceCountingGC();
        ReferenceCountingGC objB = new ReferenceCountingGC();
        objA.instance = objB;
        objB.instance = objA;

        objA = null;
        objB = null;

        // 假设在这行发生GC，objA和objB是否能被回收？
        System.gc();
    }

    public static void main(String[] args) {
        testGC();
    }

}
```
输入日志：
```
[Full GC (System) [CMS: 0K->330K(63872K), 0.0114563 secs] 5462K->330K(83008K), [CMS Perm : 4629K->4628K(21248K)], 0.0115589 secs] [Times: user=0.02 sys=0.00, real=0.01 secs] 
Heap
 par new generation   total 19136K, used 1021K [7f3000000, 7f44c0000, 7f44c0000)
  eden space 17024K,   6% used [7f3000000, 7f30ff658, 7f40a0000)
  from space 2112K,   0% used [7f40a0000, 7f40a0000, 7f42b0000)
  to   space 2112K,   0% used [7f42b0000, 7f42b0000, 7f44c0000)
 concurrent mark-sweep generation total 63872K, used 330K [7f44c0000, 7f8320000, 7fae00000)
 concurrent-mark-sweep perm gen total 21248K, used 4689K [7fae00000, 7fc2c0000, 800000000)
```
>其中`5462K->330K`说明虚拟机并没有因为这两个对象互相引用就不回收他们，这也从侧面说明虚拟机并不通过引用计数算法来判断对象是否存活的。

####可达性分析算法
* 主流商用程序语言都是通过**可达性分析(Reachability Analysis)**来判定对象是否存活的。
* 通过一系列称为`GC Roots`的对象作为起始点，从这些节点开始向下搜索，搜索所走过的路径称为引用链，当一个对象到GC Roots没有任何引用链相连时，则证明此对象是不可用的。
* Java语言中的GC Roots：
  * 虚拟机栈（栈帧中的本地变量表）中引用的对象
  * 方法区中类静态属性引用的对象。
  * 方法区中常量引用的对象。
  * 本地方法栈中JNI（即一般说的Native方法）引用的对象。
  
####引用的分类
* JDK1.2之后，Java对引用的概念进行了扩充
  * 强引用（Strong Reference）：在程序代码之中普遍存在的 `Object obj = new Object()`，只要强引用还存在，垃圾收集器永远不会回收掉被引用的对象。
  * 软引用（Soft Reference）：有用但并非必需的对象，**在系统将要发生内存溢出异常之前，将会把这些对象列进回收范围之中进行第二次回收**，使用`SoftReference`类来实现软引用。
  * 弱引用（Weak Reference）：非必须对象，**只能生存到下一次垃圾收集发生之前**，使用`WeakReference`类来实现弱引用。
  * 虚引用（Phantom Reference）：也称*幽灵引用*或者*幻影引用*，**为一个对象设置虚引用关联的唯一目的就是能在这个对象被收集器回收时收到一个系统通知,在JDK1.2之后，使用`PhantomReference`类来实现虚引用。
  
####生存还是死亡
* 要真正宣告一个对象死亡，至少要经历两次标记过程：
  * 可达性分析后，没有与GC Roots相连接的引用链，将会被第一次标记并进行一次筛选，当对象没有覆盖`finalize()`方法或者`finalize()`方法已经被虚拟机调用过，都没有必要执行`finalize()`方法。
  * 有必要执行`finalize()`方法的对象会被放在`F-Queue`队列中，稍后由一个由一个虚拟机自动建立的Finalizer线程去执行它，`finalize()`方法是对象逃脱死亡命运的最后一次机会，

* 一次对象自我拯救的演示

``` java
public class FinalizeEscapeGC {

    public static FinalizeEscapeGC SAVE_HOOK = null;

    public void isAlive() {
        System.out.println("yes,i am still alive :)");
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        System.out.println("finalize method executed!");
        FinalizeEscapeGC.SAVE_HOOK = this;
    }

    public static void main(String[] args) throws Exception {
        SAVE_HOOK = new FinalizeEscapeGC();

        // 对象第一次成功拯救自己
        SAVE_HOOK = null;
        System.gc();
        // 因为finalize方法优先级很低，所以暂停0.5秒以等待它
        Thread.sleep(500);
        if (SAVE_HOOK != null) {
            SAVE_HOOK.isAlive();
        } else {
            System.out.println("no,i am dead :(");
        }

        // 下面这段代码与上面的完全相同，但是这次自救却失败了
        SAVE_HOOK = null;
        System.gc();
        Thread.sleep(500);
        if (SAVE_HOOK != null) {
            SAVE_HOOK.isAlive();
        } else {
            System.out.println("no,i am dead :(");
        }

    }

}
```
执行结果：
```
finalize method executed!
yes,i am still alive :)
no,i am dead :(
```
**对象自救的机会只有一次，因为一个对象的finalize（）方法最多只会被系统自动调用一次**
>`finalize()`方法只是Java刚诞生时为了使C/C++程序员更容易接受它所作出的一个妥协，运行代价高昂，不确定性大，无法保证各个对象的调用顺序，应尽量避免使用。

####回收方法区
要判定一个类是否是“无用的类”的条件，需要同时满足下面3个条件：

1. 该类所有的实例都已经被回收，也就是Java堆中不存在该类的任何实例。
2. 加载该类的ClassLoader已经被回收
3. 该类对应的java.lang.Class对象没有在任何地方被引用，无法在任何地方通过反射访问该类的方法。

> 在大量使用反射、动态代理、CGLib等ByteCode框、动态生成JSP以及OSGi这类频繁自定义ClassLoader的场景都需要虚拟机具备类卸载的功能，以保证永久带不会溢出。

###垃圾收集算法
几种算法的思想及其发展过程

####标记-清除算法
>标记出所有需要回收的对象，之后统一回收所有被标记的对象。

两个不足之处：

* 效率问题：标记和清除两个过程的效率都不高
* 空间问题：标记清除之后会产生大量不连续的内存碎片，会导致以后在程序运行过程中需要分配大对象时，无法找到足够的连续内存而不得不提前触发另一次垃圾收集动作。

####复制算法
>将可用内存划分为大小相等的两块，每次只使用其中一块，当这一块的内存用完了，就将还存活着的对象复制到另外一块上面，然后再把已使用过的内存空间一次清理掉。

* 商业虚拟机将内存分为一块较大的Eden和两块较小的Survivor空间，每次使用Eden和其中一块Survivor。当回收时，将Eden和Survivor中还存活着的对象一次性地复制到另外一块Survivor空间上，清理掉Eden和刚才用过的Survivor空间。
* HotSpot虚拟机默认Eden和Survivor的大小比例是8：1

####标记-整理算法
> 过程仍然与“标记-清除”算法一样，但后续步骤不是直接对可回收对象进行清理，而是让所有存活的对象都向一端移动，然后直接清理掉端边界以外的内存。

####分代收集算法
> 当前商业虚拟机的垃圾收集都采用“分代收集”算法，根据对象存活周期的不同将内存划分为几块，一般是把Java堆分为新生代和老年代，根据各个年代的特点采用最适当的收集算法.

###HotSpot的算法实现
> 在HotSpot的实现中，使用一组称为`OopMap`的数据结构来直接得知哪些地方存放着对象引用。

####安全点(SafePoint)
>  程序执行时并非在所有地方都能停顿下来开始GC，只有在到达安全点时才能暂停。

* 安全点的选定基本上是以程序“是否具有让程序长时间执行的特征”为标准进行选定的。
* “长时间执行”的最明显特征就是指令序列复用，例如方法调用、循环跳转、异常跳转等，所以具有这些功能的指令才会产生Safepoint。
* 抢先式中断：在GC发生时，首先把所有线程全部中断，如果发现有线程中断的地方不在安全点上，就恢复线程，让它“跑”到安全点上。
* 主动式中断：当GC需要中断线程的时候，不直接对线程操作，仅仅简单的设置一个标志，各个线程执行时主动去轮询这个标志，发现标志为真时，就自己中断挂起。

####安全区域
> 指在一段大妈片段中，引用关系不会发生变化，在这个区域中的任意地方开始GC都是安全的，也可以把安全区域看作是被扩展了的安全点。

###垃圾收集器

####Serial收集器
* “Stop The World”:由虚拟机在后台自动发起和自动完成的，在用户不可见的情况下把用户正常工作的线程全部停掉，这对很多应用来说都是难以接受的。
* Serial是虚拟机运行在Client模式下的默认新生代收集器，**简单而高效**（与其他收集器的单线程比），对于限定单个CPU的环境来说，Serial收集器由于没有线程交互的开销，专心做垃圾收集自然可以获得最高的单线程收集效率。

####ParNew收集器
> ParNew收集器其实就是Serial收集器的多线程版本。

* 是许多运行在Server模式下的虚拟机中首选的新生代收集器，目前只有它能与CMS收集器配合工作。
* ParNew收集器在单CPU的环境中绝对不会有比Serial收集器更好的效果

####Parallel Scavenge收集器
> CMS等收集器的关注点是尽可能地缩短垃圾收集时用户线程的停顿时间，而Parallel Scavenge收集器的目标则是达到一个可控制的吞吐量（Throughput），Parallel Scavenge收集器也经常称为“吞吐量优先”收集器
> 吞吐量=运行用户代码时间/(运行用户代码时间+垃圾收集时间)，虚拟机总共运行了100分钟，其中垃圾收集花掉1分钟，那吞吐量就是99%.

* 主要适合在后台运算而不需要太多交互的任务。
* 控制最大垃圾收集停顿时间 -XX:MaxGCPauseMillis
* 直接设置吞吐量大小 -XX:GCTimeRatio
* 虚拟机根据当前系统的运行情况收集性能监控信息，动态调整这些参数以提供最合适的停顿时间或者最大的吞吐量，开启GC自适应调解策略 -XX:+UseAdptiveSizePolicy

####Serial Old收集器
> Serial收集器的老年代版本

####Parallel Old收集器
> Parallel收集器的老年代版本

####CMS收集器
>CMS(Concurrent Mark Sweep)收集器是一种以获取最短回收停顿时间为目标的收集器。

* 优点：并发收集、低停顿。
* 缺点：
  * 对CPU资源敏感，在并发阶段会因为占用了一部分线程而导致应用程序变慢，总吞吐量会降低，CMS默认启动的回收线程数是(CPU数量+3)/4
  * 无法处理浮动垃圾(Floating Garbage)
  * “标记-清除”算法收集结束时会有大量空间碎片产生，参数-XX:CMSFullGCsBeforeCompaction，用于设置执行多少次不压缩的Full GC后，跟着来一次带压缩的(默认值为0，表示每次进入Full GC时都进行碎片整理)

####G1收集器
>一款面向服务端应用的垃圾收集器

从JDK6u14中开始就有Early Access版本的G1收集器供开发人员实验、试用。
与其他收集器相比，G1具有如下特点：

1. 并行与并发
2. 分代收集
3. 空间整合
4. 可预测的停顿

G1收集器的运作大致可划分为以下几个步骤：

1. 初始标记（initial Marking）
2. 并发标记（Concurrent Marking）
3. 最终标记（Final Marking）
4. 筛选回收（Live Data Counting and Evacuation）

####理解GC日志
```
0.202: [Full GC (System) 0.202: [CMS: 0K->330K(63872K), 0.0153362 secs] 5462K->330K(83008K), [CMS Perm : 4629K->4628K(21248K)], 0.0156160 secs] [Times: user=0.02 sys=0.01, real=0.01 secs] 
Heap
 par new generation   total 19136K, used 1021K [7f3000000, 7f44c0000, 7f44c0000)
  eden space 17024K,   6% used [7f3000000, 7f30ff6a0, 7f40a0000)
  from space 2112K,   0% used [7f40a0000, 7f40a0000, 7f42b0000)
  to   space 2112K,   0% used [7f42b0000, 7f42b0000, 7f44c0000)
 concurrent mark-sweep generation total 63872K, used 330K [7f44c0000, 7f8320000, 7fae00000)
 concurrent-mark-sweep perm gen total 21248K, used 4689K [7fae00000, 7fc2c0000, 800000000)
```
* 最前面的数字`0.202`代表GC发生的时间，是从Java虚拟机启动以来经过的秒数
* `Full GC`说明了这次垃圾收集的停顿类型，有`Full`说明发生了`Stop-The-World`，如果是调用`system.gc()`方法所触发的收集，将显示`(System)`
* `CMS Perm`表示GC发生的区域，名称是由收集器决定的。
* `4629K->4628K(21248K)`含义是**GC前该内存区域已使用容量->GC后该内存区域使用容量（该内存区域总容量）
* `0.0156160 secs`表示该内存区域GC所占用的时间，单位是秒，当系统有多CPU或者多核的话，多线程操作会叠加这些CPU时间，所以看到user或者sys时间超过real时间是完全正确的。

###内存分配与回收策略
* 自动内存管理：给对象分配内存以及回收分配给对象的内存。
* 对象主要分配在新生代的Eden区上，如果启动了本地线程分配缓冲，将按线程优先在TLAB上分配。少数情况下也可能会直接分配在老年代中，分配的规则并不是百分之百固定的，其细节取决于当前使用的是哪一种垃圾收集器组合，还有虚拟机中与内存相关的参数的设置。

####对象优先在Eden分配
> 当Eden区没有足够空间进行分配时,虚拟机将发起一次Minor GC（新生代GC）
> Major GC(老年代GC)的速度一般会比MinorGC慢10倍以上

####大对象直接进入老年代
* -XX:PretenureSizeThreshold,令大于这个设置值的对象直接在老年代分配。**只对Serial和ParNew两款收集器有效**

####长期存活的对象将进入老年代
> 虚拟机给每个对象定义了一个对象年龄（Age）计数器。如果对象在Eden出生并经过第一次Minor GC后仍然存活，并且能被Survivor容纳的话，将被移动到Survivor空间中，并且对象年龄设为1.

> 对象每熬过一次Minor GC，年龄就增加一岁，当它的年龄增加到一定程度（默认为15岁），就将会被晋升到老年代中。

> 对象晋升老年代的年龄阀值，可以通过参数-XX:MaxTenuringThreshold设置。

####动态 对象年龄 判定
> 如果在Survivor空间中相同年龄所有对象大小的总和大于Survivor空间的一半，年龄大于或等于该年龄的对象就可以直接进入老年代