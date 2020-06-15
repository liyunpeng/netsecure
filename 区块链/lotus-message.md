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


 
 