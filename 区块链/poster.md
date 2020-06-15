
TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 nohup ./lotus-storage-miner run --mode=remote-wdposter --server-api=http://10.10.1.20:3456 --dist-path=/mnt --nosync > poster.log 2>&1 &



