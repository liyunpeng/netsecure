#! /bin/bash
# 使用centos8 操作系统， sudo 运行该脚本

# 1. 添加glusster的官方的repo文件， 要用flusterfs6, 不要用glusterfs7,
# 因为glusterfs7需要的python7在epel.repo里找不到相应的rpm安装包
cat  << EOF > /etc/yum.repos.d/glusterfs.repo
[glusterfs-rhel8]
name=GlusterFS is a clustered file-system capable of scaling to several petabytes.
baseurl=https://download.gluster.org/pub/gluster/glusterfs/6/LATEST/RHEL/el-$releasever/$basearch/
enabled=1
skip_if_unavailable=1
gpgcheck=1
gpgkey=https://download.gluster.org/pub/gluster/glusterfs/6/rsa.pub

[glusterfs-noarch-rhel8]
name=GlusterFS is a clustered file-system capable of scaling to several petabytes.
baseurl=https://download.gluster.org/pub/gluster/glusterfs/6/LATEST/RHEL/el-$releasever/noarch
enabled=1
skip_if_unavailable=1
gpgcheck=1
gpgkey=https://download.gluster.org/pub/gluster/glusterfs/6/rsa.pub
EOF

# 2.添加阿里云的epel-7.repo文件
sudo wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

# 3.清除之前的yum下载的缓存
dnf clean packages

# 4.下载并安装目标软件
sudo yum intall -y glusterfs-server
