
 ps -ef | grep lotus  

程序中做trysink， 程序中叫 lotus
seeker 
vim  lotus.log 
从lotus server 拿 矿工号 。  

一个矿池分配一个 server
window 。 破 。 2000多个分区 ， 做sector证明 
每个ing去
分配到爱面对worker中 。


500G 本地文件生成 32G，把这32G拷贝到远程 ， 远程存储目录为 --dit-path=/mnt
nsync .  忽略同步高度
lotus-storage-miner run -h


-------

ps -ef | grep nooop
lotus-storage-miner info   

跑个最快报告


lotus-message .  矫正nouce指


singed-message
t3 地址， 消息id

lotus-message   表中， 已经在链上的， 可以删除，   


发任务， 

做任务有6个阶段：
六个阶段
扬州 。 1000个机器， 按机会分组

一个机会单独分一个组， 一个组起P1到P6阶段的四个程序，  一个程序就是一个worker

11台机器 写文件 ，  证明需要这些文件 
一个组起一个sealer, 分到机器，做任务
sealer 按机会分组 
数据库连接60秒 ， 每60秒到数据查任务， 领取任务， 然后值1 
第一阶段 ， 后面的阶段可以同时做。 


## forcer

### 每个P的作用， 及耗时
P1 10个worker,  即10个P1，同时跑  
P1 用 intel要 32个小时 
P1用 amd 只用3个小时， 

输出块的大小与时间对应
512M：    25分钟
32G：  60个小时


P1 起nfs , 与P2-P6 共享此nfs， P1 P2都写， 其他读。  P3 来 。 Pc 拷贝
P1 P2 网本地写文件， P2 P2 需要共享 。 
P3产生数据， copy

所以clean阶段 删掉

P4 耗时1个小时ß。 p5 copy 耗时20分钟， p4, p5可以同时， 

p6 clean: 本地临时 500G，结果为32G的块， 32G传出去， 就可以删除500G


### p的编排


p1 单独，p2 p3合并 ， 4单独，p5 p6合并




## 存储服务器

### focefs   
裸磁盘存储服务器， 有一个专门的代理进程， 让外部感知为 实现文件系统

forcefs性能远不如nfs


P2 P3 公用， 
plarm 

amd 。 P1  3个小时 。 
 
P2 。 2个小时

sealer 给自己分发任务， 不用给别人， 


---------
私恋 时间长一点

工联 时间短一旦