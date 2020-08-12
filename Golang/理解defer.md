defer 底层实现： 结构体_defer  和两个函数都在runtimer/runtime2.go里定义。 
具名返回值 表示 返回值在声明时， 有名字。 返回值声明也可以没有名字。 
defer可以操作具名返回值。 
```
type _defer struct {
	siz     int32
	started bool
	sp      uintptr // sp at time of defer  指向了defer所在函数的栈指针
	pc      uintptr
	fn      *funcval  指向defer所在的函数
	_panic  *_panic // panic that is running defer
	link    *_defer  
}
```

defer处执行的函数：
func deferproc(siz int32, fn *funcval) { // arguments of fn follow fn
把fn出入到goroutine链表里
在函数return前， 调用
func deferreturn(arg0 uintptr) {
把fn从goountine从链表里取出来，然后执行。 所以defer多出来的调用不仅仅是一个call语句。
defer 会拷贝参数， 还有一些延迟， 网上有测试， 单纯一个defer， 里面什么都不做， 也要增加耗时20ns.
所以defer非常耗时
defer的用法; defer应该只用来捕获panic的处理，其他资源释放等操作，锁释放等操作，
这些都不会引起paniic的，程序有多个退出路径， 都可以要用goto去做，避免用defer
