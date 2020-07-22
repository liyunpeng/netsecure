# 之前发过的环境变量意思, 用公告重新发一遍


以下都不考虑 64G sector 的情况

另外以下凡是提到不要配置的, 今后都请直接不配置这个环境变量, 而不再是使用 XXX_VAR=0 或 XXX_VAR=false 这种形式



1. 常用配置

	RUST_BACKTRACE=full

		程序报错时会有详细的报错回溯栈



	RUST_LOG=debug 

		日志级别 设为 Debug



p1:

	FORCE_OPT_P1=1

		开启P1优化,一般只对32G(64G)使用,只对 P1 有效

	

	FORCE_HUGE_PAGE=1

		做 p1 时使用巨页内存

		请确保巨页内存挂载正确再配置

	

	FIL_PROOFS_MAXIMIZE_CACHING=1 

		将 56G 的 parent_cache 读入内存,供做p1的不同线程共用

		** 必须只在做 p1 的worker 上开启, 在别的阶段上会浪费掉内存 **



	FIL_PROOFS_PARTITION_MEM=1

		仅对p1 有效, 开启 32G 低内存模式, 供在低内存的机器上使用

		** 一般不使用 ** 

		** 与上面的 FIL_PROOFS_MAXIMIZE_CACHING 互斥 **



p4:

	FIL_PROOFS_USE_FULL_GROTH_PARAMS=true

		仅对p4有效, p4 配置

		将 params 文件全部缓存进内存, 会加速p4计算, 也会额外占用越 44G 内存

		在配置了 p4 的 worker 启动时就生效, 报错请检查 params 文件挂载正确性



	BELLMAN_PROOF_THREADS=5

		p4 证明的一次展开力度, 仅对 p4 有效

		配置能整除 10 的数

		如配置 2, 则会跑 5 轮

		配置 5 会跑 

		配置 10 只跑一轮

		每多配置 1 大约会多 30G 的内存占用



p23:

	一般不需要做什么配置,唯一需要注意的是千万不要配置 FIL_PROOFS_MAXIMIZE_CACHING





2. 一般不需要配置(使用默认即可)

	FIL_PROOFS_NUMS_OF_PARTITION_FORCE

		一般不需要手动配置

		512M 用不上这个环境变量

		32G sector 不需要配置,使用默认的 2 即可



	FIL_PROOFS_ALLOW_GENERATING_GROTH=1

		允许本地生成 p4 params 文件

		不配置, 爆掉就让它爆掉, 爆掉说明参数文件挂载配置有问题

	



3. 其它可能用到的配置

	FIL_PROOFS_HUGEPAGE_MOUNT="/mnt/huge"

		巨页内存挂载目录

		默认 /mnt/huge

		一般不要配置, 而是在运维层面保证将巨页内存挂载在 /mnt/huge

	

	FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1

		使用 GPU 做 p2 中的 tree_c 部分

	

	FIL_PROOFS_USE_GPU_TREE_BUILDER=1

		使用 GPU 做 p2 中的 tree_r_last 部分

	