### 硬件要求
cpu 8 核 amd 架构



### /usr/bin/ld: cannot find -lhwloc 解决办法
![-w572](media/16113923041331.jpg)

解决：
![-w560](media/16113923391766.jpg)


###  centos-安装阿里云的源

文章标签： 运维
版权
查看版本
cat /etc/issue
备份源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
获取源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo 
各版本对应地址:

CentOS 5 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo
CentOS 6 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
CentOS 7 : wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
更新源缓存
清除历史数据

yum clean all

更新最新缓存

yum makecache

### 解决openCl 链接不到的问题

[root@iZuf664ztcz8m5wzm0b0tyZ /]# find -name "*OpenC*"
./opt/intel/opencl/libOpenCL.so
./opt/intel/opencl/libOpenCL.so.1
./opt/intel/opencl/OpenCL.pc
[root@iZuf664ztcz8m5wzm0b0tyZ /]# ln -s /opt/intel/opencl/libOpenCL.so /usr/lib/libOpenCL.so


### sync wait 期间， ./lotus 大小递减
![-w400](media/16128378666146.jpg)


![-w358](media/16128381018408.jpg)


### 下载证明参数文件，速度很快
![-w1706](media/16128385027265.jpg)


### lotus 同步时， .lotus会一会变多， 一会变少

```
# For mainnet only:
lotus daemon --import-snapshot https://fil-chain-snapshots-fallback.s3.amazonaws.com/mainnet/minimal_finality_stateroots_latest.car
```
![-w348](media/16128661532011.jpg)


