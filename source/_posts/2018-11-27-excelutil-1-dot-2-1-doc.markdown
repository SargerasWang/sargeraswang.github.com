---
layout: post
title: "ExcelUtil 1.2.1 doc"
date: 2018-11-27 17:08
comments: true
categories: 
images: []
---

[GitHub地址](https://github.com/SargerasWang/ExcelUtil)

事实上,使用方式在 `test` 中有,因为有这个Issue,所以贴到这里来.

<!--more-->

####数据模型

通常可以使用你的数据表bean,当然如果需要导入/导出的字段与数据表差异很大,可以新增bean,当然也可以跳过bean,直接使用`Map`,下面是示例Bean:

``` java
public class Model {
    @ExcelCell(index = 0)
    private String a;
    @ExcelCell(index = 1)
    private String b;
    @ExcelCell(index = 2)
    private String c;
    @ExcelCell(index = 3)
    private Date d;

    public Date getD() {
        return d;
    }

    public void setD(Date d) {
        this.d = d;
    }

    public Model(String a, String b, String c,Date d) {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
    }

    //setter and getter 省略...
}
```

####导出-Bean方式

``` java
        //用排序的Map且Map的键应与ExcelCell注解的index对应
        Map<String,String> map = new LinkedHashMap<>();
        map.put("a","姓名");
        map.put("b","年龄");
        map.put("c","性别");
        map.put("d","出生日期");
        Collection<Object> dataset=new ArrayList<Object>();
        dataset.add(new Model("", "", "",null));
        dataset.add(new Model(null, null, null,null));
        dataset.add(new Model("王五", "34", "男",new Date()));
        File f=new File("test.xls");
        OutputStream out =new FileOutputStream(f);
        
        ExcelUtil.exportExcel(map, dataset, out);
        out.close();
```

####导出-Map方式

``` java
    List<Map<String,Object>> list = new ArrayList<>();
    Map<String,Object> map =new LinkedHashMap<>();
    map.put("name", "");
    map.put("age", "");
    map.put("birthday","");
    map.put("sex","");
    Map<String,Object> map2 =new LinkedHashMap<String, Object>();
    map2.put("name", "测试是否是中文长度不能自动宽度.测试是否是中文长度不能自动宽度.");
    map2.put("age", null);
    map2.put("sex", null);
    map.put("birthday",null);
    Map<String,Object> map3 =new LinkedHashMap<String, Object>();
    map3.put("name", "张三");
    map3.put("age", 12);
    map3.put("sex", "男");
    map3.put("birthday",new Date());
    list.add(map);
    list.add(map2);
    list.add(map3);
    Map<String,String> map1 = new LinkedHashMap<>();
    map1.put("name","姓名");
    map1.put("age","年龄");
    map1.put("birthday","出生日期");
    map1.put("sex","性别");
    File f= new File("test.xls");
    OutputStream out = new FileOutputStream(f);
    ExcelUtil.exportExcel(map1,list, out );
    out.close();
```

####导入

`ExcelUtil.importExcel` 方法的第一个参数,是个`Class`,如果你有`Bean`,就写Bean的Class,反之,直接`Map.class`

##### XLS 文件

``` java
    File f=new File("src/test/resources/test.xls");
    InputStream inputStream= new FileInputStream(f);
    
    ExcelLogs logs =new ExcelLogs();
    Collection<Map> importExcel = ExcelUtil.importExcel(Map.class, inputStream, "yyyy/MM/dd HH:mm:ss", logs , 0);
    
    for(Map m : importExcel){
      System.out.println(m);
    }
```

##### XLSX 文件

``` java
    File f=new File("src/test/resources/test.xlsx");
    InputStream inputStream= new FileInputStream(f);

    ExcelLogs logs =new ExcelLogs();
    Collection<Map> importExcel = ExcelUtil.importExcel(Map.class, inputStream, "yyyy/MM/dd HH:mm:ss", logs , 0);

    for(Map m : importExcel){
      System.out.println(m);
    }
```

