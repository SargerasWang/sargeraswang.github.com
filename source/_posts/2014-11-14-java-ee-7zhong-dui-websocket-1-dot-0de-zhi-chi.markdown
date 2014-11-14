---
layout: post
title: "Java EE 7中对WebSocket 1.0的支持"
date: 2014-11-14 14:24
comments: true
categories: 
images: []

---
>非原创,原文链接：http://www.javaarch.net/jiagoushi/749.htm
>原文打不开,所以贴到这里.

##	server端

#### pom依赖:

{% codeblock lang:xml %}
    <dependency>  
        <groupId>javax</groupId>  
        <artifactId>javaee-api</artifactId>  
        <version>7.0-b82</version>  
        <scope>provided</scope>  
    </dependency>  

{% endcodeblock %}

#### src/main/java/com/hmkcode/MyServerEndpoint.java  

{% codeblock lang:java %}
    package com.hmkcode;  
       
    import java.io.IOException;  
    import java.util.LinkedList;  
    import javax.websocket.EncodeException;  
    import javax.websocket.OnClose;  
    import javax.websocket.OnMessage;  
    import javax.websocket.OnOpen;  
    import javax.websocket.Session;  
    import javax.websocket.server.PathParam;  
    import javax.websocket.server.ServerEndpoint;  
       
    @ServerEndpoint(value="/websocket/{client-id}")  
    public class MyServerEndpoint {  
       
        private static final LinkedList<Session> clients = new LinkedList<Session>();  
       
        @OnOpen  
        public void onOpen(Session session) {  
            clients.add(session);  
        }  
        @OnMessage  
        public void onMessage(String message,@PathParam("client-id") String clientId) {  
            for (Session client : clients) {  
                try {  
                    client.getBasicRemote().sendObject(clientId+": "+message);              
       
                } catch (IOException e) {  
                    e.printStackTrace();  
                } catch (EncodeException e) {  
                    e.printStackTrace();  
                }  
            }  
        }  
        @OnClose  
        public void onClose(Session peer) {  
            clients.remove(peer);  
        }  
    }  
{% endcodeblock %}    
<!-- more -->
`@ServerEndpoint(value=”/websocket/{client-id}”)`是client连接的url地址，`{client-id}`是每个client连接的名称标识。  
`@onOpen`，`@onMessag`和`@onClose`是对应的每个session连接生命周期的回调函数  
  
##websocket客户端(桌面端)  
  
#### pom依赖：  
{% codeblock lang:xml %}
    <dependency>  
        <groupId>javax</groupId>  
        <artifactId>javaee-api</artifactId>  
        <version>7.0-b82</version>  
    </dependency>  
    <dependency>  
        <groupId>org.glassfish.tyrus</groupId>  
        <artifactId>tyrus-client</artifactId>  
        <version>1.0-rc3</version>  
    </dependency>  
    <dependency>  
        <groupId>org.glassfish.tyrus</groupId>  
        <artifactId>tyrus-container-grizzly</artifactId>  
        <version>1.0-rc3</version>  
    </dependency>  
{% endcodeblock %}    

#### src/main/java/com/hmkcode/MyClient.java  
{% codeblock lang:java %}  
    package com.hmkcode;  
       
    import java.io.IOException;  
    import javax.websocket.ClientEndpoint;  
    import javax.websocket.OnError;  
    import javax.websocket.OnMessage;  
    import javax.websocket.OnOpen;  
    import javax.websocket.Session;  
       
    @ClientEndpoint  
    public class MyClient {  
        @OnOpen  
        public void onOpen(Session session) {  
            System.out.println("Connected to endpoint: " + session.getBasicRemote());  
            try {  
                session.getBasicRemote().sendText("Hello");  
            } catch (IOException ex) {  
            }  
        }  
       
        @OnMessage  
        public void onMessage(String message) {  
            System.out.println(message);  
        }  
       
        @OnError  
        public void onError(Throwable t) {  
            t.printStackTrace();  
        }  
    }  
{% endcodeblock %}      

