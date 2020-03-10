master@etcd0:~/k8s/pv$ kubectl create -f mypv.yaml
master@etcd0:~/k8s/pv$  kubectl  get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv001   5Gi        RWX            Retain           Available                                   5s

master@etcd0:~/k8s/pv$ kubectl create -f mypvc.yaml
master@etcd0:~/k8s/pv$ kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   REASON   AGE
pv001   5Gi        RWX            Retain           Bound    default/myclaim                           95s


master@etcd0:~/k8s/pv$ kubectl create -f  mysql-svr-deployment.yaml
master@etcd0:~/k8s/pv$ kubectl get pod
NAME                     READY   STATUS              RESTARTS   AGE
mysql-54b8c5d79f-tb646   0/1     ContainerCreating   0          19m

master@etcd0:~/k8s/pv$ kubectl describe pod mysql-54b8c5d79f-tb646
Name:           mysql-54b8c5d79f-tb646
Namespace:      default
Priority:       0
Node:           etcd0/192.168.0.204
Start Time:     Thu, 19 Dec 2019 21:48:58 +0800
Labels:         app=mysql
                pod-template-hash=54b8c5d79f
Annotations:    cni.projectcalico.org/podIP: 192.169.0.19/32
Status:         Pending
IP:
Controlled By:  ReplicaSet/mysql-54b8c5d79f
Containers:
  mysql:
    Container ID:
    Image:          mysql:5.6
    Image ID:
    Port:           3306/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Environment:
      MYSQL_ROOT_PASSWORD:  password
    Mounts:
      /var/lib/mysql from mysql-persistent-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-ck48w (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  mysql-persistent-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  myclaim
    ReadOnly:   false
  default-token-ck48w:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-ck48w
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  7m41s  default-scheduler  Successfully assigned default/mysql-54b8c5d79f-tb646 to etcd0
  Normal  Pulling    7m40s  kubelet, etcd0     Pulling image "mysql:5.6"


master@etcd0:~/k8s/pv$ kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
mysql-54b8c5d79f-tb646   1/1     Running   0          29m


master@etcd0:~/k8s/pv$  kubectl describe pod mysql-54b8c5d79f-tb646
Name:           mysql-54b8c5d79f-tb646
Namespace:      default
Priority:       0
Node:           etcd0/192.168.0.204
Start Time:     Thu, 19 Dec 2019 21:48:58 +0800
Labels:         app=mysql
                pod-template-hash=54b8c5d79f
Annotations:    cni.projectcalico.org/podIP: 192.169.0.19/32
Status:         Running
IP:             192.169.0.19
Controlled By:  ReplicaSet/mysql-54b8c5d79f
Containers:
  mysql:
    Container ID:   docker://9c08786d5144037f2e7d254a15d19777d48add973c2d9dc15de173eb3d6c5128
    Image:          mysql:5.6
    Image ID:       docker-pullable://mysql@sha256:5345afaaf1712e60bbc4d9ef32cc62acf41e4160584142f8d73115f16ad94af4
    Port:           3306/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 19 Dec 2019 22:09:27 +0800
    Ready:          True
    Restart Count:  0
    Environment:
      MYSQL_ROOT_PASSWORD:  password
    Mounts:
      /var/lib/mysql from mysql-persistent-storage (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-ck48w (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  mysql-persistent-storage:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  myclaim
    ReadOnly:   false
  default-token-ck48w:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-ck48w
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  38m   default-scheduler  Successfully assigned default/mysql-54b8c5d79f-tb646 to etcd0
  Normal  Pulling    38m   kubelet, etcd0     Pulling image "mysql:5.6"
  Normal  Pulled     18m   kubelet, etcd0     Successfully pulled image "mysql:5.6"
  Normal  Created    18m   kubelet, etcd0     Created container mysql
  Normal  Started    18m   kubelet, etcd0     Started container mysql

master@etcd0:~/k8s/pv$ kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword
If you don't see a command prompt, try pressing enter.
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

master@etcd0:~/k8s/pv$ kubectl get service
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    24h
mysql        ClusterIP   10.96.173.212   <none>        3306/TCP   30m

数据落盘：
到网络文件系统可以看到k8s中的mysql服务在此创建的文件：
master@etcd0:/nfs$ ll
total 110612
drwxrwxrwx  4 logstash master     4096 Dec 19 22:21 ./
drwxr-xr-x 26 root     root       4096 Dec 17 22:10 ../
-rw-rw----  1 logstash docker       56 Dec 19 22:09 auto.cnf
-rw-rw----  1 logstash docker 12582912 Dec 19 22:09 ibdata1
-rw-rw----  1 logstash docker 50331648 Dec 19 22:09 ib_logfile0
-rw-rw----  1 logstash docker 50331648 Dec 19 22:09 ib_logfile1
drwx------  2 logstash docker     4096 Dec 19 22:09 mysql/
drwx------  2 logstash docker     4096 Dec 19 22:09 performance_schema/

