mac 上搭建测试网 
编译 lotus
nohup ./lotus daemon >lotus.log 2>&1 &

➜  ~ ./lotus sync wait
Worker: 7624; Base: 231486; Target: 231486 (diff: 0)
State: complete; Current Epoch: 231486; Todo: 0
Done!

查看链同步空间：
➜  ~ du -sch .lotus
 22G	.lotus
 22G	total

生成t3地址
➜  ~ ./lotus wallet new bls

➜  ~ ./lotus wallet list
Address                                                                                 Balance  Nonce  Default
t3u5i75bx5fkazugpdsqdxbm5pajs5uwko4hnxuejatmjxuytfnwxevzq7vzrjfg23wd7t5px7zy5awqka4gya  0 FIL    0      X



miner初始化：
```
./lotus-miner init --owner=t3u5i75bx5fkazugpdsqdxbm5pajs5uwko4hnxuejatmjxuytfnwxevzq7vzrjfg23wd7t5px7zy5awqka4gya  --nosync  --sector-size 34359738368
```

这个命令会下载证明参数文件, 文件存放路径如下： 
```
➜  ~ du -sch /var/tmp/filecoin-proof-parameters/
101G	/var/tmp/filecoin-proof-parameters/
101G	total
➜  ~ ll /var/tmp/filecoin-proof-parameters/
total 211651368
-rw-r--r--  1 zhenglun1  wheel   3.0K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0170db1f394b35d995252228ee359194b13199d259380541dc529fb0099096b0.vk
-rw-r--r--  1 zhenglun1  wheel   3.0K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-0cfb4f178bbb71cf2ecfcd42accce558b27199ab4fb59cb78f2483fe21ef36d9.vk
-rw-r--r--  1 zhenglun1  wheel    13K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-3ea05428c9d11689f23529cde32fd30aabd50f7d2c93657c1d3650bca3e8ea9e.vk
-rw-r--r--  1 zhenglun1  wheel    13K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-50c7368dea9593ed0989e70974d28024efa9d156d585b7eea1be22b2e753f331.vk
-rw-r--r--  1 zhenglun1  wheel   3.0K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-5294475db5237a2e83c3e52fd6c2b03859a1831d45ed08c4f35dbf9a803165a9.vk
-rw-r--r--  1 zhenglun1  wheel    13K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-0-0-7d739b8cf60f1b0709eeebee7730e297683552e4b69cab6984ec0285663c5781.vk
-rw-r--r--  1 zhenglun1  wheel    57G  1  8 18:15 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.params
-rw-r--r--  1 zhenglun1  wheel   2.4M  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-0377ded656c6f524f1618760bffe4e0a1c51d5a70c4509eedae8a27555733edc.vk
-rw-r--r--  1 zhenglun1  wheel   183M  1  8 19:15 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-559e581f022bb4e4ec6e719e563bf0e026ad6de42e56c18714a2c692b1b88d7e.params
-rw-r--r--  1 zhenglun1  wheel    13K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-0-559e581f022bb4e4ec6e719e563bf0e026ad6de42e56c18714a2c692b1b88d7e.vk
-rw-r--r--  1 zhenglun1  wheel   2.3M  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-2627e4006b67f99cef990c0a47d5426cb7ab0a0ad58fc1061547bf2d28b09def.vk
-rw-r--r--  1 zhenglun1  wheel    13K  1  5 17:01 v28-proof-of-spacetime-fallback-merkletree-poseidon_hasher-8-8-2-b62098629d07946e9028127e70295ed996fe3ed25b0f9f88eb610a0ab4385a3c.vk
-rw-r--r--  1 zhenglun1  wheel   4.6K  1  5 17:01 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-032d3138d22506ec0082ed72b2dcba18df18477904e35bafee82b3793b06832f.vk
-rw-r--r--  1 zhenglun1  wheel   4.6K  1  5 17:01 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-6babf46ce344ae495d558e7770a585b2382d54f225af8ed0397b8be7c3fcd472.vk
-rw-r--r--  1 zhenglun1  wheel   4.6K  1  5 17:01 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-0-0-sha256_hasher-ecd683648512ab1765faa2a5f14bab48f676e633467f0aa8aad4b55dcb0652bb.vk
-rw-r--r--  1 zhenglun1  wheel    44G  1  8 19:13 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.params
-rw-r--r--  1 zhenglun1  wheel    32K  1  5 17:01 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-0-sha256_hasher-82a357d2f2ca81dc61bb45f4a762807aedee1b0a53fd6c4e77b46a01bfef7820.vk
-rw-r--r--  1 zhenglun1  wheel    32K  1  5 17:01 v28-stacked-proof-of-replication-merkletree-poseidon_hasher-8-8-2-sha256_hasher-96f1b4a04c5c51e4759bbf224bbc2ef5a42c7100f16ec0637123f16a845ddfb2.vk
```

看下本地剩余空间够用不：
![-w605](media/16103361957175.jpg)
