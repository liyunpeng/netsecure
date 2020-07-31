## 7742 * 2  机器上的p1 p2 p3编排
7742 * 2 型号的机器共有128核。 
128 核的划分
四个容器， 每个容器跑一个p1,   四个容器跑p2 p3, 每个容器跑一个p2一个p3。   一组p1 p2 p3 对应一个cache存储， 所以有4个cache存储。   
共享存储 为/mnt/fsqlv ， 存放证明参数和p3 cache


p1 p2 核数及耗时
{
	"p1hourtime": 2.34,
	"p1core" : 2,
	"p2hourtime": 2.15,
	"p2core" :  23
}

单机存储吞吐量
/dev/sdb	 480MB/s
/dev/sdc	480MB/s
/dev/sdd	480MB/s
/dev/sde	480MB/s

共享存储吞吐量：
10.0.0.5:/fsqlv	772MB/s

存储编排：




64 核机器划分： 三个容器， 一个容器跑一个p4. 


## 7551 * 2 机器上的P4 编排