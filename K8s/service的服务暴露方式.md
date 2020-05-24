### service 的类型
service 支持的类型也就是 kubernetes 中服务暴露的方式，默认有四种 ClusterIP、NodePort、LoadBalancer、ExternelName，此外还有 Ingress，下面会详细介绍每种类型 service 的具体使用场景。

#### 1. ClusterIP
ClusterIP 类型的 service 是 kubernetes 集群默认的服务暴露方式，它只能用于集群内部通信，可以被各 pod 访问，其访问方式为：

pod ---> ClusterIP:ServicePort --> (iptables)DNAT --> PodIP:containePort
ClusterIP Service 类型的结构如下图所示:

ClusterIP

#### 2. NodePort
如果你想要在集群外访问集群内部的服务，可以使用这种类型的 service，NodePort 类型的 service 会在集群内部署了 kube-proxy 的节点打开一个指定的端口，之后所有的流量直接发送到这个端口，然后会被转发到 service 后端真实的服务进行访问。Nodeport 构建在 ClusterIP 上，其访问链路如下所示：

client ---> NodeIP:NodePort ---> ClusterIP:ServicePort ---> (iptables)DNAT ---> PodIP:containePort
其对应具体的 iptables 规则会在后文进行讲解。

NodePort service 类型的结构如下图所示:

NodePort

#### 3. LoadBalancer
LoadBalancer 类型的 service 通常和云厂商的 LB 结合一起使用，用于将集群内部的服务暴露到外网，云厂商的 LoadBalancer 会给用户分配一个 IP，之后通过该 IP 的流量会转发到你的 service 上。

LoadBalancer service 类型的结构如下图所示:

LoadBalancer

#### 4. ExternelName
通过 CNAME 将 service 与 externalName 的值(比如：foo.bar.example.com)映射起来，这种方式用的比较少。

#### 5. Ingress
Ingress 其实不是 service 的一个类型，但是它可以作用于多个 service，被称为 service 的 service，作为集群内部服务的入口，Ingress 作用在七层，可以根据不同的 url，将请求转发到不同的 service 上。

Ingress 的结构如下图所示:

Ingress

service 的服务发现
虽然 service 的 endpoints 解决了容器发现问题，但不提前知道 service 的 Cluster IP，怎么发现 service 服务呢？service 当前支持两种类型的服务发现机制，一种是通过环境变量，另一种是通过 DNS。在这两种方案中，建议使用后者。

环境变量
当一个 pod 创建完成之后，kubelet 会在该 pod 中注册该集群已经创建的所有 service 相关的环境变量，但是需要注意的是，在 service 创建之前的所有 pod 是不会注册该环境变量的，所以在平时使用时，建议通过 DNS 的方式进行 service 之间的服务发现。

DNS
可以在集群中部署 CoreDNS 服务(旧版本的 kubernetes 群使用的是 kubeDNS)， 来达到集群内部的 pod 通过DNS 的方式进行集群内部各个服务之间的通讯。

当前 kubernetes 集群默认使用 CoreDNS 作为默认的 DNS 服务，主要原因是 CoreDNS 是基于 Plugin 的方式进行扩展的，简单，灵活，并且不完全被Kubernetes所捆绑。

service 的使用
ClusterIP 方式
apiVersion: v1
kind: Service
metadata:
  name: my-nginx
spec:
  clusterIP: 10.105.146.177
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: my-nginx
  sessionAffinity: None
  type: ClusterIP
NodePort 方式
apiVersion: v1
kind: Service
metadata:
  name: my-nginx
spec:
  ports:
  - nodePort: 30090
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: my-nginx
  sessionAffinity: None
  type: NodePort
其中 nodeport 字段表示通过 nodeport 方式访问的端口，port 表示通过 service 方式访问的端口，targetPort 表示 container port。

Headless service(就是没有 Cluster IP 的 service )
当不需要负载均衡以及单独的 ClusterIP 时，可以通过指定 spec.clusterIP 的值为 None 来创建 Headless service，它会给一个集群内部的每个成员提供一个唯一的 DNS 域名来作为每个成员的网络标识，集群内部成员之间使用域名通信。

apiVersion: v1
kind: Service
metadata:
  name: my-nginx
spec:
  clusterIP: None
  ports:
  - nodePort: 30090
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: my-nginx
