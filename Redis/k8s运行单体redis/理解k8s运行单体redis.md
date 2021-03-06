单机版与集群版的redis区别：
* redis.conf不同，
* pv只要一个，
* pvc只要一个，
其他相同


1. 宿主机系统需要安装nfs和redis, nfs提供网络文件系统，redis提供测试命令redis-cli
   执行本地安装目录下的安装nfs服务的脚本，和安装redis的脚本

2. 单机模式需要在配置文件redis.conf指定
配置文件redis.conf的cluster-enabled项指定了redis是否为集群模式，
如果是单机模式，需要指定为no：
cluster-enabled no
否则设置键值对时，会报集群槽的错误：
10.96.213.24:6379> set a b
(error) CLUSTERDOWN Hash slot not served

3. 创建redis的所有需要的资源
kubectl create configmap redis-conf --from-file=redis.conf
kubectl create -f pv.yaml
kubectl create -f pvc.yaml
kubectl create -f statefulset.yaml
kubectl create -f redis-access-service.yaml

查看redis需要的所有资源：
[user1@220-node k8s运行一个redis]$ k get po -o wide
NAME      READY   STATUS    RESTARTS   AGE   IP              NODE       NOMINATED NODE   READINESS GATES
redis-0   1/1     Running   0          94s   192.168.135.2   217-node   <none>           <none>

[user1@220-node k8s运行一个redis]$ k get pv -owide
NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE   VOLUMEMODE
nfs-pv1   200M       RWX            Retain           Bound    default/data-redis-0                           71m   Filesystem

[user1@220-node k8s运行一个redis]$ k get pvc -owide
NAME           STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE   VOLUMEMODE
data-redis-0   Bound    nfs-pv1   200M       RWX                           71m   Filesystem

[user1@220-node k8s运行一个redis]$ k get statefulset -owide
NAME    READY   AGE   CONTAINERS   IMAGES
redis   1/1     30m   redis-c      redis
[user1@220-node k8s运行一个redis]$ k get svc -owide
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE    SELECTOR
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   149m   <none>

[user1@220-node k8s运行一个redis]$ k get po -owide
NAME      READY   STATUS    RESTARTS   AGE   IP              NODE       NOMINATED NODE   READINESS GATES
redis-0   1/1     Running   0          30m   192.168.135.2   217-node   <none>           <none>

4. 宿主机的redis-cli命令连到集群中运行redis的pod的ip地址
集群内部，用pod的ip地址就可以连到k8s集群里的redis服务
[user1@220-node ~]$ k get po -owide
NAME      READY   STATUS    RESTARTS   AGE    IP              NODE       NOMINATED NODE   READINESS GATES
redis-0   1/1     Running   0          109s   192.168.135.2   217-node   <none>           <none>

[user1@220-node ~]$ cd /usr/local/redis/bin
[user1@220-node bin]$ ./redis-cli -h 192.168.135.2 -p 6379
192.168.135.2:6379> set a b
OK
