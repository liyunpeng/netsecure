```
[user1@220-node 单机版]$ k get po
NAME                         READY   STATUS    RESTARTS   AGE
kafaka-n1-5bf5999cf8-bzbhn   1/1     Running   3          2m58s
redis-0                      1/1     Running   0          100m
zk-n1-6784764cc9-cpmnk       1/1     Running   0          10m
[user1@220-node 单机版]$ k exec -it zk-n1-6784764cc9-cpmnk bash
bash-4.3# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /conf/zoo.cfg
Mode: standalone

---------------------------------

kafka-topics.sh --create --topic test --zookeeper zk-n1:2181/kafka --partitions 3 --replication-factor 2
```
kafka 没起来：
```
[user1@220-node 单机版]$ k logs  kafaka-n1-5bf5999cf8-bzbhn

[2020-01-15 09:59:28,444] FATAL Fatal error during KafkaServer startup. Prepare to shutdown (kafka.server.KafkaServer)
org.I0Itec.zkclient.exception.ZkTimeoutException: Unable to connect to zookeeper server 'ykszktest-n1:2181,ykszktest-n2:2181,ykszktest-n3:2181' with timeout of 6
        at org.I0Itec.zkclient.ZkClient.connect(ZkClient.java:1233)
        at org.I0Itec.zkclient.ZkClient.<init>(ZkClient.java:157)
        at org.I0Itec.zkclient.ZkClient.<init>(ZkClient.java:131)
        at kafka.utils.ZkUtils$.createZkClientAndConnection(ZkUtils.scala:115)
        at kafka.utils.ZkUtils$.withMetrics(ZkUtils.scala:92)
        at kafka.server.KafkaServer.$anonfun$initZk$2(KafkaServer.scala:340)
        at kafka.server.KafkaServer.$anonfun$initZk$2$adapted(KafkaServer.scala:334)
        at scala.Option.foreach(Option.scala:257)
        at kafka.server.KafkaServer.initZk(KafkaServer.scala:334)
        at kafka.server.KafkaServer.startup(KafkaServer.scala:194)
        at kafka.server.KafkaServerStartable.startup(KafkaServerStartable.scala:38)
        at kafka.Kafka$.main(Kafka.scala:92)
        at kafka.Kafka.main(Kafka.scala)
[2020-01-15 09:59:28,462] INFO shutting down (kafka.server.KafkaServer)
[2020-01-15 09:59:28,517] INFO shut down completed (kafka.server.KafkaServer)
[2020-01-15 09:59:28,522] FATAL Exiting Kafka. (kafka.server.KafkaServerStartable)
[2020-01-15 09:59:28,575] INFO shutting down (kafka.server.KafkaServer)
```
原因：
```
Unable to connect to zookeeper server 'ykszktest-n1:2181,ykszktest-n2:2181,ykszktest-n3:2181'
```
解决办法：把kafka的yaml文件中的环境变量修改：
```
    env:
        # 必须要有,zk集群
      - name: KAFKA_ZOOKEEPER_CONNECT
        value: ykszktest-n1:2181,ykszktest-n2:2181,ykszktest-n3:2181/kafka
改为：
    env:
        # 必须要有,zk集群
      - name: KAFKA_ZOOKEEPER_CONNECT
        value: zk-n1:2181/kafka
```

然后把deploy资源从k8s集群中删除，
```
$ k delete deploy kafaka-n1
deployment.apps "kafaka-n1" deleted
```
用修改后的文件重新创建deploy
```
$ k apply -f kafka-svc-deploy.yaml
```
不要删除Pod，也不要删除service, 因为起不到删除pod的作用，删除后会自动重建。
要删除pod的管理者，deploy, rc, rs等，pod就被删除了，而且不会重建了，
因为重建的动作时管理者发出的，管理者没了，就不会发出重建的动作了

