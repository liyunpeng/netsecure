centos7升级gcc版本,无需手动下载源码编译

wudskq 2020-10-07 15:37:08  3281  收藏 12
分类专栏： Linux 文章标签： centos7 linux 升级gcc
版权
centos7升级gcc版本,无需手动下载源码编译
第一步: 安装centos-release-scl
第二步: 安装devtoolset
第三步: 激活对应的devtoolset
第四步: 查看版本
注意事项:gcc如果没有切换只对本次会话有效
1.切换gcc版本
2.直接替换旧的gcc
Centos 7默认gcc版本为4.8，有时需要更高版本的，这里以升级至8.3.1版本为例，分别执行下面三条命令即可，无需手动下载源码编译

第一步: 安装centos-release-scl
安装centos-release-scl

sudo yum install centos-release-scl
1
第二步: 安装devtoolset
注意事项，如果想安装7.版本的，就改成devtoolset-7-gcc，以此类推

sudo yum install devtoolset-8-gcc*
1
第三步: 激活对应的devtoolset
所以你可以一次安装多个版本的devtoolset，需要的时候用下面这条命令切换到对应的版本

scl enable devtoolset-8 bash
1
第四步: 查看版本
大功告成，查看一下gcc版本

gcc -v
显示为 gcc version 8.3.1 20190311 (Red Hat 8.3.1-3) (GCC)
1
2
注意事项:gcc如果没有切换只对本次会话有效
1.切换gcc版本
补充: 这条激活命令只对本次会话有效，重启会话后还是会变回原来的4.8.5版本，要想随意切换可按如下操作。

首先,安装的devtoolset是在 /opt/sh 目录下的,如图

每个版本的目录下面都有个 enable 文件，如果需要启用某个版本，只需要执行

source ./enable
1
所以要想切换到某个版本，只需要执行

source /opt/rh/devtoolset-8/enable
1
可以将对应版本的切换命令写个shell文件放在配了环境变量的目录下，需要时随时切换，或者开机自启

2.直接替换旧的gcc
旧的gcc是运行的 /usr/bin/gcc，所以将该目录下的gcc/g++替换为刚安装的新版本gcc软连接，免得每次enable

mv /usr/bin/gcc /usr/bin/gcc-4.8.5

ln -s /opt/rh/devtoolset-8/root/bin/gcc /usr/bin/gcc

mv /usr/bin/g++ /usr/bin/g++-4.8.5

ln -s /opt/rh/devtoolset-8/root/bin/g++ /usr/bin/g++

gcc --version

g++ --version
————————————————
版权声明：本文为CSDN博主「wudskq」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/csdn18740599042/article/details/108951385