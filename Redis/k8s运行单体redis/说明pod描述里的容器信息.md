```gotemplate
Containers:
  redis-c:
    Container ID:  docker://1d8b210cc4ebdf13af101a5ae1dcea7864edc3188906efdb6dcc0d4fdd2246cb
    Image:         redis
    Image ID:      docker-pullable://redis@sha256:21b037b4f6964887bb12fd8d72d06c7ab1f231a58781b6ca2ceee0febfeb0d36
    Ports:         6379/TCP, 16379/TCP
    Host Ports:    0/TCP, 0/TCP
    Command:
      redis-server      # 容器启动后， 就运行的命令
    Args:                  # 上面命令的参数
      /etc/redis/redis.conf
      --protected-mode
      no
    State:          Running  # 当前容器状态
      Started:      Mon, 30 Dec 2019 23:07:35 +0800
    Ready:          True
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Environment:  <none>
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
    - name: "data"
      mountPath: "/var/lib/redis"

```
mountPath指定了容器里的目录，
name:指定了容器外部的资源， 这些资源必须在pod的yaml中volumes定义：
```
    volumes:
        - name: "redis-conf"
          configMap:
            name: "redis-conf"
            items:
              - key: "redis.conf"
                path: "redis.conf"
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: [ "ReadWriteMany" ]
        resources:
          requests:
            storage: 200M

```
