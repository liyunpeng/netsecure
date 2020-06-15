读取config.toml文件：
```
[fil@yangzhou010010019017 ~]$ cat config.toml
scheduler_url = "http://10.10.19.17:3456"
local_dir = "/sealer"
copy_limit_mb_per_sec = 500
group_id= [1]
sector_size = 536870912
ip = "10.10.19.17"

[[worker]]
num = 1
supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]
wait_sec = 60

[[worker]]
num = 1
supported_phase = ["CopyTask","CleanTask"]
wait_sec = 60
```
---

RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &
