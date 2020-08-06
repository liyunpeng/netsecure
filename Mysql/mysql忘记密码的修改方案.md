linux下mysql忘记密码解决方案
一、写随笔的原因：之前自己服务器上的mysql很久不用了，忘记了密码，所以写一下解决方案，以供以后参考

 

二、具体的内容：

1. 检查mysql服务是否启动，如果启动，关闭mysql服务

运行命令：ps -ef | grep -i mysql



 

 如果开着就运行关闭的命令：service mysqld stop



 

 2.修改mysql的配置文件my.conf

一般在/etc目录下，运行命令：vi /etc/my.cnf，编辑文件



 

 在文件的[mysqld]标签下添加一句：skip-grant-tables



 

然后wq!保存退出。

 3.重启数据库

 运行命令：service mysqld start
 4.重启数据库

 运行命令：service mysqld start
 5.进入到mysql数据库

 运行命令：mysql -u root 


 

 

 6.进入到mysql数据库

 运行命令：mysql -u root 
 7.修改密码

运行语句：use mysql;
继续运行语句：update mysql.user set authentication_string=password('root_password') where user='root';    
root_password替换成你想要的密码
 
 

  8.把步骤2加的东西删除掉，在重启服务器，就可以使用刚才修改的密码登录进服务器了。

 mysql -u root -p

到这一步已经全部结束。

三、总结：

这次修改MySQ密码L主要的就是解决忘记密码的问题。希望这篇随笔为一些忘记mysql密码，想改密码的人做个参考吧，也为了我以后做个参考吧。