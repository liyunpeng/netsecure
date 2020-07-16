 


如果自己可以出块， 发现链的高度落后于时间， 就可以不用25秒出块， 可以很快的出块， 最终同步上时间， 同步上时间后， 再以25秒出块


  nullroundd:  网上如果没有矿工， 到25 秒， 没人出块时， nullrouodn就加1，一般只有私网， 或者只有个私链的， 

  selectbblock :  找一个最重的块， 块的重量： 块里的消息数， 和块的base


一个节点可以有多个base, base 高的权重越高，  select base 就是选择出最好的一个base.  


选择好了块之后， 就要mpool.pending, 收集网上的所有消息， 到pending， 


用这个pending 创建 块， 


每个块有自己的key， 这个key存到本地数据库里， 用.lotus-storage-miner info 就是查数据里的这个key



