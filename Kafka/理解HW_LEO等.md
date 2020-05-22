###  生产者在把消息发给broker的分区时， 会先发送到leader副本，然后再同步到其他副本， 
一个broker就是一台运行kakfa的服务的主机
一个主题有多个分区，一个分区有多个副本， 每个副本在不同的broker上， 
每个分区的副本中有一个是leader副本，其他都是folloer副本
副本分布在不同的主机上， 
生产者会把消息先写到leader副本， 
follower副本会从leader副本拉取消息，

### 副本同步的相关概念
kafka 之ar, isr, leo, hw, isolation

* ISR 
所有的副本集合称为AR，
follower副本中有效的集合为ISR, 
follower副本和leader副本会有差距

* HW
所有follower副本中同步消息的最小位置， 称为hw, 
也是follower副本中同步速度最慢那个副本的消息序号， 就是HW
消费者只能消费hw之前的消息， 不包括hw那一位消息。 

* LEO
每个副本下一个存放消息的位置， 称为leo, 
一个分区多个副本，只有一个hw, 会有多个leo, 每个副本都有自己的leo. 
每个副本的同步速度不同，所以leo也就不同。 

当前消费到的消息位置与hw的差值， 就是堆积的消息的个数。
也叫消息的堆积量， 也叫消息的滞后量， 用lag表示

* LSO
生产者启动事务后， 在发送多个消息后， 要在最后有个提交动作。 
但消息在提交前已经发送到broker, 即leader副本存储了这些消息，
follower也会同步拉取这些消息
这些没有最后提交动作的消息，能否被消费者看到，由配置参数 isolation.level控制， 
默认是read uncommited, 即能看到这些消息 
可以设置为read commited, 就不会看到这些消息。 只能看到最后一个提交动作的消息， 
这个最后有提交动作的消息的位置就是LSO. 如果
所以 LSO < HW < LEO 