Kubernetes主要由以下几个核心组件组成：
etcd保存了整个集群的状态；
apiserver提供了资源操作的唯一入口，并提供认证、授权、访问控制、API注册和发现等机制；
controller manager负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
scheduler负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；
kubelet负责维护容器的生命周期，同时也负责Volume（CVI）和网络（CNI）的管理；
Container runtime负责镜像管理以及Pod和容器的真正运行（CRI）；
kube-proxy负责为Service提供cluster内部的服务发现和负载均衡；

分层架构
Kubernetes设计理念和功能其实就是一个类似Linux的分层架构，如下图所示

核心层：Kubernetes最核心的功能，对外提供API构建高层的应用，对内提供插件式应用执行环境
应用层：部署（无状态应用、有状态应用、批处理任务、集群应用等）和路由（服务发现、DNS解析等）
管理层：系统度量（如基础设施、容器和网络的度量），自动化（如自动扩展、动态Provision等）以及策略管理（RBAC、Quota、PSP、NetworkPolicy等）

kubelet
kubelet负责管理pods和它们上面的容器，images镜像、volumes、etc。
kube-proxy
每一个节点也运行一个简单的网络代理和负载均衡（详见services FAQ )（PS:官方 英文）。 正如Kubernetes API里面定义的这些服务（详见the services doc）（PS:官方 英文）也可以在各种终端中以轮询的方式做一些简单的TCP和UDP传输。
服务端点目前是通过DNS或者环境变量( Docker-links-compatible 和 Kubernetes{FOO}_SERVICE_HOST 及 {FOO}_SERVICE_PORT 变量都支持)。这些变量由服务代理所管理的端口来解析。
Kubernetes控制面板
Kubernetes控制面板可以分为多个部分。目前它们都运行在一个master 节点，然而为了达到高可用性，这需要改变。不同部分一起协作提供一个统一的关于集群的视图。
etcd
所有master的持续状态都存在etcd的一个实例中。这可以很好地存储配置数据。因为有watch(观察者)的支持，各部件协调中的改变可以很快被察觉。
Kubernetes API Server
API服务提供Kubernetes API （PS:官方 英文）的服务。这个服务试图通过把所有或者大部分的业务逻辑放到不两只的部件中从而使其具有CRUD特性。它主要处理REST操作，在etcd中验证更新这些对象（并最终存储）。


kubelet 的主要功能就是定时从某个地方获取节点上 pod/container 的期望状态（运行什么容器、运行的副本数量、网络或者存储如何配置等等），并调用对应的容器平台接口达到这个状态。O
kubelet 除了这个最核心的功能之外，还有很多其他特性：
    * 定时汇报当前节点的状态给 apiserver，以供调度的时候使用
    * 镜像和容器的清理工作，保证节点上镜像不会占满磁盘空间，退出的容器不会占用太多资源
    * 运行 HTTP Server，对外提供节点和 pod 信息，如果在 debug 模式下，还包括调试信息
    * 等等……
集群状态下，kubelet 会从 master 上读取信息，但其实 kubelet 还可以从其他地方获取节点的 pod 信息。目前 kubelet 支持三种数据源：
    * 本地文件
    * 通过 url 从网络上某个地址来获取信息
    * API Server：从 kubernetes master 节点获取信息
    o
  
  
  kubelet 主要功能
  Pod 管理
  在 kubernetes 的设计中，最基本的管理单位是 pod，而不是 container。pod 是 kubernetes 在容器上的一层封装，由一组运行在同一主机的一个或者多个容器组成。如果把容器比喻成传统机器上的一个进程（它可以执行任务，对外提供某种功能），那么 pod 可以类比为传统的主机：它包含了多个容器，为它们提供共享的一些资源。
  之所以费功夫提供这一层封装，主要是因为容器推荐的用法是里面只运行一个进程，而一般情况下某个应用都由多个组件构成的。
  pod 中所有的容器最大的特性也是最大的好处就是共享了很多资源，比如网络空间。pod 下所有容器共享网络和端口空间，也就是它们之间可以通过 localhost 访问和通信，对外的通信方式也是一样的，省去了很多容器通信的麻烦。
  除了网络之外，定义在 pod 里的 volume 也可以 mount 到多个容器里，以实现共享的目的。
  最后，定义在 pod 的资源限制（比如 CPU 和 Memory） 也是所有容器共享的。
  容器健康检查
  创建了容器之后，kubelet 还要查看容器是否正常运行，如果容器运行出错，就要根据设置的重启策略进行处理。检查容器是否健康主要有三种方式：执行命令，http Get，和tcp连接。
  不管用什么方式，如果检测到容器不健康，kubelet 会删除该容器，并根据容器的重启策略进行处理（比如重启，或者什么都不做）。
  容器监控
  kubelet 还有一个重要的责任，就是监控所在节点的资源使用情况，并定时向 master 报告。知道整个集群所有节点的资源情况，对于 pod 的调度和正常运行至关重要。
  kubelet 使用 cAdvisor 进行资源使用率的监控。cAdvisor 是 google 开源的分析容器资源使用和性能特性的工具，在 kubernetes 项目中被集成到 kubelet 里，无需额外配置。默认情况下，你可以在 localhost:4194 地址看到 cAdvisor 的管理界面。
  除了系统使用的 CPU，Memory，存储和网络之外，cAdvisor 还记录了每个容器使用的上述资源情况。