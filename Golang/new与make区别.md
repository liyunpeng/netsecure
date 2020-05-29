Go语言中的 new 和 make 主要区别如下：
* make 只能用来分配及初始化类型为 slice、map、chan 的数据。new 可以分配任意类型的数据；
* new 分配返回的是指针，即类型 *Type。make 返回引用，即 Type；
* new 分配的空间被清零。make 分配空间后，会进行初始化；