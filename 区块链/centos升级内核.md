
解决CenOS7 不能直接升级内核的解决方法，

[root@xx ]# yum --enablerepo=elrepo-kernel install kernel-lt -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * elrepo: lon.mirror.rackspace.com
 * elrepo-kernel: lon.mirror.rackspace.com
No package kernel-lt available.
Error: Nothing to do
 

 

CentOS7 更新最新内核
内核下载地址：https://elrepo.org/linux/kernel/el7/x86_64/RPMS/

内核选择
kernel-lt（lt=long-term）长期有效

kernel-ml（ml=mainline）主流版本

 
安装过程
1.下载内核
wget https://elrepo.org/linux/kernel/el7/x86_64/RPMS/kernel-ml-5.2.4-1.el7.elrepo.x86_64.rpm
 

2.安装内核
rpm -ivh kernel-ml-5.2.4-1.el7.elrepo.x86_64.rpm
 

3.查看当前默认内核
# grub2-editenv list
saved_entry=CentOS Linux (3.10.0-327.28.3.el7.x86_64) 7 (Core)
 

4.查看所有内核启动 grub2
# awk -F \' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg 
0 : CentOS Linux (5.2.4-1.el7.elrepo.x86_64) 7 (Core)
1 : CentOS Linux (3.10.0-327.28.3.el7.x86_64) 7 (Core)
2 : CentOS Linux (3.10.0-327.22.2.el7.x86_64) 7 (Core)
3 : CentOS Linux (3.10.0-327.13.1.el7.x86_64) 7 (Core)
4 : CentOS Linux, with Linux 0-rescue-cd8c4444947b4b0b818457f51ded6591
 

5.修改为最新的内核启动
grub2-set-default 'CentOS Linux (5.2.4-1.el7.elrepo.x86_64) 7 (Core)'
 

6.再次查看内核
# grub2-editenv list
saved_entry=CentOS Linux (5.2.4-1.el7.elrepo.x86_64) 7 (Core)
 

7.重新启动
reboot
 

 

更新kernel-ml-headers
wget http://ftp.osuosl.org/pub/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-headers-5.2.4-1.el7.elrepo.x86_64.rpm
rpm -ivh kernel-ml-headers-5.2.4-1.el7.elrepo.x86_64.rpm
 

更新kernel-ml-devel
http://ftp.osuosl.org/pub/elrepo/kernel/el7/x86_64/RPMS/kernel-ml-devel-5.2.4-1.el7.elrepo.x86_64.rpm
rpm -ivh kernel-ml-devel-5.2.4-1.el7.elrepo.x86_64.rpm
转载于:https://my.oschina.net/u/2366984/blog/3102334

相关资源：kernel-ml-devel-4.19.6-1.el7.elrepo.x86_64.rpm
