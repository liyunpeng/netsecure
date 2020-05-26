没有go.mod的工程代码如何变成go.mod管理的代码，移花接木：

下载的代码工程， 如果没有go.mod, 没有用mod管理， 一般会有vendor目录， 
他会把自己的代码页放在vendor里面， 这有两个问题; 
1. 代码重复，  vendor设置断点有效，  而工程代码无效
2. vendor 里的代码修改无效， 
所以还是需要编程go mod管理的代码。 
正常情况下， 删除vendor目录  go mod init 工程名， go mod tidy, go mod 

vendor三个目录就可以搞定。 
中间遇到过的问题总结：
1. 工程代码太老， 引用的第三方代码，已经变了，调用的第三方方法不存在了， 
如go mod tidy时报错：
can't find package 
代码引用的包的路径变了。 
用go mod 方式， 以i18n这个包，介绍 解决的步骤; 
1.  把原vendor下的i18n 目录考到本地的GOPATH目录下， 
如果有多个包有问题， 一次性的在这个步骤，都复制过去
2. 删除原vendor目录， 如果不删除， go mod 会包vendor convert错误， 
3  修改go.mod, 增加一行：
replace (
github.com/mattermost/gorp => D:\gomodpath\gorp
）
	github.com/nicksnyder/go-i18n/i18n => D:\gomodpath\i18n
)

注意go.mod里没有双引号，和单引号

---


用go mod管理下的代码，  每个国家有一定的阻隔， 有专门的代理可以取到代码， 会自动到代理请求下载， 有多个代理可以选择， 常用的代理有https://proxy.golang.org等
使用go mod的好处， 比如golang.org/x，在大陆不能下载， 有人把他放到了github上了， 在没有go mod之前， 需要自己到github上考取这些golang.org/x代码到本地的gopath代码路径下。有了go mod， 就不要这样一个一个拷贝了，go mody tidy会自动检查依赖包，然后又代理下载。


代理连接不上的错误
$ export GO111MODULE=on
allen@allen-PC MINGW64 /f/GoWorkSpace/hello
$ go run server.go
开启了go mod模式， 就算有错误，是这样的错误打印，表示代理连接不上
build command-line-arguments: cannot load github.com/labstack/echo: module github.com/labstack/echo: Get https://proxy.golang.org/github.com/labstack/echo/@v/list: dial tcp 216.58.200.49:443: connectex: A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.

关闭god 后，	GOPATH要设置为项目目录
allen@allen-PC MINGW64 /f/GoWorkSpace/hello
$ export GO111MODULE=off
allen@allen-PC MINGW64 /f/GoWorkSpace/hello
$ go run server.go
关闭了go mod, 错误打印语句是提示在GOROOT, GOPATH中找不到包路径
server.go:6:5: cannot find package "github.com/labstack/echo" in any of:
        D:\Programs\go\src\github.com\labstack\echo (from $GOROOT)
        E:\GoModPath\src\github.com\labstack\echo (from $GOPATH)


replace 语句错误 ， 本地路径错误1：
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg => D:\gomodpah\localpkg1111111111
对应
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy
test imports
        github.com/localpkg: cannot find module providing package github.com/localpkg

replace 语句错误 ， 本地路径错误2：
gitbash运行在window路径， go mod只认windows路径， 虽然GOPATH写成linux格式认， 但是go.mod里是不认linux格式的路径
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg => /d/gomodpah/localpkg/

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy
test imports
        github.com/localpkg: cannot find module providing package github.com/localpkg

语法错误， go.mod有严格语法， replace中的=>后面要有空格
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg =>D:\gomodpah\localpkg

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy
go: errors parsing go.mod:
F:\GoWorkSpace\test\go.mod:5: usage: replace module/path [v1.2.3] => other/module v1.4
         or replace module/path [v1.2.3] => ../local/directory


引用的本地包没有go.mod的错误
引用的本地包需要用go mod init生成一个go.mod文件， 如果没有这个文件， 
有如下错误：
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ ls /d/gomodpah/localpkg/
a.go

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy
go: test imports
        github.com/localpkg: parsing D:\gomodpah\localpkg\go.mod: open D:\gomodpah\localpkg\go.mod: The system cannot find the file specified.



正确写法：
被引用的包有go mod init生成的.go文件
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg => D:\gomodpah\localpkg

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy

go mod tidy 成功后， 会修改go.mod文件， 会添加一行require：
require github.com/localpkg v0.0.0-00010101000000-000000000000，
go.mod完整内容：
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg => D:\gomodpah\localpkg

require github.com/localpkg v0.0.0-00010101000000-000000000000


