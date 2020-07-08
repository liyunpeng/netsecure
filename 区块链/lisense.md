

nohup  ./lotus daemon --genesis=./dev.gen --bootstrap=false --api 11234 > lotus.log 2>&1 &


nohup ./floader ./lotus daemon --genesis=./dev.gen --server-api=http://10.10.11.31:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 & 

./lotus sync wait  

./lotus wallet new bls

./lotus state get-actor t3wj3dfbxnqfzjlgtq7yma66tmkdkc7p4bf2cmrtpw4gewvz5dvbsg6ws5nfk2otvm7a5ll2p3ts5rkjps3eia      

./lotus-storage-miner init --nosync --sector-size=536870912 --owner=t3qr64ae6azjwqewl5ivsyy7dvw73evaerkkiipavd3uqwyz7ybmpp2nxmbfr6r5jgrifmwjq2hnvsclgdpwma

./lotus-storage-miner init  --nosync --owner=t01002

nohup ./lotus-server >lotus-server.log 2>&1 &

nohup ./floader ./lotus daemon --server-api=http://10.10.10.207:3456 --bootstrap=false --api 11234 > lotus.log 2>&1 &

nohup ./floader ./lotus-storage-miner run --mode=poster --server-api=http://10.10.11.31:3456 --dist-path=/mnt --nosync > poster.log 2>&1 &

FORCE_OPT_P1=1 FIL_PROOFS_NUMS_OF_PARTITION_FORCE=4 FIL_PROOFS_MAXIMIZE_CACHING=false FIL_PROOFS_ALLOW_GENERATING_GROTH=1 RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./floader ./force-remote-worker > force-remote-worker.log 2>&1 &

FORCE_BUILDER_P1_WORKERS=10 FORCE_BUILDER_TASK_DELAY=1s FORCE_BUILDER_AUTO_PLEDGE_INTERVAL=1 TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 FORCE_BUILDER_PLEDGE_TASK_TOTAL_NUM=21 nohup ./floader ./lotus-storage-miner run --mode=remote-sealer --server-api=http://10.10.11.31:3456 --dist-path=/mnt --nosync --groups=1 > ./sealer.log 2>&1 &

