
get pod 看到有redis pod没有运行起来
```
[user1@220-node ~]$ k get po -o wide
NAME                         READY   STATUS        RESTARTS   AGE   IP               NODE       NOMINATED NODE   READINESS GATES
kafaka-n1-7b9df4dd8d-2p4tf   1/1     Running       6          87m   192.168.68.135   220-node   <none>           <none>
redis-0                      1/1     Terminating   0          30h   192.168.135.2    217-node   <none>           <none>
zk-n1-6784764cc9-25ph4       1/1     Running       0          87m   192.168.68.136   220-node   <none>           <none>
```

本文讲述一下redis pod异常的排查步骤
### （一） 查看pod详情：
```
[user1@220-node ~]$ kd po redis-0
Name:                      redis-0
Namespace:                 default
Priority:                  0
Node:                      217-node/192.168.0.217
Start Time:                Wed, 15 Jan 2020 03:15:48 -0500
Labels:                    app=redis-p
                           appCluster=redis-cluster
                           controller-revision-hash=redis-56cfddcd57
                           statefulset.kubernetes.io/pod-name=redis-0
Annotations:               cni.projectcalico.org/podIP: 192.168.135.2/32
Status:                    Terminating (lasts 87m)
Termination Grace Period:  20s
IP:                        192.168.135.2
IPs:
  IP:           192.168.135.2
Controlled By:  StatefulSet/redis
Containers:
  redis-c:
    Container ID:  docker://564d04dd9689ed688d09768ba7675244b8819aba10b1888bcbf5a1292366df38
    Image:         redis
    Image ID:      docker-pullable://redis@sha256:90d44d431229683cadd75274e6fcb22c3e0396d149a8f8b7da9925021ee75c30
    Ports:         6379/TCP, 16379/TCP
    Host Ports:    0/TCP, 0/TCP
    Command:
      redis-server
    Args:
      /etc/redis/redis.conf
      --protected-mode
      no
    State:          Running
      Started:      Wed, 15 Jan 2020 03:17:08 -0500
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /etc/redis from redis-conf (rw)
      /var/lib/redis from data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-5l44v (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  data-redis-0
    ReadOnly:   false
  redis-conf:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      redis-conf
    Optional:  false
  default-token-5l44v:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-5l44v
    Optional:    false
QoS Class:       Burstable
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason         Age                  From               Message
  ----     ------         ----                 ----               -------
  Warning  FailedKillPod  32s (x2 over 2m32s)  kubelet, 217-node  error killing pod: failed to "KillContainer" for "redis-c" with KillContainerError: "rpc error: code = Unknown desc = operation timeout: context deadline exceeded"
  Normal   Killing        31s (x3 over 4m34s)  kubelet, 217-node  Stopping container redis-c

```
 Warning Events显示rpc的超时错误: 
```
rpc error: code = Unknown desc = operation timeout: 

```
没能显示出更具体的原因
后来排查得知，这里的rpc超时是因为redis pod所挂载的pv 是nfs网络文件系统， 而nfs网络文件系统服务并没有启动。 

解决办法是启动nfs服务即可。 

> 说一下nfs，nfs不同于glusterfs, nfs不是集群式的文件系统，所以只需要一台主机启动nfs服务即可，启动后， 其他主机调用nfs 客户端工具访问nfs服务即可。 
nfs不是集群，存储硬盘只在nfs服务所在的主机上。 

> glusterfs是一个glusterfs集群，需要每台主机都要启动glusterfs服务， 存储硬盘要在多台主机上。 

### （二） 查看pod 的log记录  
这个log是pod里面服务打印出的log，这是是容器中运行的应用服务的log, 不是k8s系统的log。
```
[user1@220-node ~]$ k logs redis-0
1:C 15 Jan 2020 08:17:07.715 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo   redis 开始启动
1:C 15 Jan 2020 08:17:07.716 # Redis version=5.0.7, bits=64, commit=00000000, modified=0, pid=1, just started    redis版本号
1:C 15 Jan 2020 08:17:07.716 # Configuration loaded    从配置文件加载配置数据， 一般为初始化一个配置对象，供后面使用
1:M 15 Jan 2020 08:17:07.724 * Running mode=standalone, port=6379.   显示为单机版模式
1:M 15 Jan 2020 08:17:07.725 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
1:M 15 Jan 2020 08:17:07.725 # Server initialized
1:M 15 Jan 2020 08:17:07.726 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
linux内核功能THP需要关闭， 
1:M 15 Jan 2020 08:17:07.739 * Ready to accept connections    接受连接请求
1:signal-handler (1579185045) Received SIGTERM scheduling shutdown...       收到停止信号SIGTERM
1:M 16 Jan 2020 14:30:46.030 # User requested shutdown...
1:M 16 Jan 2020 14:30:46.030 * Calling fsync() on the AOF file.                   AOF 持久化
1:M 16 Jan 2020 14:30:46.031 # Redis is now ready to exit, bye bye...           
```
应用服务的log, 每一条都是由分析意义， 不像有些大系统log,  很多个模块的log混杂在一起，真正有无分析意义的log占不到10%
redis log只是有停止信号， 真正原因也没有显示出来

