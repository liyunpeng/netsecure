标记node
```
[master@212-node k8s_yaml]$ kubectl label node 219-node  storagenode=glusterfs
```

主要作用是决定pod是否要调度到本node上

node 从集群删除后， 再重新加入集群， node之前的label也消失了, 如217-node之前有storagenode=glusterfs，删除之后再重新加入就没有了：
```
[master@212-node ~]$ kubectl get nodes --show-labels
NAME       STATUS   ROLES    AGE     VERSION   LABELS
212-node   Ready    master   26h     v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=212-node,kubernetes.io/os=linux,node-role.kubernetes.io/master=
213-node   Ready    <none>   6h15m   v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=213-node,kubernetes.io/os=linux
217-node   Ready    <none>   29m     v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=217-node,kubernetes.io/os=linux
219-node   Ready    <none>   21h     v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=219-node,kubernetes.io/os=linux,storagenode=glusterfs
220-node   Ready    <none>   5h28m   v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=220-node,kubernetes.io/os=linux
68-node    Ready    <none>   25h     v1.17.0   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=68-node,kubernetes.io/os=linux
```
一个node可以有多个标签，
所以213-node再次标记，并不会删除原标记， 所以运行在213-node上的pod删除后，下次启动的Pod还调度到这个node上：
```
[master@212-node k8s_yaml]$ kubectl label node 213-node  node=kube-node
[master@212-node k8s_yaml]$ kubectl get node  -l "node=kube-node"
NAME       STATUS   ROLES    AGE     VERSION
213-node   Ready    <none>   4h46m   v1.17.0
[master@212-node k8s_yaml]$ kubectl get node  -l "storagenode=glusterfs"
NAME       STATUS   ROLES    AGE     VERSION
213-node   Ready    <none>   4h47m   v1.17.0
217-node   Ready    <none>   4h45m   v1.17.0
219-node   Ready    <none>   12m     v1.17.0
```

删除一个node后， 还能看到有pod在这个node上，要过几分钟的时间，这个pod才会消失：
```
[master@212-node ~]$ k delete no 217-node
node "217-node" deleted
[master@212-node ~]$ k get po -owide
NAME                             READY   STATUS    RESTARTS   AGE   IP               NODE       NOMINATED NODE   READINESS GATES
deploy-heketi-65d9c564d6-48xkg   1/1     Running   1          16h   192.168.244.66   68-node    <none>           <none>
glusterfs-4p699                  0/1     Running   120        20h   192.168.0.219    219-node   <none>           <none>
glusterfs-vhbgn                  1/1     Running   1          24h   192.168.0.217    217-node   <none>           <none>
[master@212-node ~]$ k get po -owide
NAME                             READY   STATUS    RESTARTS   AGE   IP               NODE       NOMINATED NODE   READINESS GATES
deploy-heketi-65d9c564d6-48xkg   1/1     Running   1          16h   192.168.244.66   68-node    <none>           <none>
glusterfs-4p699                  0/1     Running   120        20h   192.168.0.219    219-node   <none>           <none>
glusterfs-vhbgn                  1/1     Running   1          24h   192.168.0.217    217-node   <none>           <none>

[master@212-node ~]$ k get po -owide
NAME                             READY   STATUS    RESTARTS   AGE   IP               NODE       NOMINATED NODE   READINESS GATES
deploy-heketi-65d9c564d6-48xkg   1/1     Running   1          16h   192.168.244.66   68-node    <none>           <none>
glusterfs-4p699                  0/1     Running   120        20h   192.168.0.219    219-node   <none>           <none>
```