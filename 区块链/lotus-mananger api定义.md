[TOC]
# 接口文档	

``` scala
统一说明：code在0的时候代表正常，1代表错误，此时msg会有原因。有些接口返回体中的data可能为空
```

## 扇区

### 1.列表展示

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



### 2.复合条件查询

``` http
Url：/sector-state-filter
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50,
	"createTimeStart":"202007151601",
	"createTimeEnd":"202007151601",
	"updateTimeStart":"202007151601",
	"updateTimeEnd":"202007151601",
	"mediaId":1
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



## 复制证明任务

### 1.列表查询

```http
Url：/latest-seal-task-list
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
						"taskType":"PreCommitPhase1",
						"isTaken":true,
						"finished":"true",
						"miner":119230,
						"ip":"127.0.0.1",
						"errMsg":"uuid for search",
						"resultStatus":1,
						"createTime":"202007151601",
						"createTime":"202007151601"
				}
				],
				"totalSectorInPeriod":1000, // for pages calculate
				"totalSectorInPage":50,
		}
}
```



### 2.复合条件查询

```http
Url：/seal-task-filter
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50,
	"createTimeStart":"202007151601",
	"createTimeEnd":"202007151601",
	"updateTimeStart":"202007151601",
	"updateTimeEnd":"202007151601",
	"taskType":"PreCommitPhase1",
	"isTaken":false,
	"finished":true,
	"resultStatus":2,
	"sectorId":113,
	"miner":119230,
	"ip":"127.0.0.1"	
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				sectorList:[
				{
						"id":1,
						"sectorId":1,
						"taskType":"PreCommitPhase1",
						"isTaken":true,
						"finished":"true",
						"miner":119230,
						"ip":"127.0.0.1",
						"errMsg":"uuid for search",
						"resultStatus":1,
						"createTime":"202007151601",
						"createTime":"202007151601"
				}
				],
				"totalSectorInPeriod":1000, // for pages calculate
				"totalSectorInPage":50,
		}
}
```



### 3.重置任务

```http
Url：/seal-task-reset
Method: POST
RequestBody:{
	"taskId":1024,
	"reason":"just for fun"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
		}
}
```



### 4.重发任务

```http
Url：/seal-task-resend
Method: POST
RequestBody:{
	"taskId":1024,
	"reason":"just for fun"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
		}
}
```



## 时空证明任务

### 1.列表查询

```http
Url：/latest-wdpost-task-list
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				taskList:[
				{
						"id":1,
						"sectorId":1,
						"taskType":"PreCommitPhase1",
						"isTaken":true,
						"finished":"true",
						"miner":119230,
						"ip":"127.0.0.1",
						"errMsg":"uuid for search",
						"resultStatus":1,
						"createTime":"202007151601",
						"createTime":"202007151601"
				}
				],
				"totalTaskInPeriod":1000, // for pages calculate
				"totalTaskInPage":50,
		}
}
```



### 2.复合条件查询

```http
Url：/wdpost-task-filter
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50,
	"createTimeStart":"202007151601",
	"createTimeEnd":"202007151601",
	"updateTimeStart":"202007151601",
	"updateTimeEnd":"202007151601",
	"taskType":"PreCommitPhase1",
	"isTaken":false,
	"finished":true,
	"resultStatus":2,
	"sectorId":113,
	"miner":119230,
	"ip":"127.0.0.1"	
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				taskList:[
				{
						"id":1,
						"sectorId":1,
						"taskType":"PreCommitPhase1",
						"isTaken":true,
						"finished":"true",
						"miner":119230,
						"ip":"127.0.0.1",
						"errMsg":"uuid for search",
						"resultStatus":1,
						"createTime":"202007151601",
						"createTime":"202007151601"
				}
				],
				"totalTaskInPeriod":1000, // for pages calculate
				"totalTaskInPage":50,
		}
}
```



### 3.重置任务

```http
Url：/wdpost-task-reset
Method: POST
RequestBody:{
	"taskId":1024,
	"reason":"just for fun"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
		}
}
```



## 操作日志

### 1.列表展示

``` http
Url：/operation-list
Method: POST
RequestBody:{
	"page":1,
	"pageSize":50
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				operations:[
				{
						"id":1,
						"tableName":"tasks",
						"events":"sealTaskReset",
						"operater":"temp empty"
						"finished":"true",
						"operationType":"update",
						"operationTime":"202007151601",
						"targetId":1,
						"reason":"just for fun",
						"targetColumn":"is_taken",
						"originData":0,
						"updateData":1,
						"comments":"0 means not taken while 1 means have been taken",
						"sectorId":1, // only work when tableName is tasks,
						"cid":"bafyamag" // only work when tableName is post_task
				}
				],
				"totalRecords":1000, // for pages calculate
				"totalSectorInPage":50,
		}
}
```



### 2.复合条件查询

``` http
Url：/operation-filter
Method: POST
RequestBody:{
	"createTimeStart":"202007151601",
	"createTimeEnd":"202007151601",
	"events":"sealTaskReset"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				operations:[
				{
						"id":1,
						"tableName":"tasks",
						"events":"sealTaskReset",
						"operater":"temp empty"
						"finished":"true",
						"operationType":"update",
						"operationTime":"202007151601",
						"targetId":1,
						"reason":"just for fun",
						"targetColumn":"is_taken",
						"originData":0,
						"updateData":1,
						"comments":"0 means not taken while 1 means have been taken",
						"sectorId":1, // only work when tableName is tasks,
						"cid":"bafyamag" // only work when tableName is post_task
				}
				],
				"totalRecords":1000, // for pages calculate
				"totalSectorInPage":50,
		}
}
```



## 用户管理 （有时间做）

### 1.列表展示

``` http
Url：/user-list
Method: GET
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				users:[
				{
						"id":1,
						"userName":"bobo",
						"remark":"I don't know",
						"createTime":"202007151601"	
				}
				]
		}
}
```



### 2.增加管理员

``` http
Url：/user-add
Method: PUT
RequestBody:{
	"userName":"guoqing",
	"password":"wnlbakl112",
	"remark":"admin in admin"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				users:[
				{
						"id":1,
						"userName":"bobo",
						"remark":"I don't know",
						"createTime":"202007151601"	
				}
				]
		}
}
```



### 3.删除管理员

``` http
Url：/user-delete
Method: DELETE
RequestBody:{
	"id":1
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				users:[
				{
						"id":2,
						"userName":"bobo",
						"remark":"I don't know",
						"createTime":"202007151601"	
				} 
				] // users after delete
		}
}
```



### 4.编辑管理员

``` http
Url：/user-update
Method: POST
RequestBody:{
	"id":1,
	"password":"anlqg1nqp",
	"remark":"akmgal;"
}
ResponseBody:{
		"code":0, 
		"msg":"",
		"data":{
				users:[
				{
						"id":2,
						"userName":"bobo",
						"remark":"I don't know",
						"createTime":"202007151601"	
				} 
				] // users after update
		}
}
```





