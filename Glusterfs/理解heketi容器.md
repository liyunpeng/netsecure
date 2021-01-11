有了三台主机的准备， 和glusterfs容器的部署， 两个条件准备好了后， 就可以创建运行heketi的pod了.

1. 创建heketi的svc, deploy, pod三合一的yaml文件：heketi-deployment-svc.yaml：

```yaml
kind: Service
apiVersion: v1
metadata:
  name: deploy-heketi
  labels:
    glusterfs: heketi-service
    deploy-heketi: support
  annotations:
    description: Exposes Heketi Service
spec:
  selector:
    name: deploy-heketi
  ports:
  - name: deploy-heketi
    port: 8080
    targetPort: 8080
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: deploy-heketi
  labels:
    glusterfs: heketi-deployment
    deploy-heketi: heket-deployment
  annotations:
    description: Defines how to deploy Heketi
spec:
  replicas: 1
  selector:
    matchLabels:
      glusterfs: heketi-pod
 
  template:
    metadata:
      name: deploy-heketi
      labels:
        glusterfs: heketi-pod
        name: deploy-heketi
    spec:
      serviceAccountName: heketi-service-account    独有的serviceAccount, 没有用默认的名为default的serviceAccount
      containers:
      - image: heketi/heketi
        imagePullPolicy: IfNotPresent
        name: deploy-heketi
        env:
        - name: HEKETI_EXECUTOR
          value: kubernetes
        - name: HEKETI_FSTAB
          value: "/var/lib/heketi/fstab"
        - name: HEKETI_SNAPSHOT_LIMIT
          value: '14'
        - name: HEKETI_KUBE_GLUSTER_DAEMONSET
          value: "y"
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: db
          mountPath: "/var/lib/heketi"
        readinessProbe:
          timeoutSeconds: 3
          initialDelaySeconds: 3
          httpGet:
            path: "/hello"
            port: 8080
        livenessProbe:
          timeoutSeconds: 3
          initialDelaySeconds: 30
          httpGet:
            path: "/hello"
            port: 8080
      volumes:
      - name: db
        hostPath:
          path: "/heketi-data"
```
创建该pod:
[master@212-node ~]$k apply -f heketi-deployment-svc.yaml

[master@212-node ~]$ k get po -owide
NAME                             READY   STATUS    RESTARTS   AGE    IP               NODE       NOMINATED NODE   READINESS GATES
deploy-heketi-65d9c564d6-48xkg   1/1     Running   1          20h    192.168.244.66   68-node    <none>           <none>
glusterfs-jhxhp                  1/1     Running   0          3h6m   192.168.0.217    217-node   <none>           <none>

进入容器, 需要完成两个动作：(1)在容器中创建heketi的自定义拓扑文件.  (2) heketi_cli按拓扑文件描述加载硬盘分区
$k exec -it deploy-heketi-65d9c564d6-48xkg bash
(1) 在容器中创建heketi的自定义拓扑文件，内容：
[root@deploy-heketi-65d9c564d6-48xkg /]# cat /etc/heketi/
```json
heketi_topology.json
{
  "clusters": [
    {
      "nodes": [
        {
          "node": {
            "hostnames": {
              "manage": [
                "217-node"
              ],
              "storage": [
                "192.168.0.217"
              ]
            },
            "zone": 1
          },
          "devices": [
            "/dev/sdb1"
          ]
        }
      ]
    }
  ]
}
```
(2) 执行heketi_cli命令，按创建好的拓扑文件描述加载硬盘分区
[root@deploy-heketi-65d9c564d6-48xkg /]# heketi-cli topology load --json=/etc/heketi/heketi_topology.json

遇到了两个问题：
（1） 硬盘分区必须是裸设备，没有建立过任何文件系统的
     heketi管理的硬盘必须是裸硬盘，如果硬盘是windows上虚拟机添加的，磁盘上会有一些windows的信息， 会报如下错误：
```
[root@deploy-heketi-65d9c564d6-48xkg /]# heketi-cli topology load --json=/etc/heketi/heketi_topology.json
        Found node 217-node on cluster 212c86092693f25bf70a5cfce293eb27
                Adding device /dev/sdb ...
Unable to add device: Setup of device /dev/sdb failed (already initialized or contains data?):   WARNING: Failed to connect to lvmetad. Falling back to device scanning.
  WARNING: Device /dev/sda not initialized in udev database even after waiting 10000000 microseconds.
WARNING: dos signature detected on /dev/sdb at offset 510. Wipe it? [y/n]: [n]
  Aborted wiping of dos.
  1 existing signature left on the device.
```
这个问题的解决办法，在linux操作系统上， 用fdisk /dev/sdb,  选项均默认，在/dev/sdb磁盘设备上 建立分区/dev/sdb1

（2）容器缺少权限
第一个问题解决后，加载分区时，还会遇到
[root@deploy-heketi-65d9c564d6-48xkg /]# heketi-cli topology load --json=/etc/heketi/heketi_topology.json
提示nospace 错误
  实际并不是nospace，而是运行heketi的pod没有权限，
  解决办法：创建一个角色，把角色绑定给heketi pod的serviceaccount，即为这个pod授权
  ：