指定版本， go mod tidy后生成的就不会有长长的数字：
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg v0.0.0 => D:\gomodpah\localpkg
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go mod tidy

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

replace github.com/localpkg v0.0.0 => D:\gomodpah\localpkg

require github.com/localpkg v0.0.0

windows上也要配置GOROOT, 否则运行时找不到的错误
在gitbash运行go build时， 没有编译出来.exe文件， 而且go gun main.go 时， 也会提示这样的错误：
allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ go run main.go
exec: "C:\\Users\\allen\\AppData\\Local\\Temp\\go-build234586106\\b001\\exe\\main": file does not exist
这是因为windows没有设置GOPATH的环境变量，只在gitbash设置linux格式的环境变量不够用， 还要在windows的我的计算机设置环境变量。 在windows工作，要注意环境变量和路径的格式


递归依赖都写到一个go.mod里
如本程序test依赖于github.com/localpkg， github.com/localpkg又依赖于github.com/localpkga， github.com/localpkga也在本地里， replace语句都写在test的go.mod里即可：
$ cat /d/gomodpah/localpkg/a.go
package localpkg

import "github.com/abc"

func F123(){
        abc.Localpkgaf()
}

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat /e/abc/
a.go    go.mod

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat /e/abc/go.mod
module abc

go 1.13

allen@allen-PC MINGW64 /f/GoWorkSpace/test (master)
$ cat go.mod
module test

go 1.13

require (
        github.com/abc v0.0.0-00010101000000-000000000000 // indirect
        github.com/localpkg v0.0.0-00010101000000-000000000000
)

replace (
        github.com/abc => E:\abc
        github.com/localpkg => D:\gomodpah\localpkg
)
 github.com/localpkg 依赖于github.com/abc， go mod tidy会给go.mod里依赖排序， 第一行是所有依赖的基础，  上一行是下一行的依赖。 

对cannot find module， 单独下载module
cannot find module单独下载这个module, 有时这个module从属于某个包， 下载这个包， 然后到这个module目录下go mod init module名， 然后在自己项目下的go.mod加上replace语句
allen@allen-PC MINGW64 /f/GoWorkSpace/logmanager (master)
$ go mod tidy
logmanager/src/services imports
        go.etcd.io/etcd/clientv3 imports
        github.com/coreos/etcd/pkg/logutil imports
        github.com/coreos/go-systemd/journal: cannot find module providing package github.com/coreos/go-systemd/journal
解决办法1 windows：
第一步：
 journal下go mod init  journal, 生成go.mod
allen@allen-PC MINGW64 /d/gomodpah/go-systemd/journal (master)
$ go mod init journal
go: creating new go.mod: module journal

第二部： 在自己项目下， 修改go.mod, 加入一条replace语句， 注意路径不要写错，一个字母不能错，这里是gomodpah， 不是gomodpath, 所以写路径时， 一定要拷贝过来，
replace github.com/coreos/go-systemd/journal => D:\gomodpah\go-systemd/journal

解决办法2 ubuntu：
master@etcd0:~/gomodpath/gitclone$ git clone http://github.com/coreos/go-systemd

master@etcd0:~/gomodpath/gitclone/go-systemd$ go mod init go-systemd

自己项目的go.mod添加：
replace github.com/coreos/go-systemd => /home/master/gomodpath/gitclone/go-systemd
 

引用本地的包的做法
a模块使用go mod init github.com/xxx/a;
2、上传a模块到github对应xxx账号；
3、在b引用的时候，也不用replace了，直接import "github.com/xxx/a", 让go mod自己去缓存；


require定义了一个本地包， 但replace没有他的定向， 会包如下错误，
$ go run user_main.go database.go
go: proto_gen@v0.0.0-00010101000000-000000000000: malformed module path "proto_gen": missing dot in first path element
require里不用的， 可以手动删除

goland 在使用go mod后， import 包解析不出go mod包的问题
goland更新到最新， 勾选如下：

然后go mod vendor, 把当前依赖的代码都下载到当前目录的vendor目录， 没有vendor目录会创建vendor目录， 然后下载，  
vendor下载好后， goland对import一段时间后才能解析后， 耐心等待10分钟

代码里import的路径写错， go mod下载包时有错误：but does not contain package 
import github.com/golang/protobuf/protobuf  这个包并不存在， 
$ go run user_main.go database.gobut was required as
go: downloading golang.org/x/crypto v0.0.0-20191108234033-bd318be0434a
go: extracting golang.org/x/crypto v0.0.0-20191108234033-bd318be0434a
go: finding golang.org/x/crypto v0.0.0-20191108234033-bd318be0434a
build command-line-arguments: cannot load github.com/golang/protobuf/protobuf: module github.com/golang/protobuf@latest found (v1.3.2), but does not contain package github.com/golang/protobuf/protobuf


