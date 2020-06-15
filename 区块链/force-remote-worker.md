force-remote-worker读取config.toml文件：
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
copy_limit_mb_per_sec = 500
500是限速度， 因为P1 到P6 都在使用网络， 对每个P限制最大速度


supported_phase = ["PreCommitPhase1","PreCommitPhase2","CommitPhase1","CommitPhase2"]

一个work做这4个事情， 


wait_sec = 60
force-remote-worker 每60秒 到sealer 分发的task表读任务，  读到任务就把is-taken字段 指1， 表示这个任务已经被 orce-remote-worker领取

一般合理的设置是


RUST_LOG=debug BELLMAN_PROOF_THREADS=3 RUST_BACKTRACE=1 nohup ./force-remote-worker > force-remote-worker.log 2>&1 &