```
--------------
kafka pod的log:
[2020-01-15 10:04:27,814] INFO Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,815] INFO Client environment:java.io.tmpdir=/tmp (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,815] INFO Client environment:java.compiler=<NA> (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,816] INFO Client environment:os.name=Linux (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,816] INFO Client environment:os.arch=amd64 (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,816] INFO Client environment:os.version=4.18.0-80.el8.x86_64 (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,817] INFO Client environment:user.name=root (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,817] INFO Client environment:user.home=/root (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,817] INFO Client environment:user.dir=/ (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,822] INFO Initiating client connection, connectString=zk-n1:2181 sessionTimeout=6000 watcher=org.I0Itec.zkclient.ZkClient@460d0a57 (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:27,886] INFO Waiting for keeper state SyncConnected (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:27,910] INFO Opening socket connection to server zk-n1.default.svc.cluster.local/10.96.220.105:2181. Will not attempt to authenticate using SASL (unknown error) (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:27,935] INFO Socket connection established to zk-n1.default.svc.cluster.local/10.96.220.105:2181, initiating session (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,021] INFO Session establishment complete on server zk-n1.default.svc.cluster.local/10.96.220.105:2181, sessionid = 0x16fa89963850000, negotiated timeout = 6000 (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,030] INFO zookeeper state changed (SyncConnected) (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:28,227] INFO Created zookeeper path /kafka (kafka.server.KafkaServer)
[2020-01-15 10:04:28,231] INFO Terminate ZkClient event thread. (org.I0Itec.zkclient.ZkEventThread)
[2020-01-15 10:04:28,240] INFO Session: 0x16fa89963850000 closed (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:28,243] INFO Initiating client connection, connectString=zk-n1:2181/kafka sessionTimeout=6000 watcher=org.I0Itec.zkclient.ZkClient@28eaa59a (org.apache.zookeeper.ZooKeeper)
[2020-01-15 10:04:28,246] INFO Starting ZkClient event thread. (org.I0Itec.zkclient.ZkEventThread)
[2020-01-15 10:04:28,251] INFO Waiting for keeper state SyncConnected (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:28,256] INFO Opening socket connection to server zk-n1.default.svc.cluster.local/10.96.220.105:2181. Will not attempt to authenticate using SASL (unknown error) (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,261] INFO Socket connection established to zk-n1.default.svc.cluster.local/10.96.220.105:2181, initiating session (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,264] INFO EventThread shut down for session: 0x16fa89963850000 (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,275] INFO Session establishment complete on server zk-n1.default.svc.cluster.local/10.96.220.105:2181, sessionid = 0x16fa89963850001, negotiated timeout = 6000 (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:28,277] INFO zookeeper state changed (SyncConnected) (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:29,670] INFO Cluster ID = s6bmFtiPRfGweQosK8TQWg (kafka.server.KafkaServer)
[2020-01-15 10:04:29,711] WARN No meta.properties file under dir /kafka/kafka-logs-kafaka-n1/meta.properties (kafka.server.BrokerMetadataCheckpoint)
[2020-01-15 10:04:30,000] INFO [ThrottledRequestReaper-Fetch]: Starting (kafka.server.ClientQuotaManager$ThrottledRequestReaper)
[2020-01-15 10:04:30,104] INFO [ThrottledRequestReaper-Produce]: Starting (kafka.server.ClientQuotaManager$ThrottledRequestReaper)
[2020-01-15 10:04:30,118] INFO [ThrottledRequestReaper-Request]: Starting (kafka.server.ClientQuotaManager$ThrottledRequestReaper)
[2020-01-15 10:04:30,694] INFO Log directory '/kafka/kafka-logs-kafaka-n1' not found, creating it. (kafka.log.LogManager)
[2020-01-15 10:04:30,878] INFO Loading logs. (kafka.log.LogManager)
[2020-01-15 10:04:31,071] INFO Logs loading complete in 191 ms. (kafka.log.LogManager)
[2020-01-15 10:04:35,501] WARN Client session timed out, have not heard from server in 5286ms for sessionid 0x16fa89963850001 (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:35,502] INFO Client session timed out, have not heard from server in 5286ms for sessionid 0x16fa89963850001, closing socket connection and attempting reconnect (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:35,598] INFO Starting log cleanup with a period of 300000 ms. (kafka.log.LogManager)
[2020-01-15 10:04:35,609] INFO zookeeper state changed (Disconnected) (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:35,725] INFO Starting log flusher with a default period of 9223372036854775807 ms. (kafka.log.LogManager)
[2020-01-15 10:04:36,645] INFO Opening socket connection to server zk-n1.default.svc.cluster.local/10.96.220.105:2181. Will not attempt to authenticate using SASL (unknown error) (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:36,653] INFO Socket connection established to zk-n1.default.svc.cluster.local/10.96.220.105:2181, initiating session (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:36,669] INFO Session establishment complete on server zk-n1.default.svc.cluster.local/10.96.220.105:2181, sessionid = 0x16fa89963850001, negotiated timeout = 6000 (org.apache.zookeeper.ClientCnxn)
[2020-01-15 10:04:36,673] INFO zookeeper state changed (SyncConnected) (org.I0Itec.zkclient.ZkClient)
[2020-01-15 10:04:39,120] INFO Awaiting socket connections on 0.0.0.0:9092. (kafka.network.Acceptor)
[2020-01-15 10:04:39,147] INFO [SocketServer brokerId=1] Started 1 acceptor threads (kafka.network.SocketServer)
[2020-01-15 10:04:39,277] INFO [ExpirationReaper-1-Produce]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,283] INFO [ExpirationReaper-1-Fetch]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,290] INFO [ExpirationReaper-1-DeleteRecords]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,352] INFO [LogDirFailureHandler]: Starting (kafka.server.ReplicaManager$LogDirFailureHandler)
[2020-01-15 10:04:39,641] INFO [ExpirationReaper-1-topic]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,676] INFO [ExpirationReaper-1-Heartbeat]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,680] INFO [ExpirationReaper-1-Rebalance]: Starting (kafka.server.DelayedOperationPurgatory$ExpiredOperationReaper)
[2020-01-15 10:04:39,736] INFO Creating /controller (is it secure? false) (kafka.utils.ZKCheckedEphemeral)
[2020-01-15 10:04:39,777] INFO Result of znode creation is: OK (kafka.utils.ZKCheckedEphemeral)
[2020-01-15 10:04:39,797] INFO [GroupCoordinator 1]: Starting up. (kafka.coordinator.group.GroupCoordinator)
[2020-01-15 10:04:39,811] INFO [GroupCoordinator 1]: Startup complete. (kafka.coordinator.group.GroupCoordinator)
[2020-01-15 10:04:39,884] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 74 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 10:04:39,943] INFO [ProducerId Manager 1]: Acquired new producerId block (brokerId:1,blockStartProducerId:0,blockEndProducerId:999) by writing to Zk with path version 1 (kafka.coordinator.transaction.ProducerIdManager)
[2020-01-15 10:04:40,078] INFO [TransactionCoordinator id=1] Starting up. (kafka.coordinator.transaction.TransactionCoordinator)
[2020-01-15 10:04:40,101] INFO [TransactionCoordinator id=1] Startup complete. (kafka.coordinator.transaction.TransactionCoordinator)
[2020-01-15 10:04:40,103] INFO [Transaction Marker Channel Manager 1]: Starting (kafka.coordinator.transaction.TransactionMarkerChannelManager)
[2020-01-15 10:04:40,509] INFO Creating /brokers/ids/1 (is it secure? false) (kafka.utils.ZKCheckedEphemeral)
[2020-01-15 10:04:40,539] INFO Result of znode creation is: OK (kafka.utils.ZKCheckedEphemeral)
[2020-01-15 10:04:40,549] INFO Registered broker 1 at path /brokers/ids/1 with addresses: EndPoint(kafaka-n1,9092,ListenerName(PLAINTEXT),PLAINTEXT) (kafka.utils.ZkUtils)
[2020-01-15 10:04:40,562] WARN No meta.properties file under dir /kafka/kafka-logs-kafaka-n1/meta.properties (kafka.server.BrokerMetadataCheckpoint)
[2020-01-15 10:04:40,652] INFO Kafka version : 1.0.1 (org.apache.kafka.common.utils.AppInfoParser)
[2020-01-15 10:04:40,652] INFO Kafka commitId : c0518aa65f25317e (org.apache.kafka.common.utils.AppInfoParser)
[2020-01-15 10:04:40,662] INFO [KafkaServer id=1] started (kafka.server.KafkaServer)
[2020-01-15 10:14:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 10:24:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 10:34:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 10:44:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 1 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 10:54:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 11:04:39,805] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[2020-01-15 11:14:39,806] INFO [GroupMetadataManager brokerId=1] Removed 0 expired offsets in 0 milliseconds. (kafka.coordinator.group.GroupMetadataManager)
[user1@220-node ~]$
```

