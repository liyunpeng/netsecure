pvc 依赖于pv， pv依赖于nfs文件系统， 
在建立pv，pvc之前，要确保k8s的每台主机都能正常挂再nfs文件系统.  
当前nfs网络文件系统建立在192.168.0.211主机下， 其他每台主机都要把这个网络文件系统挂载到自己主机下。
如：
```gotemplate

$ mount -t nfs 192.168.0.211:/usr/local/k8s/redis/pv1  ./a

```
向本地目录a,touch一个文件， 到192.168.0.211主机下的/usr/local/k8s/redis/pv1目录下能看到这个文件。就说明成功
去掉挂载的命令：

```
$ sudo umount 192.168.0.211:/usr/local/k8s/redis/pv4

```
nfs文件系统的配置写好后, 就可以启动nfs服务.   
遇到了几个问题， 其他主机没安装nfs客户端，配置文件没写对，作为nfs文件系统的/usr/local/k8s/redis/ 没有给其他用户写的权限。
细说这几个问题：
### 1.  mount -t nfs 不能执行
原因是安装nfs客户端， 需要安装nfs客户端
另外因为k8s在调度时， 可能会调度到任何主机上， 所以每台主机都要安装nfs， pod在使用pvc时， 会去这个客户端挂载nfs文件系统。 
解决办法：
集群里每台主机运行：
```
sudo apt-get install nfs-common, 安装nfs客户端
```

### 2.  nfs的配置文件/etc/exports里的内容错误， 导致其他主机无权挂载这个文件系统
```
/usr/local/k8s/redis/pv1 192.168.0.211 (rw,sync,no_root_squash)
```
表示只能被192.168.0.211这个ip地址的主机挂载， 
解决办法; 
上面改为：
```
/usr/local/k8s/redis/pv1 *(rw,sync,no_root_squash)
```
才能被其他主机挂载。 

### 3.  挂载之后，不能写文件：
到/usr/local/k8s/redis目下，将所有子文件夹该为777权限

```
user@ /usr/local/k8s/redis$ sudo chmod 777 *
node1@docker-app:/usr/local/k8s/redis$ sudo chmod 777 *
node1@docker-app:/usr/local/k8s/redis$ ll
total 32
drwxr-xr-x 8 root root 4096 Dec 29 10:24 ./
drwxr-xr-x 3 root root 4096 Dec 29 10:24 ../
drwxrwxrwx 2 root root 4096 Dec 29 10:24 pv1/
drwxrwxrwx 2 root root 4096 Dec 29 10:24 pv2/
drwxrwxrwx 2 root root 4096 Dec 29 10:24 pv3/
drwxrwxrwx 2 root root 4096 Dec 30 23:01 pv4/
drwxrwxrwx 2 root root 4096 Dec 29 10:24 pv5/
drwxrwxrwx 2 root root 4096 Dec 29 10:24 pv6/
```

### 4.  /etc/exports 配置文件内容错误， 导致nfs服务器无法启动
因为改了/etc/exports这个服务配置文件，想让配置生效，需要重启nfs服务，restart启动，就先stop, 后start的方式启动

停止服务：
```
$ sudo /etc/init.d/nfs-kernel-server stop
 [ ok ] Stopping nfs-kernel-server (via systemctl): nfs-kernel-server.service.
```

启动服务：
```
$ sudo /etc/init.d/nfs-kernel-server start
 [....] Starting nfs-kernel-server (via systemctl): nfs-kernel-server.serviceJob for nfs-server.service canceled.
  failed!
```

服务没起来， 查看服务状态：
```
$ sudo /etc/init.d/nfs-kernel-server status
 ● nfs-server.service - NFS server and services
 Dec 30 22:55:44 docker-app systemd[1]: Starting NFS server and services...
 Dec 30 22:55:44 docker-app exportfs[82787]: exportfs: /etc/exports [1]: Neither 'subtree_check' or 'no_subtree_check' specified for export…edis/pv1".
 Dec 30 22:55:44 docker-app exportfs[82787]:   Assuming default behaviour ('no_subtree_check').
 Dec 30 22:55:44 docker-app exportfs[82787]:   NOTE: this default has changed since nfs-utils version 1.0.x
 Dec 30 22:55:44 docker-app exportfs[82787]: exportfs: /etc/exports:2: unknown keyword "inseruce"
 Dec 30 22:55:44 docker-app systemd[1]: nfs-server.service: Control process exited, code=exited status=1
 Dec 30 22:55:45 docker-app systemd[1]: nfs-server.service: Failed with result 'exit-code'.
 Dec 30 22:55:45 docker-app systemd[1]: Stopped NFS server and services.
 Hint: Some lines were ellipsized, use -l to show in full.
```
看到错误原因： 
```
exportfs: /etc/exports:2: unknown keyword "inseruce"， 这是笔误， 改成insecure, 在启动服务，服务就能正常启动了。
```

重启后查看服务：
```
[node1@215-node ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: inactive (dead)
[node1@215-node ~]$ sudo systemctl start  nfs-server
[node1@215-node ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: active (exited) since Sat 2020-01-04 23:16:46 EST; 1s ago
  Process: 95867 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gssproxy ; fi (code=exited, stat>
  Process: 95848 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
  Process: 95846 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
 Main PID: 95867 (code=exited, status=0/SUCCESS)
1月 04 23:16:45 215-node systemd[1]: Starting NFS server and services...
1月 04 23:16:46 215-node systemd[1]: Started NFS server and services.
```

网络文件系统nfs正常可用后, 才可以去创建pv, pvc.
nfs 没有启动， pod redis会error， nfs启动好了， pod Redis会自动变为running, 说明pod redis,一直去尝试挂载
