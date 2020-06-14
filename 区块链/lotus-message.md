创建需要的表：

CREATE TABLE `wallets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(200) NOT NULL DEFAULT '',
  `private_key` varbinary(255) NOT NULL DEFAULT '' COMMENT '私钥信息',
  `nonce` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ws_address` (`address`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `signed_msgs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(200) DEFAULT NULL,
  `cid` varchar(100) NOT NULL DEFAULT '',
  `nonce` bigint(20) unsigned NOT NULL DEFAULT '0',
  `signed_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '签名消息(CBOR编码后转16进制字符窜)',
  `gr_epoch` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '消息产生时链高度',
  `epoch` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '上链高度',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


获取lotus-message启动时需要的network名字
[fil@yangzhou010010019017 ~]$ curl http://127.0.0.1:1234/rpc/v0 -X POST -H "Content-Type: application/json" -d '{"method": "Filecoin.StateNetworkName"}'
{"jsonrpc":"2.0","result":"interop"}

启动lotus-message:
启动lotus-message程序： nohup ./lotus-message daemon  --network="interop" > lotus-message.log 2>&1 &

正式环境， 应该类似这样的名字：
启动lotus-message程序： nohup ./lotus-message daemon  --network="localnet-2f993f25-318f-4d5b-ad87-c79c4ac52806" > lotus-message.log 2>&1 &


获取lotus-message连接的lotus地址
 ./lotus net listen
 
连接lotus
 ./lotus-message net connect /ip4/10.10.1.20/tcp/41613/p2p/12D3KooWNAhSZNdjAGfNvKHbaPu6ToKFydiy6gBKrVVHRYzwfY2e
 
 
 