### （三） 查看pvc, pv:
```
[user1@220-node ~]$ k get pvc
NAME           STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-redis-0   Bound    nfs-pv1   200M       RWX                           31h
[user1@220-node ~]$ kd pvc data-redis-0
Name:          data-redis-0
Namespace:     default
StorageClass:
Status:        Bound
Volume:        nfs-pv1
Labels:        <none>
Annotations:   kubectl.kubernetes.io/last-applied-configuration:
                 {"apiVersion":"v1","kind":"PersistentVolumeClaim","metadata":{"annotations":{},"name":"data-redis-0","namespace":"default"},"spec":{"acces...
               pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      200M
Access Modes:  RWX
VolumeMode:    Filesystem
Mounted By:    redis-0
Events:        <none>
```
pvc 显示正常， bound， 而且没有异常events

查看pv：

```
[user1@220-node ~]$ k get pv
NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE
nfs-pv1   200M       RWX            Retain           Bound    default/data-redis-0                           31h

[user1@220-node ~]$ kd pv nfs-pv1
Name:            nfs-pv1
Labels:          <none>
Annotations:     kubectl.kubernetes.io/last-applied-configuration:
                   {"apiVersion":"v1","kind":"PersistentVolume","metadata":{"annotations":{},"name":"nfs-pv1"},"spec":{"accessModes":["ReadWriteMany"],"capac...
                 pv.kubernetes.io/bound-by-controller: yes
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:
Status:          Bound
Claim:           default/data-redis-0
Reclaim Policy:  Retain
Access Modes:    RWX
VolumeMode:      Filesystem
Capacity:        200M
Node Affinity:   <none>
Message:
Source:
    Type:      NFS (an NFS mount that lasts the lifetime of a pod)
    Server:    192.168.0.220
    Path:      /usr/local/k8s/redis/pv1
    ReadOnly:  false
Events:        <none>
```
pv 也正常， 这里Source列出了： 
* 底层存储的文件系统类型，这里为NFS. 
* NFS服务ip地址，192.168.0.220，NFS服务在哪台主机，nfs文件系统的硬盘就在哪台主机。 
* nfs文件系统的硬盘挂载到硬盘所在主机的哪个目录，这里挂载目录为 /usr/local/k8s/redis/pv1

### （四） 到pv描述的nfs服务地址的主机上，查看这个主机上有没有启动nfs服务
知道了NFS服务的ip地址，就要到这个ip地址的主机检查一下， nfs服务有没有正常启动。 
主机名为220-node的主机的ip地址为192.168.0.220，到这个主机上查看服务状态： 
 ```gotemplate
[user1@220-node redis]$ sudo systemctl status nfs-server.service
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
  Drop-In: /run/systemd/generator/nfs-server.service.d
           └─order-with-mounts.conf
   Active: inactive (dead)
```
服务没有启动， 这是pod redis不能启动的真正根本原因了。 


```
[user1@220-node redis]$ sudo exportfs -vs

```
exportfs -vs 为空，说明nfs服务确实没有启动。 

### （五） 解决办法： 到pv描述的nfs所在的主机上启动nfs服务
```
[user1@220-node redis]$ sudo systemctl start nfs-server.service
```
终端没有log提示， centos8下启动kafka服务也没有log提示，这是centos8启动的一种处理方式， 如果没有错误， 就不会有log提示。 

exportfs看下：

```
[user1@220-node redis]$ sudo exportfs -vs
/usr/local/k8s/redis/pv1  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/usr/local/k8s/redis/pv2  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/usr/local/k8s/redis/pv3  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/usr/local/k8s/redis/pv4  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/usr/local/k8s/redis/pv5  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
/usr/local/k8s/redis/pv6  *(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)

```
nfs服务启动好了，pod redis就自动好了：

```
[user1@220-node redis]$ k get po -o wide
NAME                         READY   STATUS    RESTARTS   AGE     IP               NODE       NOMINATED NODE   READINESS GATES
kafaka-n1-7b9df4dd8d-2p4tf   1/1     Running   6          105m    192.168.68.135   220-node   <none>           <none>
redis-0                      1/1     Running   0          4m39s   192.168.135.6    217-node   <none>           <none>
zk-n1-6784764cc9-25ph4       1/1     Running   0          105m    192.168.68.136   220-node   <none>           <none>

```
用redis-cli客户端工具命令，连接到k8s集群里pod里的redis服务：

```
[user1@220-node ~]$ cd /usr/local/redis/bin
[user1@220-node bin]$ ./redis-cli -h 192.168.135.6 -p 6379
192.168.135.6:6379> set a b
OK
192.168.135.6:6379> get a
"b"
```
测试成功， 问题解决
