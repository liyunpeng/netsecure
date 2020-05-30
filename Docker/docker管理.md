### 启动docker服务
systemctl 方式
守护进程重启
sudo systemctl daemon-reload
重启docker服务
sudo systemctl restart docker
关闭docker
sudo systemctl stop docker

---------
service 方式
重启docker服务
sudo service docker restart
关闭docker
sudo service docker stop

mac 启动docker的方式：
$ open /Applications/Docker.app

### 启动容器
查看镜像
$ sudo docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              a2a15febcdf3        4 weeks ago         64.2MB
hello-world         latest              fce289e99eb9        8 months ago        1.84kB

在镜像上创建容器并启动， run是创建容器加启动容器，-i表示交互, -t表示终端
$ sudo docker run -it --name docker3 ubuntu bash
root@133b58ff16bb:/#     // 133b58ff16bb表示在容器中

启动已经存在的容器， 要用id 启动
$ sudo docker start e2bfe689d80289f1c72ee7f7d0f317fc1b21c923fdc8ad7718ba573d406ffc53  -i
有-i能进入交互模式
$ sudo docker stop e2bfe689d80289f1c72ee7f7d0f317fc1b21c923fdc8ad7718ba573d406ffc53


### 查看容器
查看所有容器，包括在运行和不在运行的容器：
```gotemplate

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS                               NAMES
c324ac45b0ce        mysql:5.7           "docker-entrypoint.s…"   44 minutes ago      Exited (1) 44 minutes ago                                         hardcore_mcnulty
7e38db6727c5        redis:latest        "docker-entrypoint.s…"   11 hours ago        Exited (255) 51 minutes ago   0.0.0.0:6379->6379/tcp              redis
f59f8063893a        mysql:5.7           "docker-entrypoint.s…"   12 hours ago        Up 42 minutes                 0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```
查看正在运行的容器：

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
f59f8063893a        mysql:5.7           "docker-entrypoint.s…"   12 hours ago        Up 43 minutes       0.0.0.0:3306->3306/tcp, 33060/tcp   mysql

```
也可以用container ls列出正在运行的容器：

```
$ sudo docker container  ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
e2bfe689d802        ubuntu              "bash"              7 hours ago         Up 2 minutes                            docker1

```
启动容器，可以用短id启动, 也可以用长id启动：

```
$ sudo docker start -i e2bfe689d802  // -i 表示进入交互
root@e2bfe689d802:/# 

```
停止容器运行，但不删除容器：

```
$ sudo docker stop  e2bfe689d802

```

删除容器：
```
$ docker rm c324ac45b0ce
c324ac45b0ce

```

进入已经在运行的容器：

```gotemplate


mac :
$ docker exec -it d616fef8310a /bin/sh
linux :
$ docker exec -it d616fef8310a /bin/bashß

```
### 容器和宿主机共享数据卷

```
$ sudo docker volume ls
DRIVER              VOLUME NAME
local               v1

$ sudo docker volume inspect v1
[
    {
        "CreatedAt": "2019-09-14T02:30:28-07:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/snap/docker/common/var-lib-docker/volumes/v1/_data",
        "Name": "v1",
        "Options": {},
        "Scope": "local"
    }
]
```

docker 创建的数据卷是在宿主机下的， 所以/var/snap/docker/common/var-lib-docker/volumes/v1/_data是宿主机的目录

挂载数据卷必须在创建容器时， v1:/data1，/data1是容器中的目录， 这个目录如果镜像里不存在，就会在容器启动时创建 这些参数的顺序不要写错

```
$ sudo docker run -it -v v1:/tmp --name docker5 ubuntu bash
root@affe9358ee9d:/# touch /tmp/a   

```

在宿主机里可以看到这个在容器中创建的a, 实现了宿主机和容器的文件共享
```
$ sudo ls /var/snap/docker/common/var-lib-docker/volumes/v1/_data/ -l
total 0
-rw-r--r-- 1 root root 0 Sep 14 03:03 a

```
