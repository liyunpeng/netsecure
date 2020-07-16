# 集群版本的force-remote-worker的大页内存配置方法

# 内存延迟问题一些可能的解决方案的执行

Date: 2020/05/11

[TOC]


### 一: 修改传统巨页大小至 1GB

确认自己的硬件是否支持 1G 的页表:

```bash 
$ lscpu | grep pdpe1gb

基本上目前的机器都支持 pdpe1gb
```

更改内核启动时默认为1G巨页

```
grubby --update-kernel=ALL --args="hugepagesz=1G default_hugepagesz=1G"

reboot

重启生效
```

查看当前的传统巨页大小是否为1G:

```
$ cat /proc/meminfo | grep Hugepagesize

```

如要关闭：恢复默认设置
```
sudo grubby --update-kernel=ALL --remove-args="hugepages hugepagesz default_hugepagesz"

```

### 二: 关闭透明巨页

```bash
$ echo "never" > /sys/kernel/mm/transparent_hugepage/enabled

$ cat /sys/kernel/mm/transparent_hugepage/enabled
```
如果返回 如下输出则说明透明巨页的特性被关闭了
always madvise [never]

该方法在重启之后失效

永久有效方法

通过修改 `/boot/grub2/grub.cfg` 里面的内核启动参数来禁止（加上内核启动参数 `transparent_hugepage=never`）

也可以通过 相同的命令开启透明巨页

```bash
$ echo "always" > /sys/kernel/mm/transparent_hugepage/enabled
```


### 三: 预分配传统巨页内存

查看当前已分配的小页内存页数:
    
```bash
$ cat /proc/meminfo | grep PageTables
```

查看当前的已分配的传统巨页内存:

```bash 
   
    cat /proc/meminfo | grep HugePages_Total
    # 或者
    cat /proc/sys/vm/nr_hugepages
```

如果传统巨页数量为 0 ，则说明传统巨页没有启用。

通过运行时来设定传统巨页数量:

```bash 
# 内存总量 / 传统巨页大小 = 传统巨页页数
# 如 打算 500 内存全部使用 巨页来管理，在巨页大小为 1GB 的情况下，那就是总共能够容纳  500 页。
# 但是我们需要预留给系统一定的运行内存的空间

设置页数命令

echo 400 > /proc/sys/vm/nr_hugepages

```

集群实际运用中所需大小的计算：


```

P1阶段的内存消耗分为两个部分

部分一：64G的layer文件占用内存,该部分使用大页内存

部分二：56G的parents.cache文件，该部分使用公共内存

假设运行3个P1任务的内存计算方式

64 * 3 = 192G ～ 200G （大页内存部分）

这里大页内存需要设置 200 页

并且预留 56G空间给 parents.cache使用

```


挂载大页内存
```

mkdir -p /mnt/huge/

mount -t hugetlbfs -o mode=0777,pagesize=1G none /mnt/huge/
```

* 注意：
1.这里设置内存巨页之后会直接占用设置量大小的内存，对于系统而言这些内存时已经被使用的内存，是无法被使用的。

2.内存大页使用之后的内存系统和应用都是无法使用的，当留给系统4G内存的时候会导致系统没有足够的内存运行，导致机器卡死，无法启动的情况，切记，切记！！！

```
设置完成之后再次查看内存

$ free -h
              total        used        free      shared  buff/cache   available
Mem:           503G        483G         19G         10M        832M         17G
Swap:            0B          0B          0B

```
此时我们查看到内存已经被使用了483G，表示大页内存预分配设置成功

这里也可以通过相同的命令来关闭或者调整预分配内存的页数

```bash
echo 0 > /proc/sys/vm/nr_hugepages
```

### 四: force-remote-worker启动时使用大页内存

运行时通过设置环境变量的方式使用大页内存

```
FORCE_HUGE_PAGE=1 开启巨页内存

FIL_PROOFS_HUGEPAGE_MOUNT=/mnt/huge/ 巨页内存的挂载目录  default: /mnt/huge/

```

注意：该环境变量只针对P1阶段生效