declare 和require的不匹配， 把required的替换掉
$ go mod vendor
go: github.com/micro/go-grpc@v1.0.1 requires
        github.com/micro/go-plugins@v1.1.0 requires
        github.com/golang/lint@v0.0.0-20190313153728-d0100b6bd8b3: parsing go.mod:
        module declares its path as: golang.org/x/lint
                but was required as: github.com/golang/lint

github.com/golang/lint => F:\GoWorkSpace\micro-dianshang\vendor\golang.org\x\lint

热心朋友给的解决办法，不用replace:



$ go run user_main.go database.go
build command-line-arguments: cannot   github.com/micro/go-plugins/client/grpc: module github.com/micro/go-plugins@latest found (v1.5.1), but does not contain package github.com/micro/go-plugins/client/grpc
大概意思：
程序所引用的github.com/micro/go-plugins/client/grpc 加载不进来， 因为github.com/micro/go-plugins@latest found (v1.5.1) 这个包没有github.com/micro/go-plugins/client/grpc。 
为了验证， 到D:\gomodpah\pkg\mod\github.com\micro\go-plugins@v1.5.1\client
这个路径看一下， 果然没有grpc这个目录。 

可能原因： 两个都在micro里面， 这两个有依赖关系的包版本不一致，go-grpc 使用了go-plugins里的代码， 即go-grpc包依赖于go-plugins包。  go-grpc 是v1.0.1， go-plugins是v1.5.1， 	

在pkg/mod下都是带版本号的， 在vendor下面就不带版本号了， 而且没有问题的包才会进vendor， 这里go-grpc 引用了go-plugins里不存在的路径， go-grpc go-plugins都有问题， 所以不会进vendor。 


missing dot 解决
.go代码里引用了一个不存在的包名， go mod vendor时会包missing dot的错误
import model "proto"
proto这个包不存在，导致：
$ go mod vendor
micro-etcd imports
        proto: malformed module path "proto": missing dot in first path element

在go.mod里添加如下， 可解决这个问题。
replace proto => F:\GoWorkSpace\micro-etcd\proto
go mod vendor后， 在require里会自动生成proto v0.0.0, 一般v0.0.0都是本地包。 
proto v0.0.0-00010101000000-000000000000

cannot find module 错误的解决办法
$go mod vendor遇到如下错误：
logmanager/src/services imports
        go.etcd.io/etcd/clientv3 imports
        github.com/coreos/etcd/pkg/logutil imports
        github.com/coreos/go-systemd/journal: cannot find module providing package github.com/coreos/go-systemd/journal
解决办法：go.mod里添加replace:
replace logmanager/src/services => D:\goworkspace\logmanager\src\services

本地路径找不到的错误
build _/D_/goworkspace/logmanager/src/web: cannot find module for path _/D_/goworkspace/logmanager/src/web
go.mod里有replace了， 并且src/web也建立go.mod了， 原因是代码里import错误：
import "./src/web"
需要改成：
import "src/web"

依赖包由gopath管理转为go mod管理， 需要修改的
用mod管理，import不能再有相对于当前文件所在的相对路径， 要用基于项目根目录的相对路径。 
比如之前写的路径
import ../conf
要改为 
import src/conf
go.mod ：
src/conf => D:\goworkspace\logmanager\src\conf


解决requires
Administrator@WIN-U9IV8COBU35 MINGW64 /d/goworkspace/micro-dianshang (master)
$ go mod tidy
go: github.com/micro/go-grpc@v1.0.1 requires
        github.com/micro/go-plugins@v1.1.0 requires
        github.com/micro/go-config@v1.1.0 requires
        github.com/testcontainers/testcontainer-go@v0.0.2: parsing go.mod:
        module declares its path as: github.com/testcontainers/testcontainers-go
                but was required as: github.com/testcontainers/testcontainer-go

go get -u github.com/testcontainers/testcontainers-go
然后再go.mod里replace：


再记require问题
$ go run main.go
go: finding github.com/grpc-ecosystem/grpc-opentracing latest
go: github.com/openzipkin/zipkin-go-opentracing: github.com/openzipkin/zipkin-go-opentracing@v0.4.5: parsing go.mod:
        module declares its path as: github.com/openzipkin-contrib/zipkin-go-opentracing
                but was required as: github.com/openzipkin/zipkin-go-opentracing
解决办法：
自己项目的代码应用了老的包的路径： 把
import github.com/openzipkin/zipkin-go-opentracing 改为
import github.com/openzipkin-contrib/zipkin-go-opentracing 