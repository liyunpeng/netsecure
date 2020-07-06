 

###  帮助
```
[fil@yangzhou010010019017 ~]$ ./lotus-message -h
NAME:
   lotus-message - Filecoin message server

USAGE:
   lotus-message [global options] command [command options] [arguments...]

VERSION:
   0.1.0

COMMANDS:
     daemon   Start a lotus daemon process
     help, h  Shows a list of commands or help for one command
   basic:
     wallet   Manage wallet
     message  Manage message
   developer:
     auth  Manage RPC permissions
   network:
     net  Manage P2P Network

GLOBAL OPTIONS:
   --help, -h     show help (default: false)
   --version, -v  print the version (default: false)
```


### lotus-message 需要创建的表
创建需要的表：
```
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
```

### lotus-message  改变数据库地址过程
因为会有大量消息， 用专门的一个数据库， 共给lotus-message 使用，

建立两个lotus-message要用的表wallets，signed_msgs

修改.lotusstorage/config.toml数据库的地址， 

重启lotus-message 

然后 `lotus wallet export` , `lotus-message wallet import 密钥`， 

lotus-message net peers 检查链接的链

到其他节点， 用 net peers， 考出来一个链接地址， 

本机节点再连这个地址； 地址两部分组成， 一个net peers看到的， 一个

#### ./lotusmessage 文件查看



### 通过转账， 看lotus-message是否正常
因为32G 运算时间很长，正常情况， 看lotus-message能否正常工作， 要等到P2做完发消息， 才会走到lotus-message,  而P2又要等P1做完， 时间很长，  
为了尽早的看到lotus-message 能否正常收发消息，可以用其他节点给这个lotus-message所在节点的矿工转一笔钱，然后本节点用 
lotus-message wallet list , 
看一下nonce值是否加1， 加上1表示lotus-message正常

### 消息的种类和含义
|  中文  | 英文  |  发起时间点
|  ----  | ----  | ---- |
变更节点编号  | ChangePeerID |  
地址管理  | ControlAddresses |   
数据预提交  | PreCommitSector |  P2结束
数据提交证明 | ProveCommitSector |  P4结束
提交时空证明 | SubmitWindowedPoSt  |  poster


###  最快报告
跑个最快报告，lotus-message .  矫正nouce指
lotus-message   表中， 已经在链上的， 可以删除，  

### 上链与出块

上链是为了得到算力， 上链与出块的数据没有关系， 只是为了

矿工的最终目的是为了出块 ， 

全网最强算力的矿工才有机会获取出块权， 

块和sector 是不同的概念

块是消息的集合，  消息记录了节点的所有必备信息， 
 

每个节点向链发的消息， 最后打包成块， 只不过打包者不一定是自己， 是算力最高的节点有打包权

链是有一个块一个块按序链接起来的， 

所以同步了链，  就知道了链上所有节点的信息， 比如节点的空间大小， 

### log
lotus.log, 看到的error可能是其他节点的错误

poster, sealer, worker的log， error都是本节点的错误， 要仔细看的。 


### 消息池
每个矿工都有一个消息池， 存放本矿工的所有发到链上的有效消息， nonce值不连续的消息不回被消息池接收，所以要格外小心可能造成nonce只不连续的问题

在出块的时候， 会把所有矿工的消息池打包， 

如果消息在消息打包的时候进来， 可能不会进入包。 



### 消息的nonce值

本机所看到的nonce是下一个消息的id, 

每个消息都会带上nonce

链要求每个矿工发到链上的消息必须严格有序， 

如果nonce没有按序， 链就不会承认这个消息。 造成消息发不出去。 
