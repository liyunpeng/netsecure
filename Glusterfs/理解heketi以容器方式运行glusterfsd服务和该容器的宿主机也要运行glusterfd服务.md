这也是为heketi做的准备，准备一个glusterfsd服务
理解以容器方式运行glusterfsd服务和该容器的宿主机也要运行glusterfd服务
glusterfsd 服务的最终目的， 是接收heketi  server api 方式发来的命令， 然后在glusterfs集群里的目标硬盘分区上建立glusterfs文件系统。 
k8s 集群和 glusterfs集群是两个不同的集群， 但在k8s集群中的一些主机也可以在glusterfs集群
集群是软件上的概念，即多个主机运行相同的软件，这些软件彼此互联， 就可以构成一个集群
glusterfs是集群分布式文件系统， 这个集群的每台机器都需要运行glusterfsd服务， 但并不需要每台主机都要有个用于该文件系统的硬盘分区。举个例子：
```
$ sudo gluster volume create rep_vol replica 2 213-node:/data/brick1/rep 212-node:/data/brick1/rep force
```
运行这个命令的主机， 既不是213-node， 也不是212-node主机， 
所以k8s 采用在pod容器里运行glusterfsd服务， 容器所在的宿主机也要运行glusterfsd服务， 容器宿主机也要有个可供使用的裸硬盘分区

运行glusterfsd服务的容器定义文件glusterfs-daemonset.yaml具体内容：
```yaml
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: glusterfs
  labels:
    glusterfs: daemonset
  annotations:
    description: GlusterFS DaemonSet
    tags: glusterfs
spec:
  selector:
    matchLabels:
      glusterfs: pod
      app: filebeat
  template:
    metadata:
      name: glusterfs
      labels:
        app: filebeat
        glusterfs: pod
        glusterfs-node: pod
    spec:
      # 因为该pod必须运行在特定的主机上，所以定义node选择, 告诉调度器只能调度在标签为storagenode: glusterfs的主机node上
      # 这里没有对pod的数量限制，所以有这个标签node都会被调度上本pod
      nodeSelector:
        storagenode: glusterfs     
      # 容器的端口映射为主机的端口
      hostNetwork: true
      containers:
      - image: gluster/gluster-centos:latest
        name: glusterfs
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - name: glusterfs-heketi
          mountPath: "/var/lib/heketi"
        - name: glusterfs-run
          mountPath: "/run"
        - name: glusterfs-lvm
          mountPath: "/run/lvm"
        - name: glusterfs-etc
          mountPath: "/etc/glusterfs"
        - name: glusterfs-logs
          mountPath: "/var/log/glusterfs"
        - name: glusterfs-config
          mountPath: "/var/lib/glusterd"
        - name: glusterfs-dev
          mountPath: "/dev"
        - name: glusterfs-misc
          mountPath: "/var/lib/misc/glusterfsd"
        - name: glusterfs-cgroup
          mountPath: "/sys/fs/cgroup"
          readOnly: true
        - name: glusterfs-ssl
          mountPath: "/etc/ssl"
          readOnly: true
        securityContext:
          capabilities: {}
          privileged: true
        readinessProbe: # 容器是否可连接
          timeoutSeconds: 3
          initialDelaySeconds: 60
          exec:
            command:
            - "/bin/bash"
            - "-c"
            - systemctl status glusterd.service
        livenessProbe:     # 容器本身是否正常
          timeoutSeconds: 3
          initialDelaySeconds: 60
          exec:
            command:
            - "/bin/bash"
            - "-c"
            - systemctl status glusterd.service
      volumes:
      # hostpath 会在宿主机上也建立这些目录
      - name: glusterfs-heketi
        hostPath:
          path: "/var/lib/heketi"
      - name: glusterfs-run
      - name: glusterfs-lvm
        hostPath:
          path: "/run/lvm"
      - name: glusterfs-etc
        hostPath:
          path: "/etc/glusterfs"
      - name: glusterfs-logs
        hostPath:
          path: "/var/log/glusterfs"
      - name: glusterfs-config
        hostPath:
          path: "/var/lib/glusterd"
      - name: glusterfs-dev
        hostPath:
          path: "/dev"
      - name: glusterfs-misc
        hostPath:
          path: "/var/lib/misc/glusterfsd"
      - name: glusterfs-cgroup
        hostPath:
          path: "/sys/fs/cgroup"
      - name: glusterfs-ssl
        hostPath:
          path: "/etc/ssl"
```

如果宿主机上没有运行glusterfsd服务，容器会不停的重启。

```
[master@212-node glusterfs]$ k get po -owide
NAME                             READY   STATUS    RESTARTS   AGE     IP              NODE       NOMINATED NODE   READINESS GATES
glusterfs-pfqdr                  0/1     Running   56         3h33m   192.168.0.213   213-node   <none>           <none>
glusterfs-vhbgn                  1/1     Running   0          3h33m   192.168.0.217   217-node   <none>           <none>
```

