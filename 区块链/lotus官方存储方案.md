

### miner
[root@miner ~]# mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 192.168.0.2:/storage  /storage

[root@miner ~]# mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 192.168.0.2:/sealer  /sealer/

### nfs 开机挂在
不能在/etc/fstab, 因为网络还没有好， 要在 /etc/rc.d/rc.local添加
mount -t nfs 192.168.0.145:/storage /storage


log 里显示的的对余额表balance 的update 语句的余额增加的汇总， 记录总和与 对转账表currency_transfer 的记录金额的汇总相等， 程序上对数据库的更新是正确的， 但实际上额度表的值比转账表的值少了82.28493， 通过对每个用户的校验， 发现这个差值正好是18551175678 的用户所缺少的当天的收益分配。  
检查了收益分配逻辑代码， 对余额表的更新和转账表的增加， 是放在一个事务里的，没有问题。目前推测，数据库没有正常完成更新操作， 但数据库目前的日志缺乏，看不到更新语句的日志， 后续需要研究一下如何获取到数据库日志。 

