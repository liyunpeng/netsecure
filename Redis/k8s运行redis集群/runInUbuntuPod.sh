#! /bin/bash
sudo cat << EOF >> /etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF

sudo apt-get update
sudo apt-get install -y vim wget python2.7 python-pip redis-tools dnsutils

# 安装redis-trib：

pip install redis-trib==0.5.1

# 创建只有Master节点的集群：
redis-trib.py create \
  `dig +short redis-app-0.redis-service.default.svc.cluster.local`:6379 \
  `dig +short redis-app-1.redis-service.default.svc.cluster.local`:6379 \
  `dig +short redis-app-2.redis-service.default.svc.cluster.local`:6379

# 为每个Master添加Slave

redis-trib.py replicate \
  --master-addr `dig +short redis-app-0.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-3.redis-service.default.svc.cluster.local`:6379

redis-trib.py replicate \
  --master-addr `dig +short redis-app-1.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-4.redis-service.default.svc.cluster.local`:6379

redis-trib.py replicate \
  --master-addr `dig +short redis-app-2.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-5.redis-service.default.svc.cluster.local`:6379