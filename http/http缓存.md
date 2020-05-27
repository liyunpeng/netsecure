3xx一般表示重定向， 但304不是，表示缓存， 
服务器的响应会包括last-modified, 是文件的最新修改时间， 以秒为单位， 
浏览器每次请求时， 会带上这个时间，如果浏览器时间小于这个时间， 
304 Not Modified：表示客户端发送附带条件的请求（GET方法请求报文中的IF…）时，条件不满足。返回304时，不包含任何响应主体。虽然304被划分在3XX，但和重定向一毛钱关系都没有

## 缓存开关
缓存开关是： pragma， cache-control。

缓存控制：控制缓存的开关，用于标识请求或访问中是否开启了缓存，使用了哪种缓存方式。

缓存控制
在http中，控制缓存开关的字段有两个：Pragma 和 Cache-Control。

### Pragma
Pragma有两个字段Pragma和Expires。Pragma的值为no-cache时，表示禁用缓存，Expires的值是一个GMT时间，表示该缓存的有效时间。
Pragma是旧产物，已经逐步抛弃，有些网站为了向下兼容还保留了这两个字段。如果一个报文中同时出现Pragma和Cache-Control时，以Pragma为准。同时出现Cache-Control和Expires时，以Cache-Control为准。即优先级从高到低是 Pragma -> Cache-Control -> Expires

### Cache-Control
在介绍之前，先啰嗦两个容易忽视的地方：

符合缓存策略时，服务器不会发送新的资源，但不是说客户端和服务器就没有会话了，客户端还是会发请求到服务器的。
Cache-Control除了在响应中使用，在请求中也可以使用。我们用开发者工具来模拟下请求时带上Cache-Control：勾选Disable cache，刷新页面，可以看到Request Headers中有个字段Cache-Control: no-cache。

* no-cache 可以在本地缓存，可以在代理服务器缓存，但是这个缓存要服务器验证才可以使用 
* no-store 彻底得禁用缓冲，本地和代理服务器都不缓冲，每次都从服务器获取
## 缓存校验
缓存校验：如何校验缓存，比如怎么定义缓存的有效期，怎么确保缓存是最新的。
缓存校验有：Expires，Last-Modified，etag。
### 1. Expires
在缓存中，我们需要一个机制来验证缓存是否有效。比如服务器的资源更新了，客户端需要及时刷新缓存；又或者客户端的资源过了有效期，但服务器上的资源还是旧的，此时并不需要重新发送。缓存校验就是用来解决这些问题的，在http 1.1 中，我们主要关注下Last-Modified 和 etag 这两个字段。

### 2. Last-Modified
*  1.服务端在返回资源时，会将该资源的最后更改时间通过Last-Modified字段返回给客户端。
*  2.客户端下次请求时通过If-Modified-Since或者If-Unmodified-Since带上Last-Modified，
*  3.服务端检查该时间是否与服务器的最后修改时间一致：
  (1)如果一致，则返回304状态码，不返回资源； 
  (2)如果不一致则返回200和修改后的资源，并带上新的时间。

If-Modified-Since和If-Unmodified-Since的区别是：
If-Modified-Since：告诉服务器如果时间一致，返回状态码304
If-Unmodified-Since：告诉服务器如果时间不一致，返回状态码412

### 3. etag
单纯的以修改时间来判断还是有缺陷，比如文件的最后修改时间变了，但内容没变。对于这样的情况，我们可以使用etag来处理。
etag的方式是这样：服务器通过某个算法对资源进行计算，取得一串值(类似于文件的md5值)，之后将该值通过etag返回给客户端，客户端下次请求时通过If-None-Match或If-Match带上该值，服务器对该值进行对比校验：如果一致则不要返回资源。
If-None-Match和If-Match的区别是：
If-None-Match：告诉服务器如果一致，返回状态码304，不一致则返回资源
If-Match：告诉服务器如果不一致，返回状态码412


