### lotus-server启动签的准备 

检查所有挂在点：
```
root@yangzhou010010019017 fil]# df -h
文件系统        容量  已用  可用 已用% 挂载点
/dev/sda2       2.0T   93G  2.0T    5% /
devtmpfs         63G     0   63G    0% /dev
tmpfs            63G     0   63G    0% /dev/shm
tmpfs            63G  818M   63G    2% /run
tmpfs            63G     0   63G    0% /sys/fs/cgroup
/dev/sda1      1014M  127M  888M   13% /boot
tmpfs            63G   12K   63G    1% /var/lib/kubelet/pods/62e5b3d7-53a8-4e6f-ac34-ab536be25ea2/volumes/kubernetes.io~secret/default-token-jbj6d
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/113ad712394904013f5c02216d0d8debd465bb1cfc102511864d76ccb7c3606a/merged
shm              64M     0   64M    0% /var/lib/docker/containers/d78cd26c6125ba04748c4201e38fec61decb56699282bc3c4953d0b100acf34b/mounts/shm
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/6a223d4ff6930ff19317e4ed5dbfc3460a300657e228a307cd0118719f65c76b/merged
tmpfs            13G     0   13G    0% /run/user/0
tmpfs            63G   12K   63G    1% /var/lib/kubelet/pods/96595a99-28af-41b4-a28c-1ed683e57575/volumes/kubernetes.io~secret/default-token-62shh
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/118a85960d400fd1c4213ce17ddc821839b2f15d89fa13d38c245294423ac502/merged
shm              64M     0   64M    0% /var/lib/docker/containers/5717cf2b70e20b83dbcf68f297bfc1392011b3b58d0f57c0a973f1f86aa34599/mounts/shm
overlay         2.0T   93G  2.0T    5% /var/lib/docker/overlay2/95cb42c1924211e42bde298635caa68862c9589404abe07022e2ab002535e7cf/merged
```

递归盖面nfs目录下所有文件的属主
```
[root@yangzhou010010019017 mnt]# chown -R fil:fil nfs
[root@yangzhou010010019017 mnt]# chmod -R 777 nfs/
```

查看新的挂载点：
```
[root@yangzhou010010019017 ~]# mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.4.23:/mnt/storage  /mnt/nfs/10.10.4.23^c

[root@yangzhou010010019017 mnt]# df -h
文件系统                 容量  已用  可用 已用% 挂载点
/dev/sda2                2.0T   93G  2.0T    5% /
devtmpfs                  63G     0   63G    0% /dev
tmpfs                     63G     0   63G    0% /dev/shm
{
tmpfs                     63G  818M   63G    2% /run
tmpfs                     63G     0   63G    0% /sys/fs/cgroup
/dev/sda1               1014M  127M  888M   13% /boot
tmpfs                     63G   12K   63G    1% /var/lib/kubelet/pods/62e5b3d7-53a8-4e6f-ac34-ab536be25ea2/volumes/kubernetes.io~secret/default-token-jbj6d
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/113ad712394904013f5c02216d0d8debd465bb1cfc102511864d76ccb7c3606a/merged
shm                       64M     0   64M    0% /var/lib/docker/containers/d78cd26c6125ba04748c4201e38fec61decb56699282bc3c4953d0b100acf34b/mounts/shm
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/6a223d4ff6930ff19317e4ed5dbfc3460a300657e228a307cd0118719f65c76b/merged
tmpfs                     13G     0   13G    0% /run/user/0
tmpfs                     63G   12K   63G    1% /var/lib/kubelet/pods/96595a99-28af-41b4-a28c-1ed683e57575/volumes/kubernetes.io~secret/default-token-62shh
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/118a85960d400fd1c4213ce17ddc821839b2f15d89fa13d38c245294423ac502/merged
shm                       64M     0   64M    0% /var/lib/docker/containers/5717cf2b70e20b83dbcf68f297bfc1392011b3b58d0f57c0a973f1f86aa34599/mounts/shm
overlay                  2.0T   93G  2.0T    5% /var/lib/docker/overlay2/95cb42c1924211e42bde298635caa68862c9589404abe07022e2ab002535e7cf/merged
10.10.4.23:/mnt/storage  160T  273G  152T    1% /mnt/nfs/10.10.4.23

[root@yangzhou010010019017 mnt]# cd nfs/10.10.4.23/

[root@yangzhou010010019017 10.10.4.23]# ll
总用量 40
drwxrwxr-x 537 fil fil 20480 6月  13 14:00 cache
drwxrwxr-x   2 fil fil 20480 6月  13 14:00 sealed
root@yangzhou010010019017 fil]# vi config.json
```

开机挂在， 就在rc.local中加：
```
root@yangzhou010010019017 ~]# cat /etc/rc.local
```

测试数据库联通：
```gotemplate
[root@yangzhou010010019017 fil]# telnet 10.10.19.15 3306
Trying 10.10.19.15...
Connected to 10.10.19.15.
Escape character is '^]'.
J
5.7.30
```

config.json 中修改数据库
[root@yangzhou010010019017 fil]# vi Config.json

config.json由lotus读取
```
[root@yangzhou010010019017 fil]# vi config.json
```

表中添加记录行：


fil@yangzhou010010019017 ~]$ nohup ./lotus-server >lotus-server.log 2>&1 &
[1] 33250

fil@yangzhou010010019017 ~]$ ./lotus sync status
2020-06-13T15:05:39.909+0800	WARN	main	could not get API info:
    github.com/filecoin-project/lotus/cli.GetRawAPI
        /builds/ForceMining/lotus-force/cli/cmd.go:151
  - could not get api endpoint:
    github.com/filecoin-project/lotus/cli.GetAPIInfo
        /builds/ForceMining/lotus-force/cli/cmd.go:134
  - API not running (no endpoint)
fil@yangzhou010010019017 filecoin-proof-parameters]$ ls
scp.log
v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.vk
v26-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.vk
v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.vk
v26-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.params


