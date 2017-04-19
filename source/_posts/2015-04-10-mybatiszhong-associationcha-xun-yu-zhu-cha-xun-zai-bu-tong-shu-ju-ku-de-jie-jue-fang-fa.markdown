---
layout: post
title: "mybatis中association查询与主查询在不同数据库的解决方法"
date: 2015-04-10 19:44
comments: true
categories: 
images: []

---
##问题描述
Mybatis 关联的嵌套查询 官方的例子:

``` xml
<resultMap id="blogResult" type="Blog">
  <association property="author" column="author_id" javaType="Author" select="selectAuthor"/>
</resultMap>

<select id="selectBlog" resultMap="blogResult">
  SELECT * FROM BLOG WHERE ID = #{id}
</select>

<select id="selectAuthor" resultType="Author">
  SELECT * FROM AUTHOR WHERE ID = #{id}
</select>
```

这个时候,如果`AUTHOR`表与`BLOG`在两个不同的数据库中,执行会报找不到`AUTHOR`表.

##解决思路
新建一个Mybatis的`Plugins插件`,在第二次查询也就是`selectAuthor`执行之前,切换数据源为另一个数据库.看一下Plugins都可以用于哪些地方:

* Executor (update, query, flushStatements, commit, rollback, getTransaction, close, isClosed)
* ParameterHandler (getParameterObject, setParameters)
* ResultSetHandler (handleResultSets, handleOutputParameters)
* StatementHandler (prepare, parameterize, batch, update, query)

<!-- more -->

###尝试1
拦截`Executor`的`query`方法是最先想到的,毕竟是符合思路的"执行查询之前",有两个`query`方法:

* <E> List<E> query(MappedStatement var1, Object var2, RowBounds var3, ResultHandler var4, CacheKey var5, BoundSql var6) throws SQLException;
* <E> List<E> query(MappedStatement var1, Object var2, RowBounds var3, ResultHandler var4) throws SQLException;

尝试结果:4个参数的只能拦截到执行主查询,6个参数的什么都拦截不到,暂时放弃

###尝试2
子查询执行之前既然不行,就尝试在主查询执行完成之后,拦截`ResultSetHandler`的`handleResultSets`.

尝试结果:在主查询结束后替换掉了dataSource,子查询也顺利查出,但是有不可扩展的问题:如果主查询需要多个映射查询,分别在不同数据库中,在此处无法得知接下来要执行的是哪一个库的,所以此尝试方案只适用于只有一个子查询的情况,放弃

###尝试3
开始思考`尝试1`失败的原因,debug发现子查询确实是执行了`query`6个参数的方法,但是为什么没有拦截住呢,怀疑是因为JDK的动态代理是基于接口的,而此处的调用是方法内部之间的调用,并没有通过接口,所以拦截失败.那如果使用基于继承的`cglib`动态代理呢?

尝试结果:还是无法拦截,在类的内部的方法之间的调用,是无法通过动态代理拦截的,具体原因如这篇[Spring AOP源码分析（八）SpringAOP要注意的地方](http://lgbolgger.iteye.com/blog/2123895)所说,放弃

###尝试4
既然执行前和执行后都不行,再尝试一下`StatementHandler`的`query`.

####尝试4.1
对调用者`StatementHandler`中的`delegate.executor.transaction.dataSource`和`delegate.executor.transaction.connection`替换.结果数据库并没有切换,放弃
####尝试4.2
对方法参数`Statement`中的`inner.connection`和`inner.currentCatalog`替换.结果成功!

如思路,执行主查询后,子查询前把connection替换为另一个数据库连接,并且通过调用者`StatementHandler`的`delegate.mappedStatement.id`可以取到子查询的id,再通过对id名称的约定(名称中包含db名称)实现扩展.

###问题
在使用中发现,连续查询20次之后就无法查询了,怀疑是因为connection没有close的原因.debug发现确实是卡在了`dataSource.getConnection()`,改良方法:`invocation.proceed();`执行之后手动关闭connection.


解决问题.

###代码
``` java

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.mchange.v2.c3p0.impl.NewProxyConnection;
import com.foooooo.common.util.SpringBeanFactoryUtils;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.factory.DefaultObjectFactory;
import org.apache.ibatis.reflection.factory.ObjectFactory;
import org.apache.ibatis.reflection.wrapper.DefaultObjectWrapperFactory;
import org.apache.ibatis.reflection.wrapper.ObjectWrapperFactory;
import org.apache.ibatis.session.ResultHandler;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.Statement;
import java.util.Properties;

/**
 * Created by SargerasWang on 15/4/9.
 */
@Intercepts({@Signature(type = StatementHandler.class, method = "query", args = {Statement.class, ResultHandler.class})})
public class DynamicDatasourcePlugin implements Interceptor {

    private static final ObjectFactory DEFAULT_OBJECT_FACTORY = new DefaultObjectFactory();
    private static final ObjectWrapperFactory DEFAULT_OBJECT_WRAPPER_FACTORY = new DefaultObjectWrapperFactory();

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        Statement statement = (Statement) invocation.getArgs()[0];
        StatementHandler statementHandler = (StatementHandler) invocation.getTarget();

        MetaObject metaStatement =  getRealObj(statement);
        MetaObject metaStatementHandler = getRealObj(statementHandler);

        String index = (String) metaStatementHandler.getValue("delegate.mappedStatement.id");
        if (index.startsWith("_formatter_")) {
            String dataSourceBeanName = index.substring("_formatter_".length() + 1, index.indexOf("!"));
            ComboPooledDataSource dataSource = (ComboPooledDataSource) SpringBeanFactoryUtils.getBean("ds_" + dataSourceBeanName);
            NewProxyConnection connection = (NewProxyConnection)dataSource.getConnection();

            Field inner = connection.getClass().getDeclaredField("inner");
            inner.setAccessible(true);

            metaStatement.setValue("inner.connection",inner.get(connection) );
            metaStatement.setValue("inner.currentCatalog", dataSourceBeanName);

            Object result = invocation.proceed();

            connection.close();//这里关闭连接

            return result;
        }
        return invocation.proceed();
    }

    private MetaObject getRealObj(Object obj) {
        MetaObject metaStatement = MetaObject.forObject(obj, DEFAULT_OBJECT_FACTORY,
                DEFAULT_OBJECT_WRAPPER_FACTORY);
        // 分离代理对象链(由于目标类可能被多个拦截器拦截，从而形成多次代理，通过下面的两次循环可以分离出最原始的的目标类)
        while (metaStatement.hasGetter("h")) {
            Object object = metaStatement.getValue("h");
            metaStatement = MetaObject.forObject(object, DEFAULT_OBJECT_FACTORY, DEFAULT_OBJECT_WRAPPER_FACTORY);
        }
        // 分离最后一个代理对象的目标类
        while (metaStatement.hasGetter("target")) {
            Object object = metaStatement.getValue("target");
            metaStatement = MetaObject.forObject(object, DEFAULT_OBJECT_FACTORY, DEFAULT_OBJECT_WRAPPER_FACTORY);
        }
        return metaStatement;
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target, this);
    }

    @Override
    public void setProperties(Properties properties) {

    }
}
```