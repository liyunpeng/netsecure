#! /bin/bash
# 本脚本完成centos8下安装kafka和启动zk, 启动kafka。 zk就在kafka的安装包里，不需单独下zk.
set -v

wget -c http://mirror.bit.edu.cn/apache/kafka/2.4.0/kafka_2.12-2.4.0.tgz

tar -zxvf  kafka_2.12-2.4.0.tgz
sudo mv kafka_2.12-2.4.0  /opt/kafka_2.12
cd /opt/kafka_2.12/bin

cp ../config/server.properties ../config/server.properties-backup
cp ../config/zookeeper.properties ../config/zookeeper.properties-backup

sudo yum install java -y