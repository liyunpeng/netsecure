restful是对资源表示的一种规范， 
资源的表示包括资源的位置， 资源的操作， 规范就是对地址和操作的规范， 
资源的地址用http这种网络地址标志， 路径实现树的表示， 用中线， 不能用下划线， 一律小写字母。


### 普通api地址与restful的api地址的区别
以状态数据操作接口为例：

传统模式：
api/getstate.aspx- 获取状态信息
api/updatestate.aspx - 更新状态信息
api/deletestate.aspx - 删除该状态的数据

RESTful模式：
api/state 只需要这一个接口
GET 方式请求 api/state- 获取该状态的数据
POST 方式请求 api/state- 更新该状态的数据
DELETE 方式请求 api/state- 删除该状态的数据