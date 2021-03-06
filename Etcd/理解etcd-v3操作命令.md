
判断etcd 是否运行正常， 不能用ps -e | grep etcd 看到结果有etcd不代表运行正常，
要用systemctl status
```
[user1@141-node ~]$ sudo systemctl status etcd
  etcd.service - etcd key-value store
   Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-01-20 22:09:29 EST; 8s ago
     Docs: https://github.com/etcd-io/etcd
 Main PID: 33532 (etcd)
    Tasks: 12 (limit: 23857)
   Memory: 11.2M
   CGroup: /system.slice/etcd.service
           └─33532 /usr/local/bin/etcd --name etcd0 --data-dir /data/etcd --initial-advertise-peer-urls http://192.168.0.141:2380 --list>

1月 20 22:09:29 141-node etcd[33532]: efad2f9e7a8a10a8 became candidate at term 6
1月 20 22:09:29 141-node etcd[33532]: efad2f9e7a8a10a8 received MsgVoteResp from efad2f9e7a8a10a8 at term 6
1月 20 22:09:29 141-node etcd[33532]: efad2f9e7a8a10a8 became leader at term 6
1月 20 22:09:29 141-node etcd[33532]: raft.node: efad2f9e7a8a10a8 elected leader efad2f9e7a8a10a8 at term 6
1月 20 22:09:29 141-node etcd[33532]: ready to serve client requests
1月 20 22:09:29 141-node etcd[33532]: serving insecure client requests on 127.0.0.1:2379, this is strongly discouraged!
1月 20 22:09:29 141-node etcd[33532]: published {Name:etcd0 ClientURLs:[http://192.168.0.141:2379]} to cluster f5e7a77b0043ff40
1月 20 22:09:29 141-node etcd[33532]: ready to serve client requests
1月 20 22:09:29 141-node etcd[33532]: serving insecure client requests on 192.168.0.141:2379, this is strongly discouraged!
1月 20 22:09:29 141-node systemd[1]: Started etcd key-value store.
```

尽量把服务配置成systemctl控制的，即收纳与服务控制器管理之下
可以统一查看和管理服务状态，服务配置文件指定，需要的环境变量，开机自启动服务
systemctl实际是 system service controller的缩写，符合控制器思想，
像K8s里的pod控制器，负责专门管理pod， 负责pod的的启停，数量控制，调度等维护
这里的服务控制器，也是这个思想。

etcd 3.0 的etcdclt默认方式也是evcd2.0方式的， 要用etcd v3方式的，必须设置好环境变量ETCDCTL_API
```
$ export ETCDCTL_API=3

[user1@141-node ~]$ etcdctl put key1 value1
OK
[user1@141-node ~]$ etcdctl get key1
key1
value1

[user1@141-node ~]$ etcdctl put /a/b/c 123
OK
[user1@141-node ~]$ etcdctl get /a/b/c
/a/b/c
123
```

上面是用命令方式设置key的方式，也可以用程序方式设置：
import client "go.etcd.io/etcd/clientv3"  设置好etcd clientv3的别名
```golang
etcdClient, _ := client.New(client.Config{
    Endpoints:   addrs,
    DialTimeout: timeout,
})
kv := client.NewKV(etcdClient)
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
_, err := e.EtcdKV.Put(ctx, key, value) //withPrevKV()是为了获取操作前已经有的key-value
if err != nil {
    panic(err)
}
```
程序设置的key，可以通过命令查询到。
如果不设置这个环境变量ETCDCTL_API， 显示无这个key：
```
$ etcdctl get /logagent/192.168.0.142/logconfig
Error:  100: Key not found (/logagent) [8]

$ export ETCDCTL_API=3
$ etcdctl get /logagent/192.168.0.142/logconfig
[user1@141-node ~]$ etcdctl get /logagent/192.168.0.142/logconfig
/logagent/192.168.0.142/logconfig
D:\1.txt
```