```
# 创建角色
  [master@212-node ~]$ k create clusterrole foo --verb=get,list,watch --resource=pods,pods/status,pods/exec

 # 查看角色：
  [master@212-node ~]$ kd clusterrole foo
Name:         foo
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources    Non-Resource URLs  Resource Names  Verbs
  ---------    -----------------  --------------  -----
  pods/exec    []                 []              [get list watch create]
  pods/status  []                 []              [get list watch create]
  pods         []                 []              [get list watch create]
```
  将创建好的角色绑定给serviceAccount, 达到授权的目的：
  创建一个集群角色绑定，即将集群角色foo绑定到指定的serviceaccount,  servicecount只存在于一个namespace中, 不能像角色一样全局存在，所以servicecount要带上namespace名字，构成全名，这里heketi pod所用的serviceaccount的全名就default:heketi-service-account 
```
[master@212-node ~]$ k create clusterrolebinding my-ca-view --clusterrole=foo --serviceaccount=default:heketi-service-account --namespace=default
clusterrolebinding.rbac.authorization.k8s.io/my-ca-view created
```

重新回hekekti pod容器内部，执行heketi-cli加载分区的命令：
```
[root@deploy-heketi-65d9c564d6-48xkg /]# heketi-cli topology load --json=/etc/heketi/heketi_topology.json
        Found node 217-node on cluster 212c86092693f25bf70a5cfce293eb27
                Adding device /dev/sdb1 ... OK    # 有几分钟的耗时
```

heketi加载硬盘分区成功后， 可以查看拓扑信息，可以看到自定义拓扑文件指定的分区：
```
[root@deploy-heketi-65d9c564d6-48xkg /]# heketi-cli topology info
Cluster Id: 212c86092693f25bf70a5cfce293eb27
    File:  true
    Block: true
    Volumes:
    Nodes:
        Node Id: db7b2cdc2a770dd622674ecb2df13044
        State: online
        Cluster Id: 212c86092693f25bf70a5cfce293eb27
        Zone: 1
        Management Hostnames: 217-node
        Storage Hostnames: 192.168.0.217
        Devices:
                Id:116a025287fa349844aca4a34c6e902e   Name:/dev/sdb1           State:online    Size (GiB):19      Used (GiB):0       Free (GiB):19
                        Bricks:
```
heketi pod成功加载硬盘分区后，就可以用pvc自动的在这个硬盘分区上动态创建
4.  创建一个pvc
master@212-node k8s_yaml]$ k get pvc
NAME                  STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS      AGE
pvc-gluster-heketi    Pending                                      gluster-heketi    7m11s

[master@212-node k8s_yaml]$ kd pvc pvc-gluster-heketi
Name:          pvc-gluster-heketi
Namespace:     default
StorageClass:  gluster-heketi
Status:        Pending
Volume:
Labels:        <none>
Annotations:   kubectl.kubernetes.io/last-applied-configuration:
                 {"apiVersion":"v1","kind":"PersistentVolumeClaim","metadata":{"annotations":{},"name":"pvc-gluster-heketi","namespace":"default"},"spec":{...
               volume.beta.kubernetes.io/storage-provisioner: kubernetes.io/glusterfs
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:
Access Modes:
VolumeMode:    Filesystem
Mounted By:    <none>
Events:
  Type     Reason              Age                  From                         Message
  ----     ------              ----                 ----                         -------
  Warning  ProvisioningFailed  2m5s (x12 over 12m)  persistentvolume-controller  Failed to provision volume with StorageClass "gluster-heketi": failed to create volume: failed to create volume: Post http://192.168.0.217:8080/volumes: dial tcp 192.168.0.217:8080: connect: connection refused
[master@212-node k8s_yaml]$ kd pvc pvc-glustera-heketi
Name:          pvc-glustera-heketi
Namespace:     default
StorageClass:  glustera-heketi
Status:        Pending
Volume:
Labels:        <none>
Annotations:   kubectl.kubernetes.io/last-applied-configuration:
                 {"apiVersion":"v1","kind":"PersistentVolumeClaim","metadata":{"annotations":{},"name":"pvc-glustera-heketi","namespace":"default"},"spec":...
               volume.beta.kubernetes.io/storage-provisioner: kubernetes.io/glusterfs
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:
Access Modes:
VolumeMode:    Filesystem
Mounted By:    <none>
Events:
  Type     Reason              Age                  From                         Message
  ----     ------              ----                 ----                         -------
  Warning  ProvisioningFailed  14s (x10 over 6m9s)  persistentvolume-controller  Failed to provision volume with StorageClass "glustera-heketi": failed to create volume: failed to create volume: Post http://192.168.0.212:8080/volumes: dial tcp 192.168.0.212:8080: connect: connection refused

[master@212-node k8s_yaml]$ k get pv
No resources found in default namespace.
