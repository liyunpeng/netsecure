
TRUST_PARAMS=1 RUST_LOG=info RUST_BACKTRACE=1 nohup ./lotus-storage-miner run --mode=remote-wdposter --server-api=http://10.10.1.20:3456 --dist-path=/mnt --nosync > poster.log 2>&1 &

RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &


