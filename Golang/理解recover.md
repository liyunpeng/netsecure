### 哪些能recover
recover 只有在 defer 函数中才有用，在 defer 的函数调用的函数中 recover 不起作用，如下实例代码不会 recover：
```
package main
import "fmt"
func main() {
  f := func() {
      if r := recover(); r != nil {
          fmt.Println(r)
      }
  }

  defer func() {
      f()
  } ()

  panic("ok")
}
```
执行时依旧会 panic，结果如下：
```
$ go run t.go 
panic: ok

goroutine 1 [running]:
main.main()
  /Users/winlin/temp/t.go:16 +0x6b
exit status 2
```

一般的 panic 都是能捕获的，比如 Slice 越界、nil 指针、除零、写关闭的 chan

****

###哪些不能 Recover
下面看看一些情况是无法捕获的：
1.  Thread Limit，超过了系统的线程限制  
    当前线程数超过ThreadLimit，就panic，这个panic 是无法 recover的。  
    
    默认是 1 万个物理线程，可以调用 runtime 的debug.SetMaxThreads 设置最大线程数。  
    
    ThreadLimit限制的并不是goroutine的数目，而是使用的系统线程的限制。  

2. Concurrent Map Writers，竞争条件，同时写 map，参考下面的例子。推荐使用标准库的 sync.Map 解决这个问题。
