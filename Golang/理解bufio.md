#### NewReader
newreader接收的参数确定了数据的源头， 源头可以是字符串， 也可以是文件， 只要实现了reader方法即可，如：
```
sr := strings.NewReader("1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ")
buf := bufio.NewReaderSize(sr, 0) 指定缓冲区大小，为0或小于16，实际就用16
b = make([]byte, 3)
buf.Read(b)
```
buf.Read一次io操作，将缓冲区读满, 即要的数据在缓冲区里有，就直接从缓冲里读， 没有， 就要一次io操作， 不管read指定读多少， 一次io操作都要把缓冲区读满。 

buf.Buffered()返回缓冲区剩余空间大小

#### newScannder
newscannder接收的参数对象也必须实现io.reader接口， 
scanner的scan方法就是等待一行输入， 终端按下回车键，一行输入结束，input.scan()就解除阻塞， input.Text()读走数据， 再次走到input.Scan()就会再次进入阻塞，等待下一行输入。

如net.Conn网络输入流，实现了reader接口。
举个例子，聊天室程序代码：
```
func handleConn1(c net.Conn) {
input := bufio.NewScanner(c)
inputC := func(sig chan struct{}) {
	for i := 0; input.Scan(); i++ {
		sig <- struct{}{}
		if i == 0 {
			clientinfo.Name = input.Text()

			messages <- c.RemoteAddr().String() + " " + clientinfo.Name + "进入聊天室"

			clientChans[clientinfo] = true // 作为索引的结构体不能用new的方式，因为new放回的是指针地址
		} else {
			s := input.Text()
			debugLog(s)
			messages <- clientinfo.Name + " : " + s
		}
	}
}
InputTimeout(c, 30*time.Second, inputC)
```
