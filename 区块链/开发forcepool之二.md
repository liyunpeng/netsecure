# 

问题原因：
收益数据由23:59:59改回到0点时， user端在修改的同时， 没有同步到admin端， 导致admin按23:59:59取数据， 而这个时间不再有数据， 所以显示可用余额显示为0 

今后措施： 
user端修改， 要同步修改到admin端


![-w1111](media/16050657572547.jpg)


计算机， 不管多复杂， 本质上还是数字世界， 是对这个世界的模拟

#### 1
![-w1713](media/16051629782636.jpg)
只有db.Debug() 时， 才会有 打印sql
(/Users/zhenglun1/goworkspace/forcepool/test/Backend/models/pool_user_income.go:141) 
[2020-11-12 14:35:27]  [25.35ms]  SELECT  sum(rewards) as rewards,  sum(income) as income , sum(format_income) as format_income , sum(format_rewards) as format_rewards, sum(fee) as fee, sum(fee_accurate) as fee_accurate,  sum(space) as space FROM  pool_user_income   WHERE ( user_code= '1603246349436606' )  

资产转移详情增加转出用户， 转入用户的三个表的转移前的历史记录数据，和转移后的数据。 三个表分别为矿池收益， spacerace奖励与释放， balance表


### 2
![-w1713](media/16051659958151.jpg)



![-w1776](media/16056673731277.jpg)


![-w1776](media/16056674139058.jpg)

![-w1776](media/16056702968272.jpg)


### orm 类的名字， 不要带S

![-w1357](media/16057549623655.jpg)


### rpc 参数
参数是数组， 并且参数的个数和类型都不固定的写法：
![-w1293](media/16092092666131.jpg)


![-w1240](media/16092094231397.jpg)


订单表与产品表连接，过滤订单表

完善算力校验接口

增加贷款的创建时间

修改创建时间小于当天0点的所有贷款汇总作为当天收益记录中的贷款

预生产用户表算力和订单算力校验， 找出有算力问题的用户，并且处理这些了这些用户

与运维协作解决新增表的字符集问题

资产转移功能需要将转出方的所有历史收益记录， 都转移到转入方下，共涉及到8个表的处理， 这个功能已经提交到预生产， 因为计划在数据呈现做好之后，再测试这个功能， 预生产暂时屏蔽，现在测试服务器可以测试这个功能， 涉及到的8个表如下： 
pool_user_income  汇总转移
pool_user_income_record  汇总转移，转入方和转出方各增加一条汇总记录

pool_spacerace_user_income 汇总转移，转入方和转出方各增加一条汇总记录

pool_reward_released 汇总转移， 转入方和转出方各增加一条汇总记录

user 更新buy_space, other_space 

purchase_orders  更新code

order_transfer   新增订单转移记录

asset_transfer_record  新增资产转移记录

汇总转移指： 转出方增加一条汇总减少的记录， 转入方增加一条汇总增加的记录， 即一减一加， 转出方减少的等于转入方增加的。 



### 编译选贤

![-w1080](media/16091174691802.jpg)

### debug 看到gorm输出原语句
![-w1123](media/16064489297812.jpg)

### 荣来数据库的设置与 AutoMigrate 
![-w1413](media/16064490306864.jpg)


![-w749](media/16064490489025.jpg)


### gas费
 
  一个区块有几百个转账
  f02 不会包括小费

### update语句， 用exec（‘update ） 



![-w1711](media/16068243753964.jpg)


### update 锁引起的超时
![-w1711](media/16068245687543.jpg)




添加转出用户详情接口
从订单整理出待转移用户列表， 添加转移用户列表
合并测试网福利修改到master
解决荣来数据库初始化问题
添加荣来资产转移权限
荣来用户转移执行接口对转入方检查
带转移资产添加可提现和已提现统计
计算含服务费率的荣来空间比列
打开对荣来数据库事务的commit
荣来待转移资产汇总

荣来待转移用户详情加测试网福利
完善荣来资产转移后的各个用户的资产转移详情
完善荣来资产转移后的荣来用户分页列表
添加荣来资产转移后的C端用户汇总接口
完善荣来资产转移后的用户资产详情接口，转移前的数据，转移的资产数据，转移后的数据均记录到数据库
添加新增3个接口的权限
添加荣来用户迁移列表接口

