---
对map的好的使用习惯
1. 预估 map 容量， 尽量减少扩容的次数
2. 
内置类型用值，构造的 struct 类型用指针
指针类型会影响 golang. gc 的速度
程序使用 runtime.ReadMemStats() 函数来获取堆的使用信息。它打印四个值：



---
map不能寻址
如果value是结构体， 不能直接修改结构体里的值，
要想修改value里的值，有两种做法：
一是修改value为结构体指针， 一是用临时变量， 然后map key中心只想这个临时结构体变量

---
map[key]判断键是否存在
map[key]会返回两个值， 一个是value,一个是表示该key 是否存在，不存在， 返回的value是0， 第二个值为false

---
键类型与值类型：
map 的键可以是任意内建类型或者是struct类型，map的值可以是使用==操作符的表达式
slice，

function 和 包含 slice 的 struct 类型不可以作为 map 的键，否则会编译错误

map 的值一般声明为接口类型，以容纳不同类型的值

---
函数间传递map
在函数之间传递 slice 和 map 是相当廉价的，因为他们不会传递底层数组的拷贝

---
map如何顺序读取：
map本身不能顺序读取，是因为他是无序的，想要有序读取，首先的解决的问题就是，把ｋｅｙ变为有序，所以可以把key放入切片，对切片进行排序，遍历切片，通过key取值。

---
map 没有容量，只有长度，用len 获取，不能append,  
1.slice 有容量的约束，不过可以通过内建函数 append 来增加元素。
2.map 没有容量一说，所以也没有任何增长限制。
3.内建函数 len 可以用来获得 slice 和 map 的长度。
4.内建函数 cap 只能作用在 slice 上。

---
map 的底层实现：
文件： src/runtime/hashmap.go: 
// A header for a Go map.
type hmap struct {
	// Note: the format of the Hmap is encoded in ../../cmd/internal/gc/reflect.go and
	// ../reflect/type.go. Don't change this structure without also changing that code!
	count     int // # live cells == size of map.  Must be first (used by len() builtin)
	flags     uint8
	B         uint8  // log_2 of # of buckets (can hold up to loadFactor * 2^B items)
	noverflow uint16 // approximate number of overflow buckets; see incrnoverflow for details
	hash0     uint32 // hash seed

	buckets    unsafe.Pointer // array of 2^B Buckets. may be nil if count==0.
	oldbuckets unsafe.Pointer // previous bucket array of half the size, non-nil only when growing
	nevacuate  uintptr        // progress counter for evacuation (buckets less than this have been evacuated)

	extra *mapextra // optional fields
}
buckets 实际是指向的的bmap结构的指针， 是一个链表数组， 数组里的每个元素是个指向链表的指针，
链表的每个节点至多存放8个键值对，
键值对的key的哈希值的高8位确定在数组中的第几个链表， 后8位表示在链表中的确切位置

src/runtime/hashmap.go:
// A bucket for a Go map.
type bmap struct {
	// tophash generally contains the top byte of the hash value
	// for each key in this bucket. If tophash[0] < minTopHash,
	// tophash[0] is a bucket evacuation state instead.
	tophash [bucketCnt]uint8
	// Followed by bucketCnt keys and then bucketCnt values.
	// NOTE: packing all the keys together and then all the values together makes the
	// code a bit more complicated than alternating key/value/key/value/... but it allows
	// us to eliminate padding which would be needed for, e.g., map[int64]int8.
	// Followed by an overflow pointer.
}



