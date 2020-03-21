#! /bin/bash
# centos8 

set -v 

#wget https://github.com/etcd-io/etcd/releases/etcd-v3.3.18-linux-amd64.tar.gz

# 提取下载的存档文件：

#tar xvf etcd-v3.3.18-linux-amd64.tar.gz

cd etcd-v3.3.18-linux-amd64
sudo mv etcd  etcdctl /usr/local/bin

#确认版本，运行etcd --version命令：


sudo mkdir -p /var/lib/etcd/

sudo mkdir /etc/etcd

#创建etcd系统用户：

sudo groupadd --system etcd

sudo useradd -s /sbin/nologin --system -g etcd etcd

# 将/var/tmp/etcd0.service/lib/etcd/目录所有权设置为etcd用户：

sudo chown -R etcd:etcd /var/lib/etcd/

cat > /tmp/etcd.service <<EOF
[Unit]

Description=etcd key-value store

Documentation=https://github.com/etcd-io/etcd

After=network.target

[Service]

User=etcd

Type=notify

Environment=ETCD_DATA_DIR=/var/lib/etcd

Environment=ETCD_NAME=%m

ExecStart=/usr/local/bin/etcd --name etcd0 \
--data-dir /data/etcd \
--initial-advertise-peer-urls http://192.168.43.144:2380 \
--listen-peer-urls http://192.168.43.144:2380 \
--advertise-client-urls http://192.168.43.144:2379 \
--listen-client-urls http://192.168.43.144:2379,http://127.0.0.1:2379 


Restart=always

RestartSec=10s

LimitNOFILE=40000



[Install]

WantedBy=multi-user.target
EOF

sudo cp /tmp/etcd.service  /etc/systemd/system/ 
sudo systemctl  daemon-reload
sudo systemctl  start etcd.service

etcd --version
#如果SELinux在强制模式下运行，则生成本地策略模块以允许访问数据目录：
#sudo ausearch -c '(etcd)' --raw | audit2allow -M my-etcd
#要使此策略包处于活动状态，请执行：
#sudo semodule -X 300 -i my-etcd.pp
# sudo restorecon -Rv /usr/local/bin/etcd
# 重启etcd服务：
#sudo systemctl restart etcd

# 查看etcd服务是否启动
sudo netstat -antp | grep 2379
#tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      10325/etcd
#tcp        0      0 127.0.0.1:2379          127.0.0.1:34954         ESTABLISHED 10325/etcd
#tcp        0      0 127.0.0.1:34954         127.0.0.1:2379          ESTABLISHED 10325/etcd
ps -e | grep etcd
 #10325 ?        00:00:02 etcd