解决一般地址个数不对的问题
更新预生产， 生产
user后端矿池生成数据代码整理


 git commit models/BusinessAssetTransferRecord.go models/purchase_orders.go models/ronglai_transfer.go -m "用导入订单时的时间标记每个要转移的订单"


### 
程序连接数据库时报错， 程序无法启动：
panic: Error 1461: Can't create more than max_prepared_stmt_count statements (current value: 16382)

数据库看：
![-w470](media/16074307523281.jpg)

解决办法： 把max_prepared_stmt_count改到最大值


![-w923](media/16074340135039.jpg)


![-w923](media/16074340331270.jpg)


![-w925](media/16074341536739.jpg)

![-w1075](media/16074341828147.jpg)

![-w1075](media/16074341984530.jpg)


解决待转移详情的奖励的到账和备用金数据错误问题
spacerace奖励取pool_spacerace_user_income中的format_rewards值
详情小数点后显示过多的问题
统一算力比例精度
整理代码
同步到荣来数据库的订单记录原用户的code
向荣来数据数据数据库同步转入用户和balance金额
资产转移记录同步到荣来数据库
已转移的用户资产详情转移后记录与转移记录位置修改
解决资产转移后的Spacerace统计错误的问题


### 测试截图
待转移： 
![-w1075](media/16074802027632.jpg)


![-w1085](media/16074802849132.jpg)


![-w1072](media/16074803330246.jpg)


解决执行资产转移后，有其他订单导入，转移是的订单找不到的问题

修改资产转移的提现记录
服务结束时，关闭荣来数据库链接
解决提现后转移详情出错的问题
解决核算页面测试网福利无值，提现无值的问题
荣来账单汇总数据备注修改
订单号去重
修改同步到荣来数据库的转入用户的算力
核算接口数据精度调整
比例系数精度设定为12位小数
解决执行资产转移后，有其他订单导入，转移是的订单找不到的问题

![-w1072](media/16074803879855.jpg)


1. 恢复forcepool数据库
2. 清空荣来数据库
3. 重启admin
4. 导入订单， 
5. 执行转移前， 保存两个页面的截图： 汇总核算页面， 单个用户待转移详情页面
6. 执行转移

手动表格计算时， R1， R2的都取12位小数



### 版本号控制
![-w1277](media/16082749186663.jpg)

![-w1428](media/16082749381007.jpg)


![-w1426](media/16082749712668.jpg)


### 矿池收益计算
 余额 =  前置抵押 +  未释放( 包括惩罚) + 可用(含3个， 可用就做分配的, 新增备用金 ）
 期初        x1       y1      z1
 期末        x2
  收益 =  x2 - x1 + y2 - y1 +  z2 - z1

### 常见表连接
提供个sql查询语句，导出ForcePool未提币用户信息。
用户手机号、持有空间大小、可提币余额、认证状态
```sql
SELECT
  u.phone,
  u.name,
  u.email,
  u.buy_space + u.other_space,
  b.free,
  u.authentication_flag 
FROM
  balance b
  INNER JOIN user u ON b.code = u.code 
WHERE
  u.code NOT IN ( SELECT code FROM currency_transfer WHERE status = 4 AND push_time IS NOT NULL ) and b.coin_type=2;
```
  
  
### 前端 后端 对接api文档 
  前端分页展示， 前段要提供的参数， 要实现分页， 前端要向后端传这两个参数：  page, page_size。   可以先规定好前端要传给后端的， 和后端传给前端的， 如：
列表展示：
```http
Url：/latest-sector-list 
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				sectorList:[
				{
						"id":1,
						"sectorId":1,
						"mediaId":1,
						"state":"Proving",
						"msg":"Proving",
						"createTime":"202007151601",
						"createTime":"202007151601"
				}
				],
				"totalSectorInPeriod":1000, // for pages calculate
				"totalSectorInPage":50,
				"sectorInUpdate":32,
				"sectorNewCreate":15,
		}
}
```
文档模版可以是lotus-mananger api定义.md 这样的文档
  
如果页面上有两个列表， 就提供不同的参数， page, pageSize, 要注意区分