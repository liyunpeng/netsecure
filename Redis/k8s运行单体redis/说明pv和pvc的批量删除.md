* pv是资源的定义， pvc是资源使用的定义， 并不是资源本体， 资源本体是网络文件系统，比如nfs. 所以pv和pvc的创建和删除，时间都是很短的。 
* statefulset, 需要使用volumeclaimtemplate模板来批量引用pvc, pvc的名字按
>volumeclaimtemplate的名字+pod名字=编号组成， 
>如data-redis-0

* pvc定义文件中的名字必须和模板里引用的匹配上， 有时可能写错了， 那就要删除pvc, 重新创建， 

* kubectl批量删除所得的pvc：
```
$ kubectl get pvc  | awk '{print $1}' |grep -v  NAME |xargs kubectl delete pvc
```
pv创建时， 实际是去挂载网络文件系统nfs, 如果没有安装nfs客户端， pv也需要删除再重建. 

* 批量删除所有的pv:
```
$ kubectl get pv  | awk '{print $1}' |grep -v  NAME |xargs kubectl delete pv
```
如果有pvc和pv绑定，那不能删除pv, 必须先删除pvc, 再删除pv。 
