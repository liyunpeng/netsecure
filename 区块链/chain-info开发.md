### 禁止本机以外的地址访问本服务
bind = "127.0.0.1" 表示只允许本地访问， 其他地址不能访问， 如本地地址为192.168.19.84， 而：

![-w744](media/16106092841061.jpg)

直接显示这个错误； 
![-w1244](media/16106094231872.jpg)

### 反射


### 反射应用之一： 实现rpc调用

![-w1765](media/16106224445563.jpg)



### 缺少主键
没有主键的表， 打开时报错：
![-w1107](media/16110249840524.jpg)

可以在唯一索引上建立主键：
```
Height        int             `gorm:"primary_key;unique_index:height_index;type:bigint(20);comment:'fil'" json:"height"`
```
automigrage后有： 
![-w897](media/16110253758074.jpg)


### 建立唯一索引
```
Height        int             `gorm:"primary_key;unique_index:height_index;type:bigint(20);comment:'fil'" json:"height"`
```
![-w1493](media/16110251227259.jpg)


### 本地地址添加代理ip服务器的百名单 
获取本主机公网ip地址
![-w1232](media/16110352028709.jpg)
得到
![-w877](media/16110352282741.jpg)
将这个地址添加到海量ip的百名单里：
![-w1030](media/16110352930252.jpg)
![-w504](media/16110353117171.jpg)
![-w895](media/16110353360860.jpg)

点击打开链接：
![-w1692](media/16110353579627.jpg)
可以看到分配了ip


### 超时访问
![-w1769](media/16110395315595.jpg)


### 限流访问
限流访问， 对api做限流， 如果一个api太频繁， 识别到这个ip， 对这个IP做如下返回：
```
{
        "statusCode": 429,
        "error": "Too Many Requests",
        "message": "Rate limit exceeded, retry in 1 minute"
}
```
这时就没法得到他的数据了

### 线上hotfix
线上分支需要用master分支， 
测试环境要用test分支， 
如果测试环境也用master分支， 有时需要线上解决问题时， 这时master已经提交很多了， 这些没有详细测试， 为了解决一个紧急问题， 需要把这些没有测试的提交都进入到线上版本，这是有极大风险的， 是不允许的。 

线上紧急解决问题， 叫做hotfix, 需要在那个发布版本时的提交点，切出一个临时分支出来， 然后在这个分支上， 在fix提交，然后在这个临时分支发布版本， 所以每次发布线上发布版本时， 要用这个提交号。 如果没有提交， 就可以在当钱master直接提交。  
