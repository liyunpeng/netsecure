[fil@yangzhou010010019017 ~]$ ./lotus wallet balance
49.999900675992993622




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



[fil@yangzhou010010019017 sealed]$ ls | grep 2481
s-t02481-3000
[fil@yangzhou010010019017 sealed]$ cd 10.10.4.23/^C
[fil@yangzhou010010019017 sealed]$ ^C
[fil@yangzhou010010019017 sealed]$ pwd
/mnt/nfs/10.10.4.23/sealed