#### src/main/java/com/hmkcode/App.java  

{% codeblock lang:java %}
    package com.hmkcode;  
       
    import java.io.BufferedReader;  
    import java.io.IOException;  
    import java.io.InputStreamReader;  
    import java.net.URI;  
    import javax.websocket.ContainerProvider;  
    import javax.websocket.DeploymentException;  
    import javax.websocket.Session;  
    import javax.websocket.WebSocketContainer;  
       
    public class App {  
       
        public Session session;  
       
        protected void start()  
                 {  
       
                WebSocketContainer container = ContainerProvider.getWebSocketContainer();  
       
                String uri = "ws://localhost:8080/websocket-glassfish-server/websocket/desktop-client";  
                System.out.println("Connecting to " + uri);  
                try {  
                    session = container.connectToServer(MyClient.class, URI.create(uri));  
                } catch (DeploymentException e) {  
                    e.printStackTrace();  
                } catch (IOException e) {  
                    e.printStackTrace();  
                }               
       
        }  
        public static void main(String args[]){  
            App client = new App();  
            client.start();  
       
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));  
            String input = "";  
            try {  
                do{  
                    input = br.readLine();  
                    if(!input.equals("exit"))  
                        client.session.getBasicRemote().sendText(input);//发送消息
       
                }while(!input.equals("exit"));  
       
            } catch (IOException e) {  
                // TODO Auto-generated catch block  
                e.printStackTrace();  
            }  
        }  
    }  
{% endcodeblock %} 
##websocket客户端(web )  
  
#### /src/main/webapp/index.htm  

{% codeblock lang:html %}
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  
    <html xmlns="http://www.w3.org/1999/xhtml">  
       
    <head>  
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
    <title>Java API for WebSocket (JSR-356)</title>  
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />  
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>  
    <script src="websocket.js" type="text/javascript"></script>  
    </head>  
    <body>  
        <div class="container">  
            <h1>Java API for WebSocket (JSR-356)</h1>  
            <div>  
                <span id="status" class="label label-important">Not Connected</span>   
            </div>      
            <br/>  
       
            <label style="display:inline-block">Message: </label><input type="text" id="message"  />  
            <button id="send" class="btn btn-primary" onclick="sendMessage()">Send</button>  
       
            <table id="received_messages" class="table table-striped">  
                <tr>  
                    <th>#</th>  
                    <th>Sender</th>  
                    <th>Message</th>  
                </tr>  
            </table>  
        </div>  
    </body>  
    </html>  
{% endcodeblock %}

#### /src/main/webapp/websocket.js  

{% codeblock lang:js %}
  
    var URL = "ws://localhost:8080/websocket-glassfish-server/websocket/web-client";  
    var websocket;  
       
    $(document).ready(function(){  
        connect();    
    });  
       
    function connect(){  
            websocket = new WebSocket(URL);  
            websocket.onopen = function(evnt) { onOpen(evnt) };  
            websocket.onmessage = function(evnt) { onMessage(evnt) };  
            websocket.onerror = function(evnt) { onError(evnt) };  
    }  
    function sendMessage() {  
        websocket.send($("#message").val());  
    }  
    function onOpen() {  
        updateStatus("connected")  
    }  
    function onMessage(evnt) {  
        if (typeof evnt.data == "string") {  
       
            $("#received_messages").append(  
                            $('<tr/>')  
                            .append($('<td/>').text("1"))  
                            .append($('<td/>').text(evnt.data.substring(0,evnt.data.indexOf(":"))))  
                            .append($('<td/>').text(evnt.data.substring(evnt.data.indexOf(":")+1))));  
        }   
    }  
    function onError(evnt) {  
        alert('ERROR: ' + evnt.data);  
    }  
    function updateStatus(status){  
        if(status == "connected"){  
            $("#status").removeClass (function (index, css) {  
               return (css.match (/\blabel-\S+/g) || []).join(' ')  
            });  
            $("#status").text(status).addClass("label-success");  
        }  
    }  
{% endcodeblock %}

