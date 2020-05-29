前端代码和资源的压缩：
让资源文件更小，加快文件在网络中的传输，让网页更快的展现，降低带宽和流量开销；

压缩方式：js，css，图片，html代码的压缩，Gzip压缩。

### js代码压缩：
一般是去掉多余的空格和回车，替换长变量名，简化一些代码写法等，
代码压缩工具很多UglifyJS(压缩，语法检查，美化代码，代码缩减，转化)、YUI Compressor(来自yahoo，只有压缩功能)、
Closure Compiler(来自google，功能和UglifyJS类似，压缩的方式不一样)，有在线工具tool.css-js.com，应用程序，编辑器插件。

### css代码压缩：
原理和js压缩原理类似，同样是去除空白符，注释并且优化一些css语义规则等，
压缩工具CSS Compressor(可以选择模式)。


### html代码压缩：
不建议使用代码压缩，有时会破坏代码结构，
可以使用Gzip压缩，
当然也可以使用htmlcompressor工具，不过转换后一定要检查代码结构。

### img压缩：
一般图片在web系统的比重都比较大，
压缩工具：tinypng，JpegMini，ImageOptim。

### zip压缩：

配置nginx服务，
gzip on|off，
gzip_buffers 32 4K|16 8K #缓冲(在内存中缓存几块？每块多大)，
gzip_comp_level [1-9] #推荐6 压缩级别(级别越高，压的越小，越浪费CPU计算资源)，
gzip_disable #正则匹配UA 什么样的uri不进行gzip，
gzip_min_length 200 #开始压缩的最小长度，
gzip_http_version 1.0|1.1 #开始压缩的http协议版本，

gzip_proxied #设置请求者代理服务器，

该如何缓存内容，
gzip_types text/plain applocation/xml #对哪些类型的文件用压缩，
gzip_vary on|off #是否传输gzip压缩标志。其他工具：自动化构建工具Grunt。