glusterfs-pfqdr 重启了56次, 原因看一下describe:
```
[master@212-node glusterfs]$ kd po glusterfs-pfqdr
Name:         glusterfs-pfqdr
Namespace:    default
Priority:     0
Node:         213-node/192.168.0.213
Start Time:   Sat, 11 Jan 2020 12:54:35 +0800
Labels:       app=filebeat
              controller-revision-hash=84bb7bd44
              glusterfs=pod
              glusterfs-node=pod
              pod-template-generation=1
Annotations:  <none>
Status:       Running
IP:           192.168.0.213
IPs:
  IP:           192.168.0.213
Controlled By:  DaemonSet/glusterfs
Containers:
  glusterfs:
    Container ID:   docker://8df8f66e3798842ae4dcff0548297908f9a77cfaa7dab5fe3e33b0cf6264f15d
    Image:          gluster/gluster-centos:latest
    Image ID:       docker-pullable://gluster/gluster-centos@sha256:124e2b81c245af24e543d76606ed4983c7b6dfbbca7031b77bb53779fe1c04f2
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sat, 11 Jan 2020 16:26:59 +0800
    Last State:     Terminated
      Reason:       Error
      Exit Code:    137
      Started:      Sat, 11 Jan 2020 16:24:59 +0800
      Finished:     Sat, 11 Jan 2020 16:26:58 +0800
    Ready:          False
    Restart Count:  56
    Liveness:       exec [/bin/bash -c systemctl status glusterd.service] delay=60s timeout=3s period=10s #success=1 #failure=3
    Readiness:      exec [/bin/bash -c systemctl status glusterd.service] delay=60s timeout=3s period=10s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /dev from glusterfs-dev (rw)
      /etc/glusterfs from glusterfs-etc (rw)
      /etc/ssl from glusterfs-ssl (ro)
      /run from glusterfs-run (rw)
      /run/lvm from glusterfs-lvm (rw)
      /sys/fs/cgroup from glusterfs-cgroup (ro)
      /var/lib/glusterd from glusterfs-config (rw)
      /var/lib/heketi from glusterfs-heketi (rw)
      /var/lib/misc/glusterfsd from glusterfs-misc (rw)
      /var/log/glusterfs from glusterfs-logs (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-24p4w (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  glusterfs-heketi:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/heketi
    HostPathType:
  glusterfs-run:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  glusterfs-lvm:
    Type:          HostPath (bare host directory volume)
    Path:          /run/lvm
    HostPathType:
  glusterfs-etc:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/glusterfs
    HostPathType:
  glusterfs-logs:
    Type:          HostPath (bare host directory volume)
    Path:          /var/log/glusterfs
    HostPathType:
  glusterfs-config:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/glusterd
    HostPathType:
  glusterfs-dev:
    Type:          HostPath (bare host directory volume)
    Path:          /dev
    HostPathType:
  glusterfs-misc:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/misc/glusterfsd
    HostPathType:
  glusterfs-cgroup:
    Type:          HostPath (bare host directory volume)
    Path:          /sys/fs/cgroup
    HostPathType:
  glusterfs-ssl:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/ssl
    HostPathType:
  default-token-24p4w:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-24p4w
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  storagenode=glusterfs
Tolerations:     node.kubernetes.io/disk-pressure:NoSchedule
                 node.kubernetes.io/memory-pressure:NoSchedule
                 node.kubernetes.io/network-unavailable:NoSchedule
                 node.kubernetes.io/not-ready:NoExecute
                 node.kubernetes.io/pid-pressure:NoSchedule
                 node.kubernetes.io/unreachable:NoExecute
                 node.kubernetes.io/unschedulable:NoSchedule
Events:
  Type     Reason     Age                      From               Message
  ----     ------     ----                     ----               -------
  Normal   Pulled     48m (x45 over 3h30m)     kubelet, 213-node  Container image "gluster/gluster-centos:latest" already present on machine
  Warning  Unhealthy  8m42s (x485 over 3h29m)  kubelet, 213-node  (combined from similar events): Readiness probe failed: ● glusterd.service - GlusterFS, a clustered file-system server
   Loaded: loaded (/usr/lib/systemd/system/glusterd.service; enabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sat 2020-01-11 08:17:51 UTC; 1min 47s ago

Jan 11 08:17:49 213-node systemd[1]: Starting GlusterFS, a clustered file-system server...
Jan 11 08:17:51 213-node systemd[1]: glusterd.service: control process exited, code=exited status=1
Jan 11 08:17:51 213-node systemd[1]: Failed to start GlusterFS, a clustered file-system server.
Jan 11 08:17:51 213-node systemd[1]: Unit glusterd.service entered failed state.
Jan 11 08:17:51 213-node systemd[1]: glusterd.service failed.
  Warning  BackOff  3m34s (x477 over 176m)  kubelet, 213-node  Back-off restarting failed container
```

原因是213-node主机上没有启动glusterd.service服务
glusterfsd 有没有用在运行， 可以看进程， 也可以看服务
看进程：
```
[user9@217-node shell]$ ps -e | grep glus
 46711 ?        00:00:00 glusterd
```
有glusterd， 表示glusterfs服务在运行

看服务：
```
[user9@217-node shell]$ systemctl status glusterfsd
● glusterfsd.service - GlusterFS brick processes (stopping only)
   Loaded: loaded (/usr/lib/systemd/system/glusterfsd.service; disabled; vendor preset: disabled)
   Active: active (exited) since Sun 2020-01-12 01:17:39 EST; 55min ago
  Process: 29270 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
 Main PID: 29270 (code=exited, status=0/SUCCESS)
```
Active: active (exited) 表示服务glusterfsd在运行

node只有被label之后，调度器才会把pod调度在这个node上，因为damonset设置了nodeselector
```
[centos-8@216-node glusterfs]$ hostname
216-node
[centos-8@216-node glusterfs]$ kubectl label node 216-node  storagenode=glusterfs
node/216-node labeled
```

查看本机上的卷
```
[master@212-node k8s_yaml]$ sudo pvs
  PV         VG  Fmt  Attr PSize   PFree
  /dev/sda2  cl  lvm2 a--  <79.00g    0
  /dev/sdb1  vg0 lvm2 a--  <10.00g 4.98g
```