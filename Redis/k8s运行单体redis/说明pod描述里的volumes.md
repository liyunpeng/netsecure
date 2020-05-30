

## voluems组描述了本pod使用的所有外部资源
```gotemplate

Volumes:
  data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  data-redis-0
    ReadOnly:   false
  redis-conf:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      redis-conf
    Optional:  false
  default-token-x5g8r:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-x5g8r
    Optional:    false

```
所有pod要使用的外部数据， 都要通过volume挂载到pod， 有三种类型的外部数据：

### 1. 持久化卷
描述信息：

```
  data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  data-redis-0
    ReadOnly:   false

```
这个就是该pod使用的pvc了， 对应的pod yaml文件中的定义：

```
        volumeMounts:
            - name: "data"
              mountPath: "/var/lib/redis"
    volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: [ "ReadWriteMany" ]
        resources:
          requests:
            storage: 200M    

```
volumeClaimTemplates里的名字会和当前pod的名字以及pod在集群里的序号，自动组合出pvc的名字， 
这里组合出的pvc的名字就是data-redis-0. 
这个名字正好符合pvc yaml中的名字定义： 
```

apiVersion: v1
 kind: PersistentVolumeClaim
 metadata:
   name: data-redis-0
 spec:
   accessModes:
     - ReadWriteMany
   resources:
     requests:
       storage: 200M

```
2. 配置资源
描述信息：

```
redis-conf:
  Type:      ConfigMap (a volume populated by a ConfigMap)
  Name:      redis-conf
  Optional:  false
```
对应 pod里的 yaml 文件中的定义：

```
volumeMounts:
  - name: "redis-conf"
    mountPath: "/etc/redis"
volumes:
  - name: "redis-conf"
    configMap:
      name: "redis-conf"
      items:
        - key: "redis.conf"
          path: "redis.conf"

```
3. 身份tokern
描述信息：

```
default-token-x5g8r:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-x5g8r
    Optional:    false
```
这个token，pod yaml文件没有定义，自动生成


## mounts组描述了外部资源挂载到容器的哪个目录
```
    Mounts:
      /etc/redis from redis-conf (rw)
      /var/lib/redis from data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-x5g8r (ro)
```
Mounts: 描述了容器外部的资源挂载到了容器里的哪些目录 
```
      /etc/redis from redis-conf (rw)
      /var/lib/redis from data (rw)
```
这部分对应的pod的yaml文件的定义：
```
  volumeMounts:
    - name: "redis-conf"
      mountPath: "/etc/redis"  这是容器中的目录，即指定名叫redis-conf的资源挂载到容器中的/etc/hosts目录
    - name: "data"  对应的实际资源名为data-redis-0
      mountPath: "/var/lib/redis"

```

name:指定了容器外部的资源，是volume中描述的，这些资源必须在pod的yaml中volumes定义：
mountPath指定了容器里的目录，
