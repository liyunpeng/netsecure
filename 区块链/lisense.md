[TOC]
license 部署的新增步骤

### lotus-server地址要发给王钞

用王钞编译的对应这个地址的floader版本

###  向user_infos查添加一条记录
用如下sql向user_infos查添加一条记录
```
INSERT INTO `license`.`user_infos`(`id`, `created_at`, `updated_at`, `deleted_at`, `client_id`, `client_key`, `req_limit_in_an_hour`, `privilege`, `priv_key`) VALUES (1, '2020-06-28 14:51:24', '2020-06-28 14:51:24', NULL, 'dev', 'dev_key', 100, 0, 0x3082025D02010002818100A82CD89E24C57D085FC05B675B626B146494AD95D8000EB900B6C90FC58814362F05FCBC7E476179BC432B3B484F2B95E68F8C04D97DDBF48984582D08C056513B7E9496560F197289DCB3F10B7049C87BC6C626AA5E5B452F3F2420B06B1B92209C8FF27056C35D6DC044E5FAC307C1D90167DC6619DA978280CFDB81D4334B02030100010281810087D3A8A4996853A2A6CB1247B8FC1525E4525C9C7057238CF1F1AF1428E2CE08311471DABF56E17853C020338224473C8B799689F82AF9B2583AE68880CFEF25DF502B23343E0138116DB3C925022D3FA3E1A581D8BB19D2328BE504F06D049CFA893ED33A99F4765BE27FFA2F24AAB4DCA16BEF4D2371589F90F3B8538EBAB9024100D52ED485FB5C5558A2A04F965CA384EB65C44CEE1E53A140C8AAC5DD62EAB7920E9869A2DD323C27DFAD3C0005EDDE3C18604B83B7D1A05BA07D0507A638C73D024100C9F3DD516736D078F9CB6B9C152FCCB456846ECE3878F780820A6A16C2EAC6158EE36A216D84CEC9A4428F08EDACE630F2A952023087A914BC9DC79EA04ACD2702410081CA0D21B53335D2CCD005246A2A33D68D12C23386CB2BB5A1763718DE0C40CEEF8BE364807F0118D599469A4D01D0F78D6FB309F273F1C95720465BADDB8B91024010015DC6F7D12650902B8909C3BC18132AD0301FF3E5D267C2E6A465CD68E1EE0F77029047A7C0E3C63AE82F22F712FF4A1C153DCB2ED53DA97D2FB6E8A944FD0240622676FCAF34C32F85378069B21AB7976B3A4144454329B61F0BAED46B74C44CC60CB1EAF3593CBDF3E04AB55E342E7D0F81334B013DF11B7D50F6B38D13928E);
```

### 需要加入./floader的命令

启动lotus, poster, sealer， force worker时需要加入floader, 以下是阿里环境下的启动命令：
```
nohup ./floader ./lotus daemon --server-api=http://10.10.28.218:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 & 

nohup ./floader ./lotus daemon --server-api=http://10.10.10.207:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 &

nohup ./floader ./lotus daemon --server-api=http://10.0.0.6:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 &

TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 nohup ./floader ./lotus-storage-miner run --mode=remote-wdposter --server-api=http://10.10.28.218:3456 --dist-path=/var/tmp/filecoin-proof-parameters --nosync > poster.log 2>&1 &

FORCE_BUILDER_P1_WORKERS=18 FORCE_BUILDER_TASK_DELAY=1s FORCE_BUILDER_AUTO_PLEDGE_INTERVAL=1 TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_PLEDGE_TASK_TOTAL_NUM=37 nohup ./floader ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.28.218:3456 --dist-path=/var/tmp/filecoin-proof-parameters --nosync --groups=1 > ./sealer.log 2>&1 &


```
不用floader起， lotus.log会报这个错：
```
2020-07-11T22:10:08.301+0800	FATAL	serverapi	serverapi/serverapi.go:70	new key mgrconstruct shared key reader: open shm: no such file or directory
```
其他不需要， 如： 
```
nohup ./lotus-server >lotus-server.log 2>&1 &

./lotus-storage-miner init ....

./lotus sync wait  

./lotus wallet new bls

./lotus state get-actor t3wj3dfbxnqfzjlgtq7yma66tmkdkc7p4bf2cmrtpw4gewvz5dvbsg6ws5nfk2otvm7a5ll2p3ts5rkjps3eia  

mount -t nfs -o hard,nolock,rw,user,rsize=1048576,wsize=1048576,vers=3 10.10.28.236@tcp:10.10.28.235@tcp:/027a3566 /mnt/cpfs 
```

可以先做链同步， 初始化矿工， 之后重启lotus进程，加上floader

###  启动worker 

```
p1: 
（前提条件，系统已开启巨页内存）
FIL_PROOFS_HUGEPAGE_MOUNT=/mnt/huge/ FORCE_OPT_P1=1 FIL_PROOFS_NUMS_OF_PARTITION_FORCE=4 FIL_PROOFS_MAXIMIZE_CACHING=true FIL_PROOFS_ALLOW_GENERATING_GROTH=1 RUST_LOG=trace FORCE_HUGE_PAGE=1  RUST_BACKTRACE=1 nohup  ./floader ./force-remote-worker  > force-remote-worker.log 2>&1  &

p23:
RUST_LOG=debug  RUST_BACKTRACE=full nohup ./floader ./force-remote-worker > force-remote-worker.log 2>&1 &

p4:
（前提条件，内存要大于150G）
FIL_PROOFS_ALLOW_GENERATING_GROTH=1 RUST_LOG=debug BELLMAN_PROOF_THREADS=5 RUST_BACKTRACE=full nohup ./floader ./force-remote-worker > force-remote-worker.log 2>&1 &

```


### 结束floader起的进程的正确姿势
使用kill -TERM 8771 命令可以进程和其子进程
也可以用killall
```
$killall ./floader 
```

