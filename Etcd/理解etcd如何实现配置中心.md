本文主要理解, etcd服务键值存储了配置信息，作为配置信息的键值改变后，应用程序不用重启，修改的配置就可生效。
结合实验和实验的log和代码理解：
浏览器输入：
/logagent/192.168.0.142/logconfig
输入框输入：
```json
[
	{
		"topic":"nginx_log",
		"log_path":"D:\\log1",
		"service":"test_service",
		"send_rate":1000
	}
]
```
输入框里写的内容实际是一组配置信息字符串，这个配置信息主要表示要监控的文件的路径全名log_path，从被监控文件读出的内容发送给kafka消息服务器的主题topic
因为这个字符串要被服务端解析成一个配置对象，所以该字符串不能有多有多余的逗号，因为这里只有一项，大括号的后面不能有逗号

输入完成后， 点提交， 服务端就会出现相应的log：
etcd服务watch到新的键值对：
``` 
etcd key = /logagent/192.168.0.142/logconfig , value = [
	{
			"topic":"nginx_log",
			"log_path":"D:\\log1",
			"service":"test_service",
			"send_rate":1000
	}
]
```
从etcd得到的配置字符串解析出的配置对象:  [{nginx_log D:\log1 test_service 1}]
hdcloud tail管理者重新加载配置
hdcloud tail监控的文件不存在，则为此文件新建一个tail对象
在Tail服务里增加一个被监控的文件： {nginx_log D:\log1 test_service 1000}
新的监控文件对应一个新的tail对象，

以上是点提交后，服务端出现的log，借这个log，说一下etcd键值服务作为配置中心的应用：
提交的内容是一个键值对， 这个键值对要写到etcd服务器。 因为这个键被etcd watch了，
所以该键的值得变化被监控到， 在对该键阻塞解除的地方， 重新读取键的值：

etcd_service.go 把键的值写到通道ConfChan：
```
for {
		for _, watchC := range watchChans {
			select {
			case wresp := <-watchC:
				for _, ev := range wresp.Events {
					ConfChan <- string(ev.Kv.Value)
					fmt.Printf("etcd服务watch到新的键值对： etcd key = %s , etcd value = %s \n", ev.Kv.Key, ev.Kv.Value)
				}
			default:
			}
		}
		time.Sleep(time.Second)
}
```
 之所以写入通道， 是为了让监控循环尽快结束掉本次监控的处理，以便监控其他键值的变化，
用写通道再合适不过，通道的写一边为监控分发的消息， 而通道的读那一边可以慢悠悠的处理，不会拖住监控循环卡在这里。通道实现了消息的分发者和处理者这种模式， 
消息的分发者和消息的处理者解耦，分发者不用等处理者，不会因为一个慢而拖住另一个的速度

tail_service.go 做为通道消息的处理者处理消息：
```golang
func (t *TailManager) Process() {
	for etcdConfValue := range ConfChan {
		logs.Debug("log etcdConfValue: %v", etcdConfValue)

		var logConfArr []conf.LogConfig

		err := json.Unmarshal([]byte(etcdConfValue), &logConfArr)
		fmt.Println("从etcd得到的配置字符串解析出的配置对象: ", logConfArr)

		if err != nil {
			fmt.Println("unmarshal failed, err: %v etcdConfValue :%s", err, etcdConfValue)
			continue
		}

		err = t.reloadConfig(logConfArr)
		if err != nil {
			logs.Error("reload config from etcd failed: %v", err)
			continue
		}
	}
}
```
这个消息的处理者，就是把配置消息字符串解析出配置对象， 打印的log:
从etcd得到的配置字符串解析出的配置对象:  
[{nginx_log D:\log1 test_service 1
配置对象告诉程序，现在被监控的文件变成D:\log1， 这提现了配置改变了， 不用重启程序，就能让这个配置生效
这个文件新增的信息要发往的kafka服务器的消息主题是nginx_log

据此可以测试，用echo命令向D:\log1追加内容
echo messagebody >> D:\log1

观察服务端出现log:
kafka生产者向kafka broker发送消息，消息字符串= messagebody , 消息主题= nginx_log
