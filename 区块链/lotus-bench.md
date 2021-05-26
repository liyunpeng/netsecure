### lotus-bench
![-w579](media/16194809923330.jpg)


winning window 时间要求
![-w810](media/16194957493779.jpg)

机械硬盘， window post时间： 
![-w1786](media/16194958618525.jpg)
当时还有p2 在跑



### lotus 1.6 gpu 32G 
![-w796](media/16195681359704.jpg)

![-w1231](media/16195946983849.jpg)

![-w592](media/16195947264367.jpg)



### 优化gpu 到最新驱动， NVIDIA-Linux-x86_64-465.24.02.run
用gpu的：
![-w544](media/16195995291180.jpg)


不用gpu的：
![-w544](media/16196003679160.jpg)

RUST_LOG=trace ./lotus-bench sealing --sector-size 2KiB

重启后， 用gpu的：
![-w524](media/16196005575763.jpg)
