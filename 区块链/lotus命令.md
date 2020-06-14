```gotemplate
[fil@yangzhou010010019017 ~]$ ./lotus wallet balance
49.999900675992993622
```
./lotus wallet export t3qji2z3u2e243cboxl32irkokkkvbj4moktuapni64ig6pwdpcun5mqr5xcsj346avwd6ek6opue2gwqjj6fa

./lotus-message wallet import --nonce=52 7b2254797065223a22626c73222c22507269766174654b6579223a22473230664e33767566356d5133534b614c466c496862625a46416e5555744d382f334e38417a634d5756733d227d



./lotus state get-actor

[fil@yangzhou010010019017 ~]$ ./lotus sync wait
Worker 0: Target: [bafy2bzacebxaqrchyvcuumqogczibhlzr6oe3b2l56wyjckdj6qvq5c65467a bafy2bzacebofds5jygmv5ztmckwxom2lhkmiyhrmljrd5xzpz33pwezg4pwpo 


[fil@yangzhou010010019017 ~]$ ./lotus chain list
15792: (Jun 13 16:08:00) [ bafy2bzacecjjabsxfkpvpxj5prfmsqjf363a62b2swfmt5765qggkdrwxx7co: t01845,bafy2bzacea34hx2pi4pnax7t77bejwvvdfa6utk56legofi6d2w5wbwiq2ges: 


[fil@yangzhou010010019017 ~]$ ./lotus-storage-miner info
Mode: poster
Miner: t02481
Sector Size: 512 MiB
Byte Power:   512 MiB / 135 TiB (0.0003%) .  算力 。 
Actual Power: 512 Mi / 101 Ti (0.0004%)     算力太小，  
 没有出块
	Committed: 512 MiB
	Proving: 512 MiB
Expected block win rate: 0.0691/day (every 347h13m20s)

Miner Balance: 0.00009932400698959
	PreCommit:   0
	Locked:      0.000096344821570454
	Available:   0.000002979185419136
Worker Balance: 49.999900675992993622
Market (Escrow):  0
Market (Locked):  0


### 查看块的编号
[fil@yangzhou010010019017 sealed]$ ls | grep 2481
s-t02481-3000

[fil@yangzhou010010019017 sealed]$ ls | grep 2481
s-t02481-3000

3000是任务id

把跳版机当前目录的下所有文件同步到17主机上的/home/fil目录下
[root@yangzhou010010001015 20200612]# scp -rpP 62534 * 10.10.19.17:/home/fil
